//
//  ReturnTicketViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-22.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "ReturnTicketViewController.h"
#import "Model.h"
#import "Utils.h"

@interface ReturnTicketViewController ()

@end

@implementation ReturnTicketViewController

@synthesize trainOrder;
@synthesize orderCode;
@synthesize totalPrice;
@synthesize trainCodeAndRoute;
@synthesize startDate;
@synthesize theTableView;
@synthesize dataSource;
@synthesize selectDataSource;

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
    [trainOrder              release];
    [orderCode               release];
    [totalPrice              release];
    [trainCodeAndRoute       release];
    [startDate               release];
    [theTableView            release];
    [dataSource              release];
    [selectDataSource        release];
    [super                   dealloc];
}

- (id)initWithTrainOrder:(TrainOrder*)_trainOrder
{
    self = [super init];
    if (self) {
        self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
        self.dataSource = [NSMutableArray array];
        self.selectDataSource = [NSMutableArray array];
        self.trainOrder = _trainOrder;
        [self initView];
    }
    return self;
}

- (void)getTrainOrderDetails
{
    [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 40.0f - 1.5f, self.view.frame.size.width, self.view.frame.size.height - 40.0f + 1.5f) belowView:nil enabled:NO];
    NSString *urlString = [NSString stringWithFormat:@"%@/getTrainOrder",TrainOrderServiceURL];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            //[Utils NULLToEmpty:[UserDefaults shareUserDefault].userId],                         @"userId",
                            [Utils nilToNumber:[NSNumber numberWithInteger:trainOrder.orderId]],                @"orderId",
                            nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"getOrderDetails",                      @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params requestMethod:RequestPost userInfo:userInfo];
}

#pragma mark - request handle
- (void)requestDone:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
    [self parserStringBegin:request];
}

- (void)parserStringFinished:(NSString *)_string request:(ASIHTTPRequest *)request
{
    NSDictionary *dic = [_string JSONValue];
    NSString *requestType = [request.userInfo objectForKey:@"requestType"];
    if ([[dic objectForKey:@"performStatus"] isEqualToString:@"success"]) {
        [[Model shareModel] showPromptBoxWithText:[dic objectForKey:@"performStatus"] modal:YES];

        if ([requestType isEqualToString:@"getOrderDetails"]) {
            NSDictionary *dataDic = [dic objectForKey:@"performResult"];
            [dataSource removeAllObjects];
            TrainOrder *order = [[[TrainOrder alloc]initWithPData:dataDic]autorelease];
            if (order.trainOrderDetails) {
                self.dataSource = order.trainOrderDetails;
            }
            [self reloadData];
        }
    }
}

- (void)requestError:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
    [[Model shareModel] showPromptBoxWithText:@"请求失败" modal:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)reloadData
{
    CGFloat tableViewHeight = 60*[dataSource count]<selfViewFrame.size.height - startDate.frame.origin.y - startDate.frame.size.height - 90?60*[dataSource count]:selfViewFrame.size.height - startDate.frame.origin.y - startDate.frame.size.height - 100;
    [theTableView setFrame:CGRectMake(0, startDate.frame.origin.y + startDate.frame.size.height, selfViewFrame.size.width, tableViewHeight + 8)];
    [theTableView reloadData];
    [orderCode  setText:[NSString stringWithFormat:@"%@",trainOrder.orderNum]];
    [totalPrice setText:[NSString stringWithFormat:@"%.2f",trainOrder.totalAmount]];
    [trainCodeAndRoute setText:[NSString stringWithFormat:@"%@  %@ - %@",trainOrder.trainCode,trainOrder.startStation,trainOrder.endStation]];
    [startDate setText:[NSString stringWithFormat:@"%@",trainOrder.trainStartTime]];
}

