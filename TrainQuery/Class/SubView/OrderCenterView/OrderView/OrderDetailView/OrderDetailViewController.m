//
//  OrderDetailViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-22.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "Model.h"
#import "PassengerInfo.h"
#import "PaymentTypeViewController.h"
#import "RegisterAndLogInViewController.h"
#import "Utils.h"
//#import "DataSigner.h"
#import "AlixPayOrder.h"
#import "AlixPay.h"


@implementation Product

@synthesize price = _price;
@synthesize subject = _subject;
@synthesize body = _body;
@synthesize orderId = _orderId;

@end

@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

@synthesize orderStatus;
@synthesize orderNum;
@synthesize trainCode;
@synthesize route;
@synthesize date;
@synthesize seatType;
@synthesize contacts;
@synthesize birthDay;
@synthesize contactsNum;
@synthesize paymentAmount;
@synthesize payDetail;
@synthesize dataSource;
@synthesize trainOrder;
@synthesize scrollView;
@synthesize codeAndPrice;
@synthesize orderPriceDetail;
@synthesize superDate;
@synthesize superStatus;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithOrder:(TrainOrder*)order
{
    self = [super init];
    if (self) {
        self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
        self.trainOrder = order;
        [self initView];
    }
    return self;
}

- (id)initWithAmount:(TotalAmount*)amount
{
    self = [super init];
    if (self) {
        self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:alipayFinished object:nil];
    [orderStatus      release];
    [orderNum         release];
    [trainCode        release];
    [route            release];
    [date             release];
    [seatType         release];
    [contacts         release];
    [birthDay         release];
    [contactsNum      release];
    [paymentAmount    release];
    [payDetail        release];
    [scrollView       release];
    [dataSource       release];
    [trainOrder       release];
    [codeAndPrice     release];
    [orderPriceDetail release];
    [super            dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayFinish:) name:alipayFinished object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)getTrainOrderDetails
{
     [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 40.0f - 1.5f, self.view.frame.size.width, self.view.frame.size.height - 40.0f + 1.5f) belowView:nil enabled:NO];
    NSString *urlString = [NSString stringWithFormat:@"%@/getTrainOrder",TrainOrderServiceURL];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            //[Utils NULLToEmpty:[UserDefaults shareUserDefault].userId],                         @"userId",
                            [Utils nilToNumber:[NSNumber numberWithInteger:trainOrder.orderId]],                @"orderId",
                            nil];
    [self sendRequestWithURL:urlString params:params requestMethod:RequestPost userInfo:nil];
}

- (void)requestDone:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
    NSString *requestType = [request.userInfo objectForKey:@"requestType"];
    if ([requestType isEqualToString:@"testAlix"]) {
        NSString *orderString = [request.responseString URLDecodedString];

        AlixPay * alixpay = [AlixPay shared];
        int ret = [alixpay pay:orderString applicationScheme:appScheme];
        
        if (ret == kSPErrorAlipayClientNotInstalled) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"您还没有安装支付宝快捷支付，请先安装。"
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView setTag:123];
            [alertView show];
            [alertView release];
        }
        else if (ret == kSPErrorSignError) {
            NSLog(@"签名错误！");
        }
    }else{
        [self parserStringBegin:request];
    }
}

- (void)parserStringFinished:(NSString *)_string request:(ASIHTTPRequest *)request
{
    NSString *requestType = [request.userInfo objectForKey:@"requestType"];
    if ([requestType isEqualToString:@"testAlix"]) {
    }else{
        NSDictionary *dic = [[_string JSONValue] objectForKey:@"performResult"];
        NSLog(@"dic = %@",dic);
        TrainOrder *order = [[[TrainOrder alloc]initWithPData:dic]autorelease];
        
        if ([order.trainOrderDetails count] != 0) {
            [order.trainOrderDetails removeAllObjects];
        }
        NSArray *dataArray = [dic objectForKey:@"trainOrderDetails"];
        for (NSDictionary *pData in dataArray) {
            TrainOrderDetail *orderDetail = [[[TrainOrderDetail alloc]initWithPData:pData]autorelease];
            [order.trainOrderDetails addObject:orderDetail];
        }
        order.amount = trainOrder.amount;
        self.trainOrder = order;
        self.dataSource = order.trainOrderDetails;
        order.amount = [[[TotalAmount alloc]initWithPData:dic]autorelease];
        [self loadDetailView];
    }
}

