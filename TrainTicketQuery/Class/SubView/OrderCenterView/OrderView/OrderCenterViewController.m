//
//  OrderCenterViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-19.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "OrderCenterViewController.h"
#import "Model.h"
#import "PassengerInfoViewController.h"
#import "OrderDetailViewController.h"
#import "ReturnTicketViewController.h"
#import "UserInfoViewController.h"
#import "OrderDetailCell.h"
#import "CustomButton.h"
#import "Utils.h"

@interface OrderCenterViewController ()

@end

@implementation OrderCenterViewController

@synthesize theTableView;
@synthesize dataSource;
@synthesize theTabBar;
@synthesize ThreeMonthAgo;
@synthesize ThreeMonth;
@synthesize orderDate;
@synthesize orderStatus;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [theTableView  release];
    [dataSource    release];
    [theTabBar     release];
    [ThreeMonthAgo release];
    [ThreeMonth    release];
    [super         dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
        orderStatus     = OrderWaitPay;
        orderDate       = OrderThreeMonth;
        
        self.dataSource = [NSMutableArray array];
        
        [self initView];
        [self setSubjoinViewFrame];
        [self setFooterViewFrame];
        
        //[self tabBar:theTabBar didSelectItem:[theTabBar.items objectAtIndex:0]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - request handle
- (void)requestOrderListWithDate:(OrderDate)date status:(OrderStatus)status
{
    [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 40 - 2.0f, self.view.frame.size.width, self.view.frame.size.height - 40 + 2.0f) belowView:nil enabled:NO];
    NSString *urlString = nil;
    if (date == OrderThreeMonthAgo) {
        urlString = [NSString stringWithFormat:@"%@/getHistoryOrders",TrainOrderServiceURL];
    }else if(date == OrderThreeMonth){
        if (status == OrderWaitPay) {
            urlString = [NSString stringWithFormat:@"%@/getWaitPayOrders",TrainOrderServiceURL];
        }else if (status == OrderProcess) {
            urlString = [NSString stringWithFormat:@"%@/getProcessOrders",TrainOrderServiceURL];
        }else if (status == OrderFinished) {
            urlString = [NSString stringWithFormat:@"%@/getFinishedOrders",TrainOrderServiceURL];
        }
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Utils NULLToEmpty:[UserDefaults shareUserDefault].userId],         @"userId",
                            [Utils nilToNumber:[NSNumber numberWithInteger:1]],                 @"pageNo",
                            [Utils nilToNumber:[NSNumber numberWithInteger:HUGE_VALF]],         @"pageSize",
                            nil];
    [self sendRequestWithURL:urlString params:params requestMethod:RequestPost userInfo:nil];
}

- (void)requestDone:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
    [self parserStringBegin:request];
}

- (void)parserStringFinished:(NSString *)_string request:(ASIHTTPRequest *)request
{
    if (!dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    [dataSource removeAllObjects];
    NSArray *array = [[_string JSONValue] objectForKey:@"performResult"];
    for (NSDictionary *dic in array) {
        TrainOrder *order = [[TrainOrder alloc]initWithPData:dic];
        [dataSource addObject:order];
    }
    [theTableView reloadData];
}

- (void)requestError:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
    [[Model shareModel] showPromptBoxWithText:@"请求失败" modal:NO];
}

