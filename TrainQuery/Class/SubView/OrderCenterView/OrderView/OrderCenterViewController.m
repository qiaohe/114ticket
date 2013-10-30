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

@synthesize refreshHeaderView;
@synthesize loadMoreView;
@synthesize hasMoreData;
@synthesize pageNO;
@synthesize theTableView;
@synthesize dataSource;
@synthesize theTabBar;
@synthesize ThreeMonthAgo;
@synthesize ThreeMonth;
@synthesize orderDate;
@synthesize orderStatus;
@synthesize logUserName;
@synthesize segmentedControl;

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
    if (loadMoreView )    self.loadMoreView         = nil;
    if (theTableView )    self.theTableView         = nil;
    if (dataSource   )    self.dataSource           = nil;
    if (theTabBar    )    self.theTabBar            = nil;
    if (ThreeMonthAgo)    self.ThreeMonthAgo        = nil;
    if (ThreeMonth   )    self.ThreeMonth           = nil;
    if (logUserName  )    self.logUserName          = nil;
    if (segmentedControl) self.segmentedControl     = nil;
    [super                   dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
        orderStatus     = OrderWaitPay;
        orderDate       = OrderThreeMonth;
        pageNO          = 1;
        
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
    [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height + 20.0f) belowView:nil enabled:NO];
    NSString *urlString = nil;
    NSString *emptyMsg  = nil;
    if (date == OrderThreeMonthAgo) {
        urlString = [NSString stringWithFormat:@"%@/getHistoryOrders",TrainOrderServiceURL];
        emptyMsg  = @"没有三个月前订单";
    }else if(date == OrderThreeMonth){
        if (status == OrderWaitPay) {
            urlString = [NSString stringWithFormat:@"%@/getWaitPayOrders",TrainOrderServiceURL];
            emptyMsg  = @"没有待付款订单";
        }else if (status == OrderProcess) {
            urlString = [NSString stringWithFormat:@"%@/getProcessOrders",TrainOrderServiceURL];
            emptyMsg  = @"没有待处理订单";
        }else if (status == OrderFinished) {
            urlString = [NSString stringWithFormat:@"%@/getFinishedOrders",TrainOrderServiceURL];
            emptyMsg  = @"没有已出票订单";
        }
    }else{
        urlString = @"";
        emptyMsg  = @"";
    }
    pageNO = 1;
    NSInteger size = pageSize;
    if (date == OrderThreeMonth && (status == OrderWaitPay || status == OrderProcess)) {
        size = NSIntegerMax;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Utils NULLToEmpty:[UserDefaults shareUserDefault].userId],         @"userId",
                            [Utils nilToNumber:[NSNumber numberWithInteger:pageNO]],            @"pageNo",
                            [Utils nilToNumber:[NSNumber numberWithInteger:size]],          @"pageSize",
                            nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"requestOrderList",                  @"requestType",
                              emptyMsg,                             @"emptyMsg",
                              nil];
    [self sendRequestWithURL:urlString params:params requestMethod:RequestPost userInfo:userInfo];
}

- (void)loadMoreDataWithDate:(OrderDate)date status:(OrderStatus)status
{
    [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 40 - 2.0f, self.view.frame.size.width, self.view.frame.size.height - 40 + 2.0f) belowView:nil enabled:NO];
    NSString *urlString = nil;
    NSString *emptyMsg  = nil;
    if (date == OrderThreeMonthAgo) {
        urlString = [NSString stringWithFormat:@"%@/getHistoryOrders",TrainOrderServiceURL];
        emptyMsg  = @"没有三个月前订单";
    }else if(date == OrderThreeMonth){
        if (status == OrderWaitPay) {
            urlString = [NSString stringWithFormat:@"%@/getWaitPayOrders",TrainOrderServiceURL];
            emptyMsg  = @"没有待付款订单";
        }else if (status == OrderProcess) {
            urlString = [NSString stringWithFormat:@"%@/getProcessOrders",TrainOrderServiceURL];
            emptyMsg  = @"没有待处理订单";
        }else if (status == OrderFinished) {
            urlString = [NSString stringWithFormat:@"%@/getFinishedOrders",TrainOrderServiceURL];
            emptyMsg  = @"没有已出票订单";
        }
    }else{
        urlString = @"";
        emptyMsg  = @"";
    }
    pageNO ++;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Utils NULLToEmpty:[UserDefaults shareUserDefault].userId],         @"userId",
                            [Utils nilToNumber:[NSNumber numberWithInteger:pageNO]],            @"pageNo",
                            [Utils nilToNumber:[NSNumber numberWithInteger:pageSize]],          @"pageSize",
                            nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"loadMoreData",                  @"requestType",
                              emptyMsg,                         @"emptyMsg",
                              nil];
    [self sendRequestWithURL:urlString params:params requestMethod:RequestPost userInfo:userInfo];
}