- (void)requestError:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
}

#pragma mark - response method
- (void)loadDetailView
{
    [self initDetailView];
}

- (void)pressReturnButton:(UIButton*)sender
{
    [self popViewControllerCompletion:nil];
}

- (void)pressConfirmButton:(UIButton*)sender
{
    
    NSDate *orderTime = [Utils dateWithString:trainOrder.orderTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentTime = [NSDate date];
    if ([currentTime timeIntervalSince1970] - [orderTime timeIntervalSince1970] >= 60 * 60) {
        [[Model shareModel] showPromptBoxWithText:@"订单时间超过一小时,不能支付!" modal:NO];
        return;
    }
    AlixPayOrder *order = [[AlixPayOrder alloc]init];
    
    if (trainOrder.orderStatus == 4) {
        NSString *payDate = [Utils stringWithDate:[NSDate date] withFormat:@"HHmm"];
        order.tradeNO   = [NSString stringWithFormat:@"%@_%@",trainOrder.orderNum,payDate];
        order.amount        = [NSString stringWithFormat:@"%.2f",trainOrder.totalAmount - trainOrder.paidAmount];
    }else{
        order.tradeNO       = trainOrder.orderNum;
        order.amount        = [NSString stringWithFormat:@"%.2f",trainOrder.totalAmount];
    }
    NSString *dateString = [Utils stringWithDate:[Utils dateWithString:trainOrder.trainStartTime withFormat:@"yyyy-MM-dd HH:mm"] withFormat:@"yyyy-MM-dd"];
    order.productName   = [NSString stringWithFormat:@"%@ - %@ %@ %@ - %@ %@ 数量:%d",trainOrder.orderNum,dateString,trainOrder.trainCode,trainOrder.startStation,trainOrder.endStation,trainOrder.seatType,trainOrder.totalTickets] ;
    order.productDescription  = [NSString stringWithFormat:@"%@ %@ %@ - %@ %@ 数量:%d %@",trainOrder.trainStartTime,trainOrder.trainCode,trainOrder.startStation,trainOrder.endStation,trainOrder.seatType,trainOrder.totalTickets,trainOrder.userMobile];
    //order.amount        = @"0.01";
    //order.productName   = @"可以显示多长可以显示多长可以显示多长可以显示多长可以显示多长可以显示多长";
    //order.productDescription = @"可以显示多长可以显示多长可以显示多长可以显示多长可以显示多长可以显示多长";
    
    NSString *urlString = @"http://www.114piaowu.com:8043/axis2/RSATrade";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            order.productName,              @"subject",
                            order.productDescription,       @"body",
                            order.amount,                   @"total_fee",
                            order.tradeNO,                  @"out_trade_no",
                            nil];
    NSLog(@"params = %@",params);
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"testAlix",                      @"requestType",
                              nil];
    [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 40.0f - 1.5f, self.view.frame.size.width, self.view.frame.size.height - 40.0f + 1.5f) belowView:nil enabled:NO];
    [self sendRequestWithURL:urlString params:params requestMethod:RequestPost userInfo:userInfo];
    //[[Model shareModel] showPromptBoxWithText:@"暂不支持付款" modal:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 123) {
		NSString * URLString = @"http://itunes.apple.com/cn/app/id535715926?mt=8";
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
	}
}