#pragma mark - tableview delegate method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrainOrder *order = [dataSource objectAtIndex:indexPath.row];
    if (order.isUnfold) {
        return 160.0f;
    }else
        return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifierStr = @"cell";
    OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == nil) {
        cell = [[[OrderDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr]autorelease];
    }
    [cell.waitForPay removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    TrainOrder *order = [dataSource objectAtIndex:indexPath.row];
    [cell resetViewFrameWithUnfold:order.isUnfold];
    [cell.waitForPay setTitle:[order getOrderStatus] forState:UIControlStateNormal];
    cell.waitForPay.indexPath = indexPath;
    [cell.waitForPay addTarget:self action:@selector(payForTicket:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.orderCode setText:[NSString stringWithFormat:@"订单号:%@",order.orderNum]];
    [cell.routeLabel setText:[NSString stringWithFormat:@"行程：%@-%@  %@",order.startStation,order.endStation,order.trainCode]];
    [cell.scheduleLabel setText:[NSString stringWithFormat:@"日期：%@",order.trainStartTime]];
    [cell.totalPrice setText:[NSString stringWithFormat:@"总价：%lf元",order.totalAmount]];
    [cell.reserveDate setText:[NSString stringWithFormat:@"下单时间：%@",order.orderTime]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrainOrder *order = [dataSource objectAtIndex:indexPath.row];
    order.isUnfold = order.isUnfold?NO:YES;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)payForTicket:(CustomButton*)sender
{
    NSLog(@"touch");
    NSInteger row = sender.indexPath.row;
    TrainOrder *order = [dataSource objectAtIndex:row];
    switch (order.orderStatus) {
        case 1:{
            OrderDetailViewController *orderDetailView = [[[OrderDetailViewController alloc]initWithOrder:order]autorelease];
            orderDetailView.superDate = orderDate;
            orderDetailView.superStatus = orderStatus;
            [[Model shareModel] pushView:orderDetailView options:ViewTrasitionEffectMoveLeft completion:^{
                [[Model shareModel].viewControllers addObject:orderDetailView];
                [orderDetailView getTrainOrderDetails];
            }];
            break;
        }
        case 2:{
            OrderDetailViewController *orderDetailView = [[[OrderDetailViewController alloc]initWithOrder:order]autorelease];
            orderDetailView.superDate = orderDate;
            orderDetailView.superStatus = orderStatus;
            [[Model shareModel] pushView:orderDetailView options:ViewTrasitionEffectMoveLeft completion:^{
                [[Model shareModel].viewControllers addObject:orderDetailView];
                [orderDetailView getTrainOrderDetails];
            }];
            break;
        }
        case 4:{
            OrderDetailViewController *orderDetailView = [[[OrderDetailViewController alloc]initWithOrder:order]autorelease];
            orderDetailView.superDate = orderDate;
            orderDetailView.superStatus = orderStatus;
            [[Model shareModel] pushView:orderDetailView options:ViewTrasitionEffectMoveLeft completion:^{
                [[Model shareModel].viewControllers addObject:orderDetailView];
                [orderDetailView getTrainOrderDetails];
            }];
            break;
        }
        case 5:{
            OrderDetailViewController *orderDetailView = [[[OrderDetailViewController alloc]initWithOrder:order]autorelease];
            orderDetailView.superDate = orderDate;
            orderDetailView.superStatus = orderStatus;
            [[Model shareModel] pushView:orderDetailView options:ViewTrasitionEffectMoveLeft completion:^{
                [[Model shareModel].viewControllers addObject:orderDetailView];
                [orderDetailView getTrainOrderDetails];
            }];
            break;
        }
        case 6:{
            OrderDetailViewController *orderDetailView = [[[OrderDetailViewController alloc]initWithOrder:order]autorelease];
            orderDetailView.superDate = orderDate;
            orderDetailView.superStatus = orderStatus;
            [[Model shareModel] pushView:orderDetailView options:ViewTrasitionEffectMoveLeft completion:^{
                [[Model shareModel].viewControllers addObject:orderDetailView];
                [orderDetailView getTrainOrderDetails];
            }];
            break;
        }
        case 7:{
            OrderDetailViewController *orderDetailView = [[[OrderDetailViewController alloc]initWithOrder:order]autorelease];
            orderDetailView.superDate = orderDate;
            orderDetailView.superStatus = orderStatus;
            [[Model shareModel] pushView:orderDetailView options:ViewTrasitionEffectMoveLeft completion:^{
                [[Model shareModel].viewControllers addObject:orderDetailView];
                [orderDetailView getTrainOrderDetails];
            }];
            break;
        }
        case 10:{
            ReturnTicketViewController *returnTicketView = [[[ReturnTicketViewController alloc]init]autorelease];
            [[Model shareModel] pushView:returnTicketView options:ViewTrasitionEffectMoveLeft completion:^{
                
            }];
            break;
        }
        case 11:{
            OrderDetailViewController *orderDetailView = [[[OrderDetailViewController alloc]initWithOrder:order]autorelease];
            orderDetailView.superDate = orderDate;
            orderDetailView.superStatus = orderStatus;
            [[Model shareModel] pushView:orderDetailView options:ViewTrasitionEffectMoveLeft completion:^{
                [[Model shareModel].viewControllers addObject:orderDetailView];
                [orderDetailView getTrainOrderDetails];
            }];
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - delegate method
- (void)tabBar:(UITabBar *)_tabBar didSelectItem:(UITabBarItem *)item
{
    UIImageView *imageView1 = (UIImageView*)[self.view viewWithTag:201];
    UIImageView *imageView2 = (UIImageView*)[self.view viewWithTag:202];
    UIImageView *imageView3 = (UIImageView*)[self.view viewWithTag:203];
    NSInteger index = [_tabBar.items indexOfObject:item];
    switch (index) {
        case 0:
            imageView1.highlighted = YES;
            imageView2.highlighted = NO;
            imageView3.highlighted = NO;
            
            orderStatus = OrderWaitPay;
            break;
        case 1:
            imageView1.highlighted = NO;
            imageView2.highlighted = YES;
            imageView3.highlighted = NO;
            
            orderStatus = OrderProcess;
            break;
        case 2:
            imageView1.highlighted = NO;
            imageView2.highlighted = NO;
            imageView3.highlighted = YES;
            
            orderStatus = OrderFinished;
            break;
        
        default:
            break;
    }
    [self requestOrderListWithDate:orderDate status:orderStatus];
}

- (void)segmentedControlPress:(UISegmentedControl*)seg
{
    switch (seg.selectedSegmentIndex) {
        case 0:
            [self threeMonthListShow];
            break;
        case 1:
            [self threeMonthAgoListShow];
            break;
            
        default:
            break;
    }
}

- (void)threeMonthAgoListShow{
    for (UITabBarItem *item in theTabBar.items) {
        item.enabled = NO;
    }
    self.ThreeMonthAgo.highlighted = YES;
    self.ThreeMonth.highlighted    = NO;
    
    orderDate = OrderThreeMonthAgo;
    [self requestOrderListWithDate:orderDate status:orderStatus];
}

- (void)threeMonthListShow{
    for (UITabBarItem *item in theTabBar.items) {
        item.enabled = YES;
    }
    self.ThreeMonthAgo.highlighted = NO;
    self.ThreeMonth.highlighted    = YES;
    
    orderDate = OrderThreeMonth;
    [self requestOrderListWithDate:orderDate status:orderStatus];
}

#pragma mark - other method
- (void)pressReturnButton:(UIButton*)sender
{
    BaseUIViewController *prevView = [[Model shareModel].viewControllers objectAtIndex:([[Model shareModel].viewControllers indexOfObject:self] - 1)];
    [[Model shareModel] pushView:prevView options:ViewTrasitionEffectMoveRight completion:^{
        [[Model shareModel].viewControllers removeObject:self];
    }];
}

- (void)pressRightButton:(UIButton*)sender
{
    UserInfoViewController *userInfoView = [[[UserInfoViewController alloc]init]autorelease];
    [[Model shareModel] pushView:userInfoView options:ViewTrasitionEffectMoveLeft completion:^{
        [[Model shareModel].viewControllers addObject:userInfoView];
        [userInfoView getUserInfo:[[UserDefaults shareUserDefault].userId integerValue]];
    }];
    
//    PassengerInfoViewController *passengerInfo = [[[PassengerInfoViewController alloc]init]autorelease];
//    [[Model shareModel] pushView:passengerInfo options:ViewTrasitionEffectMoveLeft completion:^{
//        [[Model shareModel].viewControllers addObject:passengerInfo];
//        [passengerInfo getPassengers];
//    }];
}

#pragma mark - view init
- (void)initView
{
    UIImageView *backImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
    [backImageView setImage:imageNameAndType(@"backgroundimage", @"png")];
    [self.view addSubview:backImageView];
    
    UIImageView *topImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, -1, self.view.frame.size.width, 40 + 1)]autorelease];
    [topImageView setImage:imageNameAndType(@"topbar_image", @"png")];
    [self.view addSubview:topImageView];
    
    UILabel *titleLabel = [self getLabelWithFrame:CGRectMake(80, 0, 160, 40) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] title:@"订单中心" font:nil];
    [self.view addSubview:titleLabel];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateSelected];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(pressReturnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(selfViewFrame.size.width - returnBtn.frame.size.width, returnBtn.frame.origin.y, returnBtn.frame.size.width, returnBtn.frame.size.height);
    [rightBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"contacts_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"contacts_press" ofType:@"png"]] forState:UIControlStateSelected];
    [rightBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"contacts_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(pressRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
}

- (void)setSubjoinViewFrame
{
    self.ThreeMonth = [self getButtonWithFrame:CGRectMake(15, 40 + 10, (selfViewFrame.size.width - 30)/2, 35) title:@"三个月内订单" textColor:[UIColor blackColor] forState:UIControlStateNormal backGroundColor:[UIColor clearColor]];
    ThreeMonth.tag = 101;
    [ThreeMonth setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [ThreeMonth.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [ThreeMonth setBackgroundImage:imageNameAndType(@"order_normal", @"png") forState:UIControlStateNormal];
    [ThreeMonth setBackgroundImage:imageNameAndType(@"order_select", @"png") forState:UIControlStateHighlighted];
    
    self.ThreeMonthAgo = [self getButtonWithFrame:CGRectMake(ThreeMonth.frame.origin.x + ThreeMonth.frame.size.width, ThreeMonth.frame.origin.y, ThreeMonth.frame.size.width, ThreeMonth.frame.size.height) title:@"三个月前订单" textColor:[UIColor blackColor] forState:UIControlStateNormal backGroundColor:[UIColor clearColor]];
    ThreeMonthAgo.tag = 102;
    [ThreeMonthAgo setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [ThreeMonthAgo.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [ThreeMonthAgo setBackgroundImage:imageNameAndType(@"order_normal", @"png") forState:UIControlStateNormal];
    [ThreeMonthAgo setBackgroundImage:imageNameAndType(@"order_select", @"png") forState:UIControlStateHighlighted];
    
    [self.view addSubview:ThreeMonth];
    [self.view addSubview:ThreeMonthAgo];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"1",@"2"]];
    segmentedControl.frame = CGRectMake(ThreeMonth.frame.origin.x, ThreeMonth.frame.origin.y, ThreeMonth.frame.size.width * 2, ThreeMonth.frame.size.height);
    segmentedControl.alpha = 0.1;
    segmentedControl.backgroundColor = [UIColor clearColor];
    [segmentedControl addTarget:self action:@selector(segmentedControlPress:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, segmentedControl.frame.origin.y + segmentedControl.frame.size.height + 20, selfViewFrame.size.width, selfViewFrame.size.height - 40 - segmentedControl.frame.origin.y - segmentedControl.frame.size.height - 20 - 10) style:UITableViewStylePlain];
    theTableView.dataSource = self;
    theTableView.delegate   = self;
    theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [theTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:theTableView];
}

- (void)setFooterViewFrame
{
    UIImageView *imageView1 = [self getImageViewWithFrame:CGRectMake(0, selfViewFrame.size.height - 40, selfViewFrame.size.width/3, 40) image:imageNameAndType(@"obligation_normal", @"png") highLightImage:imageNameAndType(@"obligation_press", @"png") backGroundColor:[UIColor clearColor]];
    imageView1.tag = 201;
    imageView1.highlighted = YES;
    [self.view addSubview:imageView1];
    
    UIImageView *imageView2 = [self getImageViewWithFrame:CGRectMake(selfViewFrame.size.width/3, imageView1.frame.origin.y, imageView1.frame.size.width, imageView1.frame.size.height) image:imageNameAndType(@"dispose_normal", @"png") highLightImage:imageNameAndType(@"dispose_press", @"png") backGroundColor:[UIColor clearColor]];
    imageView2.tag = 202;
    [self.view addSubview:imageView2];
    
    UIImageView *imageView3 = [self getImageViewWithFrame:CGRectMake(selfViewFrame.size.width*2/3, imageView1.frame.origin.y, imageView1.frame.size.width, imageView1.frame.size.height) image:imageNameAndType(@"takeout_normal", @"png") highLightImage:imageNameAndType(@"takeout_press", @"png") backGroundColor:[UIColor clearColor]];
    imageView3.tag = 203;
    [self.view addSubview:imageView3];
    /*
     imageView1.highlighted = YES;
     imageView2.highlighted = NO;
     imageView3.highlighted = NO;
     */
    theTabBar = [[UITabBar alloc]initWithFrame:CGRectMake(0, selfViewFrame.size.height - 40, selfViewFrame.size.width, 40)];
    //theTabBar.frame = CGRectMake(0, selfViewFrame.size.height - 40, selfViewFrame.size.width, 40);
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0; i<3; i++) {
        UITabBarItem *item = [[[UITabBarItem alloc]init]autorelease];
        [items addObject:item];
    }
    theTabBar.items = items;
    theTabBar.alpha = 0.1;
    theTabBar.delegate = self;
    [self.view addSubview:theTabBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