- (void)pressLogOutBtn:(UIButton *)sender
{
    [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 0, selfViewFrame.size.width, selfViewFrame.size.height) belowView:nil enabled:NO];
    NSString *urlString = [NSString stringWithFormat:@"%@/logout",UserServiceURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [UserDefaults shareUserDefault].cookie,  @"Cookie",
                                   nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInteger:RequestLogOut],             @"requestType",
                              nil];
    
    [self sendRequestWithURL:urlString params:params requestMethod:RequestLogOut userInfo:userInfo];
}

- (void)requestDone:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
    [self parserStringBegin:request];
}

- (void)parserStringFinished:(NSString *)_string request:(ASIHTTPRequest *)request
{
    NSString *requestType = [NSString stringWithFormat:@"%@",[request.userInfo objectForKey:@"requestType"]];
    if ([requestType integerValue] == RequestLogOut) {
        if ([[[_string JSONValue] objectForKey:@"performStatus"] isEqualToString:@"success"]) {
            [[UserDefaults shareUserDefault] clearDefaults];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else{
        NSMutableArray *dataArray = [NSMutableArray array];

        if (!dataSource) {
            self.dataSource = [NSMutableArray array];
        }
        if ([requestType isEqualToString:@"requestOrderList"]) {
            [dataSource removeAllObjects];
        }
        NSArray *array = [[_string JSONValue] objectForKey:@"performResult"];
        for (NSDictionary *dic in array) {
            TrainOrder *order = [[[TrainOrder alloc]initWithPData:dic]autorelease];
            [dataArray addObject:order];
        }
        if ([dataArray count] == pageSize) {
            if (orderDate == OrderThreeMonth && (orderStatus == OrderWaitPay || orderStatus == OrderProcess)) {
                loadMoreView.haveMoreData = NO;
            }else{
                loadMoreView.haveMoreData = YES;
            }
        }else{
            loadMoreView.haveMoreData = NO;
        }
        [dataSource addObjectsFromArray:dataArray];
        if ([dataSource count] == 0) {
            [[Model shareModel] showPromptBoxWithText:[request.userInfo objectForKey:@"emptyMsg"] modal:NO];
        }
        [self tableView:theTableView reloadWithDataSource:dataSource];
        if ([requestType isEqualToString:@"requestOrderList"]) {
            [theTableView setContentOffset:CGPointMake(0, 0)];
        }
    }
    if (loadMoreView.isLoading) {
        [loadMoreView loadingMoreTableDataSourceDidFinishedLoading:theTableView];
    }
}

- (void)requestError:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
    [[Model shareModel] showPromptBoxWithText:@"请求失败" modal:NO];
}

#pragma mark - tableview delegate method
- (void)tableView:(UITableView *)tableView reloadWithDataSource:(NSArray*)_dataSource
{/*
    if (tableView.tableFooterView) {
        [tableView setTableFooterView:nil];
    }*/
    if (loadMoreView.haveMoreData) {
        [tableView setTableFooterView:loadMoreView];
    }else{
        [tableView setTableFooterView:nil];
    }
    [theTableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrainOrder *order = [dataSource objectAtIndex:indexPath.row];
    if (order.isUnfold) {
        return 140.0f;
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
    [cell setButtonStatusWithInfo:order];
    
    [cell.orderCode setText:[NSString stringWithFormat:@"订单号:%@",order.orderNum]];
    [cell.routeLabel setText:[NSString stringWithFormat:@"行程：%@-%@  %@",order.startStation,order.endStation,order.trainCode]];
    [cell.scheduleLabel setText:[NSString stringWithFormat:@"日期：%@",order.trainStartTime]];
    [cell.totalPrice setText:[NSString stringWithFormat:@"总价：%.2lf元",order.totalAmount]];
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
        case 1:{//未付款
            OrderDetailViewController *orderDetailView = [[[OrderDetailViewController alloc]initWithOrder:order]autorelease];
            orderDetailView.superDate = orderDate;
            orderDetailView.superStatus = orderStatus;
            [self pushViewController:orderDetailView completion:^{
                [orderDetailView getTrainOrderDetails];
            }];

            break;
        }
        case 2:{//已付款
            OrderDetailViewController *orderDetailView = [[[OrderDetailViewController alloc]initWithOrder:order]autorelease];
            orderDetailView.superDate = orderDate;
            orderDetailView.superStatus = orderStatus;
            [self pushViewController:orderDetailView completion:^{
                [orderDetailView getTrainOrderDetails];
            }];
 
            break;
        }
        case 4:{//票款不足
            OrderDetailViewController *orderDetailView = [[[OrderDetailViewController alloc]initWithOrder:order]autorelease];
            orderDetailView.superDate = orderDate;
            orderDetailView.superStatus = orderStatus;
            [self pushViewController:orderDetailView completion:^{
                [orderDetailView getTrainOrderDetails];
            }];

            break;
        }
        case 5:{//网上待付
            OrderDetailViewController *orderDetailView = [[[OrderDetailViewController alloc]initWithOrder:order]autorelease];
            orderDetailView.superDate = orderDate;
            orderDetailView.superStatus = orderStatus;
            [self pushViewController:orderDetailView completion:^{
                [orderDetailView getTrainOrderDetails];
            }];

            break;
        }
        case 6:{//无票
            OrderDetailViewController *orderDetailView = [[[OrderDetailViewController alloc]initWithOrder:order]autorelease];
            orderDetailView.superDate = orderDate;
            orderDetailView.superStatus = orderStatus;
            [self pushViewController:orderDetailView completion:^{
                [orderDetailView getTrainOrderDetails];
            }];
  
            break;
        }
        case 7:{//已补款
            OrderDetailViewController *orderDetailView = [[[OrderDetailViewController alloc]initWithOrder:order]autorelease];
            orderDetailView.superDate = orderDate;
            orderDetailView.superStatus = orderStatus;
            [self pushViewController:orderDetailView completion:^{
                [orderDetailView getTrainOrderDetails];
            }];

            break;
        }
        case 10:{//出票成功
            ReturnTicketViewController *returnTicketView = [[[ReturnTicketViewController alloc]initWithTrainOrder:order]autorelease];
            [self pushViewController:returnTicketView completion:^{
                [returnTicketView getTrainOrderDetails];
            }];
            break;
        }
        case 11:{//申请退票
            ReturnTicketViewController *returnTicketView = [[[ReturnTicketViewController alloc]initWithTrainOrder:order]autorelease];
            [self pushViewController:returnTicketView completion:^{
                [returnTicketView getTrainOrderDetails];
            }];

            break;
        }
        case 12:{//退票完成
            ReturnTicketViewController *returnTicketView = [[[ReturnTicketViewController alloc]initWithTrainOrder:order]autorelease];
            [self pushViewController:returnTicketView completion:^{
                [returnTicketView getTrainOrderDetails];
            }];
            break;
        }case -1:{
            OrderDetailViewController *orderDetailView = [[[OrderDetailViewController alloc]initWithOrder:order]autorelease];
            orderDetailView.superDate = orderDate;
            orderDetailView.superStatus = orderStatus;
            [self pushViewController:orderDetailView completion:^{
                [orderDetailView getTrainOrderDetails];
            }];
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - scrollview did scroll
- (void)didTriggerLoadingMore:(LoadingMoreTableFooterView*)view
{
    if (loadMoreView.haveMoreData) {
        loadMoreView.isLoading = YES;
        [self loadMoreDataWithDate:orderDate status:orderStatus];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [loadMoreView loadingMoreTableScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [loadMoreView loadingMoreTableScrollViewDidEndDragging:scrollView];
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
    
    UIImageView *imageView1 = (UIImageView*)[self.view viewWithTag:201];
    UIImageView *imageView2 = (UIImageView*)[self.view viewWithTag:202];
    UIImageView *imageView3 = (UIImageView*)[self.view viewWithTag:203];
    
    imageView1.highlighted  = NO;
    imageView2.highlighted  = NO;
    imageView3.highlighted  = NO;
    self.ThreeMonthAgo.highlighted = YES;
    self.ThreeMonth.highlighted    = NO;
    
    orderDate = OrderThreeMonthAgo;
    
    theTabBar.hidden   = YES;
    imageView1.hidden  = YES;
    imageView2.hidden  = YES;
    imageView3.hidden  = YES;
    
    [theTableView setFrame:CGRectMake(15, segmentedControl.frame.origin.y + segmentedControl.frame.size.height + 20, selfViewFrame.size.width - 30.0f, selfViewFrame.size.height - 40 - segmentedControl.frame.origin.y - segmentedControl.frame.size.height - 20 - 10 + theTabBar.frame.size.height)];
    
    [self requestOrderListWithDate:orderDate status:orderStatus];
}

- (void)threeMonthListShow{
    for (UITabBarItem *item in theTabBar.items) {
        item.enabled = YES;
    }
    self.ThreeMonthAgo.highlighted = NO;
    self.ThreeMonth.highlighted    = YES;
    
    UIImageView *imageView1 = (UIImageView*)[self.view viewWithTag:201];
    UIImageView *imageView2 = (UIImageView*)[self.view viewWithTag:202];
    UIImageView *imageView3 = (UIImageView*)[self.view viewWithTag:203];
    switch (orderStatus) {
        case OrderWaitPay:{
            imageView1.highlighted  = YES;
            imageView2.highlighted  = NO;
            imageView3.highlighted  = NO;
            break;
        }case OrderProcess:{
            imageView1.highlighted = NO;
            imageView2.highlighted = YES;
            imageView3.highlighted = NO;
            break;
        }case OrderFinished:{
            imageView1.highlighted = NO;
            imageView2.highlighted = NO;
            imageView3.highlighted = YES;
            break;
        }
        default:
            break;
    }
    
    theTabBar.hidden   = NO;
    imageView1.hidden  = NO;
    imageView2.hidden  = NO;
    imageView3.hidden  = NO;
    
    [theTableView setFrame:CGRectMake(15, segmentedControl.frame.origin.y + segmentedControl.frame.size.height + 20, selfViewFrame.size.width - 30.0f, selfViewFrame.size.height - 40 - segmentedControl.frame.origin.y - segmentedControl.frame.size.height - 20 - 10)];
    
    orderDate = OrderThreeMonth;
    [self requestOrderListWithDate:orderDate status:orderStatus];
}

#pragma mark - other method
- (void)pressReturnButton:(UIButton*)sender
{
    [self popViewControllerCompletion:nil];
}

- (void)pressRightButton:(UIButton*)sender
{
    UserInfoViewController *userInfoView = [[[UserInfoViewController alloc]init]autorelease];
    [self pushViewController:userInfoView completion:^{
        [userInfoView getUserInfo:[[UserDefaults shareUserDefault].userId integerValue]];
    }];
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
    UIImageView *subjoinImage = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 40 - 2, self.view.frame.size.width, 40)]autorelease];
    [subjoinImage setBackgroundColor:[UIColor clearColor]];
    [subjoinImage setImage:imageNameAndType(@"logstatus", @"png")];
    [self.view addSubview:subjoinImage];
    
    logUserName = [[UILabel alloc]initWithFrame:CGRectMake(subjoinImage.frame.origin.x + 15, subjoinImage.frame.origin.y, subjoinImage.frame.size.width*2/3 - 15, subjoinImage.frame.size.height)];
    [logUserName setBackgroundColor:[UIColor clearColor]];
    [logUserName setFont:[UIFont systemFontOfSize:13]];
    [logUserName setText:[NSString stringWithFormat:@"%@,你好",[UserDefaults shareUserDefault].userName]];
    [self.view addSubview:logUserName];
    
    UIButton *logOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logOutBtn setFrame:CGRectMake(subjoinImage.frame.size.width - 80, subjoinImage.frame.origin.y, 80, 40)];
    [logOutBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [logOutBtn setBackgroundColor:[UIColor clearColor]];
    [logOutBtn setBackgroundImage:imageNameAndType(@"logout_normal", @"png") forState:UIControlStateNormal];
    [logOutBtn setBackgroundImage:imageNameAndType(@"logout_press", @"png") forState:UIControlStateHighlighted];
    [logOutBtn setBackgroundImage:imageNameAndType(@"logout_press", @"png") forState:UIControlStateSelected];
    [logOutBtn setTitle:@"退出" forState:UIControlStateNormal];
    [logOutBtn addTarget:self action:@selector(pressLogOutBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logOutBtn];
    
    self.ThreeMonth = [self getButtonWithFrame:CGRectMake(15, 40 + subjoinImage.frame.size.height + 10, (selfViewFrame.size.width - 30)/2, 35) title:@"三个月内订单" textColor:[UIColor blackColor] forState:UIControlStateNormal backGroundColor:[UIColor clearColor]];
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
    
    segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"1",@"2"]];
    segmentedControl.frame = CGRectMake(ThreeMonth.frame.origin.x, ThreeMonth.frame.origin.y, ThreeMonth.frame.size.width * 2, ThreeMonth.frame.size.height);
    segmentedControl.alpha = 0.1;
    segmentedControl.backgroundColor = [UIColor clearColor];
    [segmentedControl addTarget:self action:@selector(segmentedControlPress:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(15, segmentedControl.frame.origin.y + segmentedControl.frame.size.height + 20, selfViewFrame.size.width - 30.0f, selfViewFrame.size.height - 40 - segmentedControl.frame.origin.y - segmentedControl.frame.size.height - 20 - 10) style:UITableViewStylePlain];
    theTableView.dataSource = self;
    theTableView.delegate   = self;
    theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [theTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:theTableView];
    
    loadMoreView = [[LoadingMoreTableFooterView alloc]initWithFrame:CGRectMake(0, 0, theTableView.frame.size.width, 70.0f)];
    loadMoreView.delegate = self;
    loadMoreView.haveMoreData = NO;
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