- (void)alipayFinish:(NSObject*)object
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
    NSLog(@"finished");
    if (![UserDefaults shareUserDefault].userId) {
        [[Model shareModel]showPromptBoxWithText:@"支付完成,请关注短信通知" modal:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [[Model shareModel] showPromptBoxWithText:@"支付完成" modal:NO];
        OrderCenterViewController *orderCenterView = [[[OrderCenterViewController alloc]init]autorelease];
        orderCenterView.orderDate   = OrderThreeMonth;
        orderCenterView.orderStatus = OrderProcess;
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[Model shareModel].mainView pushViewController:orderCenterView completion:^{
            [orderCenterView threeMonthListShow];
        }];
    }
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
    
    UILabel *titleLabel = [self getLabelWithFrame:CGRectMake(80, 0, 160, 40) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] title:@"订单详情" font:nil];
    [self.view addSubview:titleLabel];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateSelected];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(pressReturnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    

    
    if (trainOrder.orderStatus == 1 || trainOrder.orderStatus == 4 || trainOrder.orderStatus == 5) {
        UIImageView *detailImage = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 40 + 5, selfViewFrame.size.width - 20, (selfViewFrame.size.height - 40 - 5)*4/5)]autorelease];
        [detailImage setImage:imageNameAndType(@"orderdetailbackimage", @"png")];
        [self.view addSubview:detailImage];
        
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(detailImage.frame.origin.x, detailImage.frame.origin.y + 5, detailImage.frame.size.width, detailImage.frame.size.height - 10)];
        scrollView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:scrollView];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(0, 0, selfViewFrame.size.width*2/3, 40);
        confirmButton.center = CGPointMake(selfViewFrame.size.width/2, (selfViewFrame.size.height + scrollView.frame.origin.y + scrollView.frame.size.height)/2);
        [confirmButton setTitle:@"确认支付" forState:UIControlStateNormal];
        [confirmButton setBackgroundImage:imageNameAndType(@"search_normal", @"png") forState:UIControlStateNormal];
        [confirmButton setBackgroundImage:imageNameAndType(@"search_press", @"png") forState:UIControlStateSelected];
        [confirmButton setBackgroundImage:imageNameAndType(@"search_press", @"png") forState:UIControlStateHighlighted];
        [confirmButton addTarget:self action:@selector(pressConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:confirmButton];
    }else{
        UIImageView *detailImage = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 40 + 5, selfViewFrame.size.width - 20, (selfViewFrame.size.height - 40 - 10))]autorelease];
        [detailImage setImage:imageNameAndType(@"orderdetailbackimage", @"png")];
        [self.view addSubview:detailImage];
        
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(detailImage.frame.origin.x, detailImage.frame.origin.y + 5, detailImage.frame.size.width, detailImage.frame.size.height - 10)];
        scrollView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:scrollView];
    }
}

- (void)initDetailView
{
    CGRect topRect = [self setTopViewWithSuperview:scrollView];
    CGRect contactsRect = [self setContactsInfoWithSuperview:scrollView params:dataSource usedFrame:topRect];
    CGRect footerRect = [self setFooterViewWithSuperview:scrollView usedFrame:contactsRect];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, topRect.size.height + contactsRect.size.height + footerRect.size.height);
}