#pragma mark - table view delegate method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierStr = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == nil) {
        cell = [self createTableViewCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr];
    }
    TrainOrderDetail *orderDetail = [dataSource objectAtIndex:indexPath.row];
    
    UILabel *ticketType = (UILabel*)[cell viewWithTag:102];
    UILabel *papersTypeAndNum = (UILabel*)[cell viewWithTag:103];
    UIButton *statusButton = (UIButton*)[cell viewWithTag:104];
    
    if ([orderDetail.seatType integerValue] == 11) {
        [statusButton setTitle:@"申请退票" forState:UIControlStateNormal];
    }else if ([orderDetail.seatType integerValue] == 12){
        [statusButton setTitle:@"退票完成" forState:UIControlStateNormal];
    }else{
        [statusButton setTitle:[NSString stringWithFormat:@"%@",orderDetail.seatType] forState:UIControlStateNormal];
    }
    
    NSString *certificateType = nil;
    if ([orderDetail.cardType isEqualToString:@"0"]) {
        certificateType = @"身份证";
    }else if ([orderDetail.cardType isEqualToString:@"1"]) {
        certificateType = @"护照";
    }else{
        certificateType = @"港澳通行证";
    }
    
    NSString *str1 = nil;
    
    NSString *str2 = nil;
    if (orderDetail.type == TicketMan) {
        str1 = [NSString stringWithFormat:@"成人票:%@",orderDetail.userName];
        str2 = [NSString stringWithFormat:@"%@:%@",certificateType,orderDetail.idCard];
    }else if(orderDetail.type == TicketChildren){
        str1 = [NSString stringWithFormat:@"儿童票:%@",orderDetail.userName];
        str2 = [NSString stringWithFormat:@"出生日期:%@",orderDetail.birthdate];
    }else{
        str1 = [NSString stringWithFormat:@"成人票:%@",orderDetail.userName];
        str2 = [NSString stringWithFormat:@"%@:%@",certificateType,orderDetail.idCard];
    }
    [ticketType setText:str1];
    [papersTypeAndNum setText:str2];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrainOrderDetail *orderDetail = [dataSource objectAtIndex:indexPath.row];
    if (orderDetail.canReturnTicket) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *imageView = (UIImageView*)[cell viewWithTag:101];
        imageView.highlighted = imageView.highlighted?NO:YES;
        if (imageView.highlighted) {
            if (![selectDataSource containsObject:orderDetail]) {
                [selectDataSource addObject:orderDetail];
            }
        }else{
            if ([selectDataSource containsObject:orderDetail]) {
                [selectDataSource removeObject:orderDetail];
            }
        }
    }
}