- (CGRect)setTopViewWithSuperview:(UIScrollView*)superView
{
    self.orderStatus = [self getLabelWithFrame:CGRectMake(10, 0, superView.frame.size.width - 20, 30) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [orderStatus setText:[NSString stringWithFormat:@"订单状态:%@",[self getStatusWithTrainOrder:trainOrder]]];
    [superView addSubview:orderStatus];
    
    self.orderNum    = [self getLabelWithFrame:CGRectMake(orderStatus.frame.origin.x, orderStatus.frame.origin.y + orderStatus.frame.size.height, orderStatus.frame.size.width, orderStatus.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    orderNum.text = [NSString stringWithFormat:@"订单号:%@",trainOrder.orderNum];
    [superView addSubview:orderNum];
    
    UIImageView *dashLine = [[[UIImageView alloc]initWithFrame:CGRectMake(orderNum.frame.origin.x, orderNum.frame.origin.y + orderNum.frame.size.height - 5, orderNum.frame.size.width, 5)]autorelease];
    [dashLine setImage:imageNameAndType(@"dashline", @"png")];
    [superView addSubview:dashLine];
    
    self.trainCode   = [self getLabelWithFrame:CGRectMake(dashLine.frame.origin.x, dashLine.frame.origin.y + dashLine.frame.size.height, dashLine.frame.size.width, orderNum.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [trainCode setText:[NSString stringWithFormat:@"车次:    %@",trainOrder.trainCode]];
    [superView addSubview:trainCode];
    
    self.route       = [self getLabelWithFrame:CGRectMake(trainCode.frame.origin.x, trainCode.frame.origin.y + trainCode.frame.size.height, trainCode.frame.size.width, trainCode.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    route.textAlignment = NSTextAlignmentCenter;
    [route setTextColor:[self getColor:@"ff6c00"]];
    [route setText:[NSString stringWithFormat:@"%@    -    %@",trainOrder.startStation,trainOrder.endStation]];
    [superView addSubview:route];
    
    self.date        = [self getLabelWithFrame:CGRectMake(route.frame.origin.x, route.frame.origin.y + route.frame.size.height, route.frame.size.width, route.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [date setText:[NSString stringWithFormat:@"发车日期:%@",trainOrder.trainStartTime]];
    [superView addSubview:date];
    
    self.seatType    = [self getLabelWithFrame:CGRectMake(date.frame.origin.x, date.frame.origin.y + date.frame.size.height, date.frame.size.width, date.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [seatType setText:[NSString stringWithFormat:@"坐席:%@",trainOrder.seatType]];
    [superView addSubview:seatType];
    
    return CGRectMake(0, 0, selfViewFrame.size.width - 20, orderStatus.frame.size.height + orderNum.frame.size.height + trainCode.frame.size.height + route.frame.size.height + date.frame.size.height + seatType.frame.size.height);
}

- (CGRect)setContactsInfoWithSuperview:(UIScrollView*)superView params:(NSArray*)params usedFrame:(CGRect)frame
{
    CGRect rect = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height, frame.size.width, 0);
    
    for (int i = 0;i<[params count];i++) {
        UIImageView *dashLine = [[[UIImageView alloc]initWithFrame:CGRectMake(rect.origin.x + 10, rect.origin.y + rect.size.height - 5 , rect.size.width - 20, 5)]autorelease];
        [dashLine setImage:imageNameAndType(@"dashline", @"png")];
        [superView addSubview:dashLine];
        
        TrainOrderDetail *orderDetail = [params objectAtIndex:i];
        NSString *certificateType = nil;
        if ([orderDetail.cardType isEqualToString:@"0"]) {
            certificateType = @"身份证";
        }else if ([orderDetail.cardType isEqualToString:@"1"]) {
            certificateType = @"护照";
        }else{
            certificateType = @"港澳通行证";
        }
        //NSString *type = [orderDetail seatType];
        
        NSString *str1 = nil;
        
        NSString *str2 = nil;
        if (orderDetail.type == TicketMan) {
            str1 = [NSString stringWithFormat:@"乘车人:%@ (成人票)",orderDetail.userName];
            str2 = [NSString stringWithFormat:@"%@:%@",certificateType,orderDetail.idCard];
        }else if(orderDetail.type == TicketChildren){
            str1 = [NSString stringWithFormat:@"乘车人:%@ (儿童票)",orderDetail.userName];
            str2 = [NSString stringWithFormat:@"出生日期:%@",orderDetail.birthdate];
        }else{
            str1 = [NSString stringWithFormat:@"乘车人:%@ (老人票)",orderDetail.userName];
            str2 = [NSString stringWithFormat:@"%@:%@",certificateType,orderDetail.idCard];
        }
        UILabel *passengerName = [self getLabelWithFrame:CGRectMake(10, rect.origin.y + rect.size.height, rect.size.width - 20, 30) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:str1 font:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        UILabel *idCardNum = [self getLabelWithFrame:CGRectMake(10, passengerName.frame.origin.y + passengerName.frame.size.height, rect.size.width - 20, 30) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:str2 font:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [superView addSubview:passengerName];
        [superView addSubview:idCardNum];
        rect.size.height = rect.size.height + passengerName.frame.size.height + idCardNum.frame.size.height;
    }
    return rect;
}

- (CGRect)setFooterViewWithSuperview:(UIScrollView*)superView usedFrame:(CGRect)frame// detailViewShow:(BOOL)show
{
    CGRect rect = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height, frame.size.width, 0);
    
    UIImageView *dashLine = [[[UIImageView alloc]initWithFrame:CGRectMake(rect.origin.x + 10, rect.origin.y + rect.size.height - 5 , rect.size.width - 20, 5)]autorelease];
    [dashLine setImage:imageNameAndType(@"dashline", @"png")];
    [superView addSubview:dashLine];
    
    self.contacts = [self getLabelWithFrame:CGRectMake(rect.origin.x + 10, rect.origin.y + rect.size.height, rect.size.width - 20, 30) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [contacts setText:[NSString stringWithFormat:@"联系人:%@",trainOrder.userName]];
    [superView addSubview:contacts];
    
    self.contactsNum = [self getLabelWithFrame:CGRectMake(contacts.frame.origin.x, contacts.frame.origin.y + contacts.frame.size.height, contacts.frame.size.width, contacts.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [contactsNum setText:[NSString stringWithFormat:@"联系电话:%@",trainOrder.userMobile]];
    [superView addSubview:contactsNum];
    
    NSString *string = trainOrder.orderStatus == 4?@"支付差额:":@"支付金额:";
    double payAmount;
    if (trainOrder.orderStatus == 4) {
        payAmount = trainOrder.totalAmount - trainOrder.paidAmount;
        string    = @"支付差额:";
    }else if (trainOrder.orderStatus == 2 || trainOrder.orderStatus == 7){
        payAmount = trainOrder.paidAmount;
        string    = @"已付金额:";
    }else{
        payAmount = trainOrder.totalAmount;
        string    = @"支付金额:";
    }
    
    UILabel *leftLabel = [self getLabelWithFrame:CGRectMake(contactsNum.frame.origin.x, contactsNum.frame.origin.y + contactsNum.frame.size.height, contactsNum.frame.size.width*2/3, contactsNum.frame.size.height) textAlignment:NSTextAlignmentRight backGroundColor:[UIColor clearColor] textColor:nil title:string font:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [superView addSubview:leftLabel];
    
    
    self.paymentAmount = [self getLabelWithFrame:CGRectMake(leftLabel.frame.origin.x + leftLabel.frame.size.width, leftLabel.frame.origin.y, contactsNum.frame.size.width/3, contactsNum.frame.size.height) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:nil title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [paymentAmount setText:[NSString stringWithFormat:@"%.2f元",payAmount]];
    [self.paymentAmount setTextColor:[self getColor:@"ff6c00"]];
    [superView addSubview:paymentAmount];
    
    
    if (trainOrder.amount) {
        NSString *payDetailText = nil;
        if (trainOrder.orderStatus == 4) {
            payDetailText = [NSString stringWithFormat:@"（需付 %.2lf 已付 %.2lf 手续费 %@）",trainOrder.totalAmount,trainOrder.paidAmount,trainOrder.amount.alipayAmount?@"1%":@"0"];
        }else{
            payDetailText = [NSString stringWithFormat:@"（票价 %.2lf × %d张 服务价 %.2lf 手续费 %@）",trainOrder.amount.ticketAmount,trainOrder.totalTickets,trainOrder.amount.premiumAmount,trainOrder.amount.alipayAmount?@"1%":@"0"];
        }
        self.payDetail = [self getLabelWithFrame:CGRectMake(leftLabel.frame.origin.x, leftLabel.frame.origin.y + leftLabel.frame.size.height, contactsNum.frame.size.width, contactsNum.frame.size.height) textAlignment:NSTextAlignmentRight backGroundColor:[UIColor clearColor] textColor:nil title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [payDetail setText:payDetailText];
        payDetail.adjustsFontSizeToFitWidth = YES;
        payDetail.adjustsLetterSpacingToFitWidth = YES;
        payDetail.baselineAdjustment = UIBaselineAdjustmentNone;
        payDetail.minimumScaleFactor = 0.5;
        [superView addSubview:payDetail];
    }
    
    rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, contacts.frame.size.height + contactsNum.frame.size.height + paymentAmount.frame.size.height + payDetail.frame.size.height);
    return rect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