- (UITableViewCell*)createTableViewCellWithStyle:(UITableViewCellStyle)cellStyle reuseIdentifier:identifier
{
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:cellStyle reuseIdentifier:identifier]autorelease];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *backImage = [[[UIImageView alloc]initWithFrame:CGRectMake(15 - 0.50f, -4, selfViewFrame.size.width - 30, 60 + 4)]autorelease];
    [backImage setImage:imageNameAndType(@"subjoinviewbox", @"png")];
    [cell.contentView addSubview:backImage];
    
    UIImageView *selectImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 28)]autorelease];
    selectImageView.center = CGPointMake(selectImageView.frame.size.width + 5, 30);
    selectImageView.tag = 101;
    [selectImageView setImage:imageNameAndType(@"passengerselect_normal", @"png")];
    [selectImageView setHighlightedImage:imageNameAndType(@"passengerselect_press", @"png")];
    [selectImageView setBackgroundColor:[UIColor clearColor]];
    [cell.contentView addSubview:selectImageView];
    
    UILabel *ticketType = [self getLabelWithFrame:CGRectMake(selectImageView.frame.origin.x + selectImageView.frame.size.width + 10, backImage.frame.origin.y + 4, (backImage.frame.size.width - selectImageView.frame.origin.x - selectImageView.frame.size.width - 10)*2/3, 30) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:@"成人票:某某某" font:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    ticketType.tag = 102;
    [cell.contentView addSubview:ticketType];
    
    UILabel *papersTypeAndNum = [self getLabelWithFrame:CGRectMake(ticketType.frame.origin.x, ticketType.frame.origin.y + ticketType.frame.size.height, ticketType.frame.size.width, ticketType.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:@"身份证:12345678987654321" font:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    papersTypeAndNum.tag = 103;
    [cell.contentView addSubview:papersTypeAndNum];
    
    UIButton *statusButton = [self getButtonWithFrame:CGRectMake(ticketType.frame.origin.x + ticketType.frame.size.width, ticketType.frame.origin.y, backImage.frame.size.width - ticketType.frame.origin.x - ticketType.frame.size.width + 10, backImage.frame.size.height) title:@"申请退票" textColor:[self getColor:@"ff6c00"] forState:UIControlStateNormal backGroundColor:[UIColor clearColor]];
    statusButton.tag = 104;
    statusButton.enabled = NO;
    [statusButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [cell.contentView addSubview:statusButton];
    
    return cell;
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
    
    UILabel *titleLabel = [self getLabelWithFrame:CGRectMake(80, 0, 160, 40) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] title:@"附加服务" font:nil];
    [self.view addSubview:titleLabel];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateSelected];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(pressReturnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    
    UIImageView *backImage = [self getImageViewWithFrame:CGRectMake(15, 40 + 10, selfViewFrame.size.width - 30, 170) image:imageNameAndType(@"queryinfocell_normal", @"png") highLightImage:nil backGroundColor:[UIColor clearColor]];
    [self.view addSubview:backImage];
    
    UILabel *orderCodeLeft = [self getLabelWithFrame:CGRectMake(0, 0, 70, 40) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:@"订单号:" font:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    self.orderCode = [[UITextField alloc]initWithFrame:CGRectMake(backImage.frame.origin.x + 10, backImage.frame.origin.y + 5, backImage.frame.size.width - 20, 40)];
    [orderCode setLeftView:orderCodeLeft];
    [orderCode setLeftViewMode:UITextFieldViewModeAlways];
    [orderCode setBackgroundColor:[UIColor clearColor]];
    [orderCode setEnabled:NO];
    [orderCode setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [orderCode setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [self.view addSubview:orderCode];
    
    UILabel *totalPriceLeft = [self getLabelWithFrame:CGRectMake(0, 0, orderCodeLeft.frame.size.width, orderCodeLeft.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:@"订单总价:" font:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    self.totalPrice = [[UITextField alloc]initWithFrame:CGRectMake(orderCode.frame.origin.x, orderCode.frame.origin.y + orderCode.frame.size.height, orderCode.frame.size.width, orderCode.frame.size.height)];
    [totalPrice setLeftView:totalPriceLeft];
    [totalPrice setLeftViewMode:UITextFieldViewModeAlways];
    [totalPrice setBackgroundColor:[UIColor clearColor]];
    [totalPrice setTextColor:[self getColor:@"ff6c00"]];
    [totalPrice setEnabled:NO];
    [totalPrice setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [totalPrice setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [self.view addSubview:totalPrice];
    
    UILabel *trainCodeAndRouteLeft = [self getLabelWithFrame:CGRectMake(0, 0, orderCodeLeft.frame.size.width, orderCodeLeft.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:@"车次:" font:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    self.trainCodeAndRoute = [[UITextField alloc]initWithFrame:CGRectMake(totalPrice.frame.origin.x, totalPrice.frame.origin.y + totalPrice.frame.size.height, totalPrice.frame.size.width, totalPrice.frame.size.height)];
    [trainCodeAndRoute setLeftView:trainCodeAndRouteLeft];
    [trainCodeAndRoute setLeftViewMode:UITextFieldViewModeAlways];
    [trainCodeAndRoute setBackgroundColor:[UIColor clearColor]];
    [trainCodeAndRoute setEnabled:NO];
    [trainCodeAndRoute setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [trainCodeAndRoute setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [self.view addSubview:trainCodeAndRoute];
    
    UILabel *startDateLeft = [self getLabelWithFrame:CGRectMake(0, 0, orderCodeLeft.frame.size.width, orderCodeLeft.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:@"出发日期:" font:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    self.startDate = [[UITextField alloc]initWithFrame:CGRectMake(trainCodeAndRoute.frame.origin.x, trainCodeAndRoute.frame.origin.y + trainCodeAndRoute.frame.size.height, trainCodeAndRoute.frame.size.width, trainCodeAndRoute.frame.size.height)];
    [startDate setLeftView:startDateLeft];
    [startDate setLeftViewMode:UITextFieldViewModeAlways];
    [startDate setBackgroundColor:[UIColor clearColor]];
    [startDate setEnabled:NO];
    [startDate setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [startDate setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [self.view addSubview:startDate];
    
    CGFloat tableViewHeight = 60*[dataSource count]<selfViewFrame.size.height - startDate.frame.origin.y - startDate.frame.size.height - 90?60*[dataSource count]:selfViewFrame.size.height - startDate.frame.origin.y - startDate.frame.size.height - 100;
    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, backImage.frame.origin.y + backImage.frame.size.height, selfViewFrame.size.width, tableViewHeight + 8)];
    theTableView.backgroundColor = [UIColor clearColor];
    theTableView.dataSource = self;
    theTableView.delegate   = self;
    theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:theTableView];
    
    UIButton *returnTicket = [UIButton buttonWithType:UIButtonTypeCustom];
    returnTicket.frame = CGRectMake(0, 0, selfViewFrame.size.width*2/3, 50);
    returnTicket.center = CGPointMake(selfViewFrame.size.width/2, selfViewFrame.size.height - 30 - returnTicket.frame.size.height/2);
    [returnTicket setTitle:@"申请退票" forState:UIControlStateNormal];
    [returnTicket setBackgroundImage:imageNameAndType(@"search_normal", @"png") forState:UIControlStateNormal];
    [returnTicket setBackgroundImage:imageNameAndType(@"search_press", @"png") forState:UIControlStateSelected];
    [returnTicket setBackgroundImage:imageNameAndType(@"search_press", @"png") forState:UIControlStateHighlighted];
    [self.view addSubview:returnTicket];
}

#pragma mark - button press
- (void)pressReturnButton:(UIButton*)sender
{
    [self popViewControllerCompletion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
