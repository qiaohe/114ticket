//
//  OrderFillInViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-9-2.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "OrderFillInViewController.h"
#import "OrderDetailViewController.h"
#import "Model.h"
#import "Utils.h"
#import "TotalAmount.h"
#import "PassengerInfo.h"
#import "TrainOrder.h"
#import "InSure.h"
#import "TrainTicketInfoCell.h"


@interface OrderFillInViewController ()

@end

@implementation OrderFillInViewController

@synthesize codeAndPrice;
@synthesize trainOrder;
@synthesize startTime;
@synthesize trainCode;
@synthesize seatTypeAndPrice;
@synthesize passengerNames;
@synthesize selectPassengers;
@synthesize passengers;
@synthesize contactName;
@synthesize contactNum;
@synthesize amount;
@synthesize selectedInsure;

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
    [codeAndPrice        release];
    [trainOrder          release];
    [startTime           release];
    [trainCode           release];
    [seatTypeAndPrice    release];
    [passengerNames      release];
    [selectPassengers    release];
    [passengers          release];
    [contactName         release];
    [contactNum          release];
    [amount              release];
    [selectedInsure      release];
    [super               dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        for (PassengerInfo *info in [UserDefaults shareUserDefault].contacts) {
            info.selected = NO;
        }
        self.selectPassengers = [NSMutableArray array];
        self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
        [self initView];
    }
    return self;
}

- (id)initWithTrainOrder:(TrainOrder*)order
{
    self = [super init];
    if (self) {
        for (PassengerInfo *info in [UserDefaults shareUserDefault].contacts) {
            info.selected = NO;
        }
        self.selectPassengers = [NSMutableArray array];
        self.trainOrder = order;
        self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
        [self initView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)subjoinServiceViewShouldReserveWithData:(NSArray*)array
{
    
}

- (void)addPassengers:(NSArray*)passengersArray
{
    self.selectPassengers = passengersArray;
    /*
    for (PassengerInfo *info in [UserDefaults shareUserDefault].contacts) {
        NSLog(@"name = %@ count = %u",info.name,[passengersArray count]);
    }*/
    [trainOrder setTrainOrderDetails:[NSMutableArray arrayWithArray:passengersArray]];
    NSMutableString *str = [NSMutableString string];
    for (PassengerInfo *passenger in trainOrder.trainOrderDetails) {
        [str appendString:passenger.name];
        if (passenger != [trainOrder.trainOrderDetails lastObject]) {
            [str appendString:@","];
        }
    }
    [passengers setText:str];
}

- (void)addSubjoinService:(InSure*)insure
{
    self.selectedInsure = insure;
    UIButton *insureButton = (UIButton*)[self.view viewWithTag:101];
    [insureButton setTitle:selectedInsure.inSureDetail forState:UIControlStateNormal];
}

#pragma mark - request handle
- (void)requestDone:(ASIHTTPRequest *)request
{
    [self parserStringBegin:request];
}

- (void)parserStringFinished:(NSString *)_string request:(ASIHTTPRequest *)request
{
    NSDictionary *resultData = [_string JSONValue];
   
    if ([[resultData objectForKey:@"performStatus"] isEqualToString:@"success"]) {        
        TrainOrder *order = [[[TrainOrder alloc]init]autorelease];
        order.orderNum = [resultData objectForKey:@"orderNum"];
        order.orderId  = [[resultData objectForKey:@"orderId"] integerValue];
        order.amount   = amount;
        order.orderStatus = 1;
        OrderDetailViewController *orderDetailView = [[[OrderDetailViewController alloc]initWithOrder:order]autorelease];
        [self pushViewController:orderDetailView completion:^{
            [orderDetailView getTrainOrderDetails];
        }];
    }
}

- (void)requestError:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
    [[Model shareModel] showPromptBoxWithText:[NSString stringWithFormat:@"%d",request.responseStatusCode] modal:NO];
}

- (void)pressConfirmButton:(UIButton*)sender
{
    if([trainOrder.trainOrderDetails count] == 0){
        [[Model shareModel] showPromptBoxWithText:@"请选择购票人" modal:NO];
    }else if ([Utils textIsEmpty:contactName.text] || [Utils textIsEmpty:contactNum.text]) {
        [[Model shareModel] showPromptBoxWithText:@"联系人和电话不能为空" modal:NO];
    }else if (![Utils isValidatePhoneNum:contactNum.text]){
        [[Model shareModel] showPromptBoxWithText:@"电话号码格式不正确" modal:NO];
    }else{
        [self inviteTicketPriceWithTrainOrder:trainOrder];
        trainOrder.totalAmount    = [[NSString stringWithFormat:@"%.2lf",amount.totalAmount] doubleValue];
        trainOrder.totalTickets   = [trainOrder.trainOrderDetails count];
        
        trainOrder.transactionFee = [[NSString stringWithFormat:@"%.2lf",amount.alipayAmount] doubleValue];
        trainOrder.userName       = contactName.text;
        trainOrder.userMobile     = contactNum.text;
                
        if (!selectedInsure) {
            selectedInsure = [[[InSure alloc]init]autorelease];
            [selectedInsure setInSureType:@"10"];
        }
        
        NSMutableArray *orderDetails = [NSMutableArray array];
        for (id passenger in trainOrder.trainOrderDetails) {
            if ([passenger isKindOfClass:[PassengerInfo class]]) {
                PassengerInfo *info = (PassengerInfo*)passenger;
                TrainOrderDetail *orderDetail = [[[TrainOrderDetail alloc]initWithPassenger:info]autorelease];
                orderDetail.ticketPrice = [[NSString stringWithFormat:@"%.2f",trainOrder.selectTicketPrice] floatValue];
                orderDetail.seatType = trainOrder.seatType;
                if (selectedInsure) {
                    orderDetail.insurance = [[NSString stringWithFormat:@"%.2lf",[selectedInsure.inSureType doubleValue]] doubleValue];
                }
                
                [orderDetails addObject:orderDetail];
            }
        }
        if ([orderDetails count]) {
            trainOrder.trainOrderDetails = orderDetails;
        }
        
        if ([UserDefaults shareUserDefault].userId) {
            trainOrder.userId = [[UserDefaults shareUserDefault].userId integerValue];
        }
        
        NSString *jsonString = [trainOrder JSONRepresentation];
                
        NSString *urlString = [NSString stringWithFormat:@"%@?trainOrderSync",TrainOrderServiceURL];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                jsonString,                 @"trainOrder",
                                nil];
        [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 40 - 2.0f, self.view.frame.size.width, self.view.frame.size.height - 40 + 2.0f) belowView:nil enabled:NO];
        [self sendRequestWithURL:urlString params:params requestMethod:RequestPost userInfo:nil];
    }
    /*[[Model shareModel] showPromptBoxWithText:@"暂不支持购票" modal:NO];*/
}

- (void)pressAddPassenger:(UIButton*)sender
{
    PassengerInfoViewController *passengerInfo = [[PassengerInfoViewController alloc]initWithCodeAndPrice:codeAndPrice];
    passengerInfo.trainOrder = self.trainOrder;
    passengerInfo.delegate = self;
    
    if ([selectPassengers count]) {
        passengerInfo.selectPassengers = [NSMutableArray arrayWithArray:selectPassengers];
    }
    [self pushViewController:passengerInfo completion:^{
        [passengerInfo getPassengers];
    }];
}

- (void)pressAddressBook:(UIButton*)sender
{
    
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc]init];
    
    peoplePicker.peoplePickerDelegate = self;
    
    [self presentViewController:peoplePicker animated:YES completion:^{
        
    }];
    //[[Model shareModel] showPromptBoxWithText:@"暂不支持从电话薄中添加" modal:NO];
}

#pragma mark - addressbook delegate method
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    int phoneCnt = ABMultiValueGetCount(phone);
    if(phoneCnt>1)
    {
        CFRelease(phone);
        return YES;
    }
    
    NSString* personNumber = (NSString*)ABMultiValueCopyValueAtIndex(phone, 0);
        
    NSString *firstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName  = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSLog(@"person num = %@,first = %@,last = %@",personNumber,firstName,lastName);
    
    personNumber = [personNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if (![Utils isValidatePhoneNum:personNumber]) {
        UIAlertView *alertView = [[[UIAlertView alloc]initWithTitle:nil message:@"选择的联系人号码必须为手机号码" delegate:peoplePicker cancelButtonTitle:@"取消" otherButtonTitles:nil]autorelease];
        [alertView show];
        
        return YES;
    }
        
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        [contactName setText:[NSString stringWithFormat:@"%@",lastName]];
        [contactNum setText:personNumber];
    }];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    if (property == kABPersonPhoneProperty)
    {
        ABMutableMultiValueRef phone = ABRecordCopyValue(person, property);
        int index = ABMultiValueGetIndexForIdentifier(phone, identifier);
        
        NSString* personNumber = (NSString*)ABMultiValueCopyValueAtIndex(phone, index);
        
        [peoplePicker dismissViewControllerAnimated:YES completion:^{
            
        }];
        [personNumber release];
        CFRelease(phone);
    }
    return NO;
}

- (TotalAmount*)inviteTicketPriceWithTrainOrder:(TrainOrder*)order
{
    if (!amount) {
        amount = [[TotalAmount alloc]init];
    }
    
    if (selectedInsure) {
        amount.premiumAmount = [selectedInsure.inSureType doubleValue] * [order.trainOrderDetails count];
    }else{
        amount.premiumAmount = 10.0f * [order.trainOrderDetails count];
    }
    switch (codeAndPrice.selectSeatType) {
        case SeatTypeYZ:
            amount.ticketAmount = [codeAndPrice.yz floatValue] * [order.trainOrderDetails count];
            break;
        case SeatTypeRZ:
            amount.ticketAmount = [codeAndPrice.rz floatValue] * [order.trainOrderDetails count];
            break;
        case SeatTypeYW:
            amount.ticketAmount = [codeAndPrice.ywx floatValue] * [order.trainOrderDetails count];
            break;
        case SeatTypeRW:
            amount.ticketAmount = [codeAndPrice.rwx floatValue] * [order.trainOrderDetails count];
            break;
        case SeatTypeRZ1:
            amount.ticketAmount = [codeAndPrice.rz1 floatValue] * [order.trainOrderDetails count];
            break;
        case SeatTypeRZ2:
            amount.ticketAmount = [codeAndPrice.rz2 floatValue] * [order.trainOrderDetails count];
            break;
            
        default:
            amount.ticketAmount = 0.0;
            break;
    }
    
    amount.alipayAmount = (amount.ticketAmount + amount.premiumAmount)/100;
    amount.totalAmount = amount.ticketAmount + amount.alipayAmount + amount.premiumAmount;
    
    return amount;
}

- (TotalAmount*)expressTicketPriceWithTrainOrder:(TrainOrder*)order
{
    if (!amount) {
        amount = [[TotalAmount alloc]init];
    }
    if (selectedInsure) {
        amount.premiumAmount = [selectedInsure.inSureType doubleValue] * [order.trainOrderDetails count];
    }else{
        amount.premiumAmount = 10.0f * [order.trainOrderDetails count];
    }
    switch (codeAndPrice.selectSeatType) {
        case SeatTypeYZ:
            amount.ticketAmount = [codeAndPrice.yz floatValue] * [order.trainOrderDetails count];
            break;
        case SeatTypeRZ:
            amount.ticketAmount = [codeAndPrice.rz floatValue] * [order.trainOrderDetails count];
            break;
        case SeatTypeYW:
            amount.ticketAmount = [codeAndPrice.ywx floatValue] * [order.trainOrderDetails count];
            break;
        case SeatTypeRW:
            amount.ticketAmount = [codeAndPrice.rwx floatValue] * [order.trainOrderDetails count];
            break;
        case SeatTypeRZ1:
            amount.ticketAmount = [codeAndPrice.rz1 floatValue] * [order.trainOrderDetails count];
            break;
        case SeatTypeRZ2:
            amount.ticketAmount = [codeAndPrice.rz2 floatValue] * [order.trainOrderDetails count];
            break;
            
        default:
            amount.ticketAmount = 10.0;
            break;
    }
    amount.saleSiteAmount = 5.0  * [order.trainOrderDetails count];
    amount.expressAmount  = 30.0 * [order.trainOrderDetails count];
    amount.alipayAmount = (amount.ticketAmount + amount.saleSiteAmount + amount.expressAmount + amount.premiumAmount)/100;
    amount.totalAmount = amount.ticketAmount + amount.alipayAmount + amount.saleSiteAmount + amount.expressAmount + amount.premiumAmount;
    
    return amount;
}

-(NSString *)notRounding:(float)price afterPoint:(int)position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *ouncesDecimal;
    
    NSDecimalNumber *roundedOunces;
    
    
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    [ouncesDecimal release];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

- (void)pressReturnButton:(UIButton*)sender
{
    [self popViewControllerCompletion:nil];
}

- (void)pressSubjoinService:(UIButton *)sender
{
    SubjoinServiceViewController *subjoinService = [[[SubjoinServiceViewController alloc]init]autorelease];
    subjoinService.delegate = self;
    [self pushViewController:subjoinService completion:^{
        [subjoinService getInsureType];
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([contactName canResignFirstResponder]) {
        [contactName resignFirstResponder];
    }if ([contactNum canResignFirstResponder]) {
        [contactNum resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField canResignFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - keyboard show or dismiss
- (void)keyBoardWillShow:(NSNotification *)notification
{
    [super keyBoardWillShow:notification];
    //CGPoint beginCentre = [[[notification userInfo] valueForKey:UIKeyboardFrameBeginUserInfoKey] CGPointValue];
    //CGPoint endCentre = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGPointValue];
    //CGRect keyboardBounds = [[[notification userInfo] valueForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
    CGRect keyboardFrames = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //UIViewAnimationCurve animationCurve = [[[notification userInfo] valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    NSTimeInterval animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self keyBoardShow:keyboardFrames animationDuration:animationDuration];
}

- (void)keyBoardWillHide:(NSNotification *)notification
{
    [super keyBoardWillHide:notification];
    CGRect keyboardFrames = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self keyBoardHide:keyboardFrames animationDuration:animationDuration];
    
}

- (void)keyBoardShow:(CGRect)frame animationDuration:(NSTimeInterval)duration
{
    UITextField *responder = nil;
    if ([contactName isFirstResponder]) {
        responder = contactName;
    }if ([contactNum isFirstResponder]) {
        responder = contactNum;
    }
    if (responder) {
        if (responder.frame.origin.y + responder.frame.size.height > frame.origin.y - 40) {
            CGFloat changeY = responder.frame.origin.y + responder.frame.size.height - (frame.origin.y - 40.0f);
            [UIView animateWithDuration:duration
                             animations:^{
                                 self.view.frame = CGRectMake(self.view.frame.origin.x, 0 - changeY, self.view.frame.size.width, self.view.frame.size.height);
                             }
                             completion:^(BOOL finished){
                                 
                             }];
        }
    }
}

- (void)keyBoardHide:(CGRect)frame animationDuration:(NSTimeInterval)duration
{
    UITextField *responder = nil;
    if ([contactName isFirstResponder]) {
        responder = contactName;
    }if ([contactNum isFirstResponder]) {
        responder = contactNum;
    }
    if (responder) {
        if (responder.frame.origin.y + responder.frame.size.height < frame.origin.y) {
            [UIView animateWithDuration:duration
                             animations:^{
                                 self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
                             }
                             completion:^(BOOL finished){
                                 
                             }];
        }
    }
}


#pragma mark - view init
- (void)initView
{
    UIImageView *backImageView = [[[UIImageView alloc]initWithFrame:[Utils frameWithRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) adaptWidthOrHeight:adaptWidth]]autorelease];
    [backImageView setImage:imageNameAndType(@"backgroundimage", @"png")];
    [self.view addSubview:backImageView];
    
    UIImageView *topImageView = [[[UIImageView alloc]initWithFrame:[Utils frameWithRect:CGRectMake(0, -1, self.view.frame.size.width, 40 + 1) adaptWidthOrHeight:adaptWidth]]autorelease];
    [topImageView setImage:imageNameAndType(@"topbar_image", @"png")];
    [self.view addSubview:topImageView];
    
    UILabel *titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(80, 0, 160, 40)]autorelease];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor       = [UIColor whiteColor];
    titleLabel.textAlignment   = NSTextAlignmentCenter;
    [titleLabel setText:@"订单填写"];
    [self.view addSubview:titleLabel];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateSelected];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(pressReturnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    
    UIImageView *trainInfoBackImage = [[[UIImageView alloc]initWithFrame:[Utils frameWithRect:CGRectMake(10, topImageView.frame.size.height + 10, 300, 90) adaptWidthOrHeight:adaptNone]]autorelease];
    [trainInfoBackImage setImage:imageNameAndType(@"orderfillin_traininfo", @"png")];
    [trainInfoBackImage setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:trainInfoBackImage];
    
    UILabel *startTimeLabel = [self getLabelWithFrame:CGRectMake(trainInfoBackImage.frame.origin.x, trainInfoBackImage.frame.origin.y, trainInfoBackImage.frame.size.width/5, trainInfoBackImage.frame.size.height/3) textAlignment:NSTextAlignmentRight backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] title:@"出发时间:" font:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [self.view addSubview:startTimeLabel];
    self.startTime = [self getLabelWithFrame:CGRectMake(startTimeLabel.frame.origin.x + startTimeLabel.frame.size.width, startTimeLabel.frame.origin.y, trainInfoBackImage.frame.size.width - startTimeLabel.frame.size.width, startTimeLabel.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:trainOrder.trainStartTime font:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [self.view addSubview:startTime];
    
    UILabel *trainCodeLabel = [self getLabelWithFrame:CGRectMake(trainInfoBackImage.frame.origin.x, startTimeLabel.frame.origin.y + startTimeLabel.frame.size.height, trainInfoBackImage.frame.size.width/5, trainInfoBackImage.frame.size.height/3) textAlignment:NSTextAlignmentRight backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] title:@"火车车次:" font:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [self.view addSubview:trainCodeLabel];
    self.trainCode = [self getLabelWithFrame:CGRectMake(trainCodeLabel.frame.origin.x + trainCodeLabel.frame.size.width, trainCodeLabel.frame.origin.y, trainInfoBackImage.frame.size.width - trainCodeLabel.frame.size.width, trainCodeLabel.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:[NSString stringWithFormat:@"%@\t%@-%@",trainOrder.trainCode,trainOrder.startStation,trainOrder.endStation] font:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [self.view addSubview:trainCode];
    
    UILabel *seatTypeAndPriceLabel = [self getLabelWithFrame:CGRectMake(trainInfoBackImage.frame.origin.x, trainCodeLabel.frame.origin.y + trainCodeLabel.frame.size.height, startTimeLabel.frame.size.width, startTimeLabel.frame.size.height) textAlignment:NSTextAlignmentRight backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] title:@"车票坐席:" font:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [self.view addSubview:seatTypeAndPriceLabel];
    self.seatTypeAndPrice = [self getLabelWithFrame:CGRectMake(seatTypeAndPriceLabel.frame.origin.x + seatTypeAndPriceLabel.frame.size.width, seatTypeAndPriceLabel.frame.origin.y, trainInfoBackImage.frame.size.width - seatTypeAndPriceLabel.frame.size.width, seatTypeAndPriceLabel.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:[self getColor:@"ff6c00"] title:[NSString stringWithFormat:@"%@  ￥:%.2f",trainOrder.seatType,trainOrder.selectTicketPrice] font:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [self.view addSubview:seatTypeAndPrice];
    
    CGFloat tempValue;
    if ([trainOrder.seatType hasPrefix:@"硬卧"] || [trainOrder.seatType hasPrefix:@"软卧"]) {
        UIImageView *trainPromptImage = [[[UIImageView alloc]initWithFrame:[Utils frameWithRect:CGRectMake(10, 142.5, 300, 40) adaptWidthOrHeight:adaptWidth]]autorelease];
        [trainPromptImage setBackgroundColor:[UIColor clearColor]];
        [trainPromptImage setImage:imageNameAndType(@"orderfillin_prompt", @"png")];
        [self.view addSubview:trainPromptImage];
        
        UIImageView *trainLeftImage = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)] autorelease];
        [trainLeftImage setCenter:CGPointMake(15, trainPromptImage.frame.size.height/2)];
        [trainLeftImage setImage:imageNameAndType(@"icons", @"png")];
        [trainLeftImage setBackgroundColor:[UIColor clearColor]];
        [trainPromptImage addSubview:trainLeftImage];
        
        UILabel *trainPrompt = [[[UILabel alloc]initWithFrame:[Utils frameWithRect:CGRectMake(trainLeftImage.center.x * 2, 0, trainPromptImage.frame.size.width - trainLeftImage.center.x * 2, trainPromptImage.frame.size.height) adaptWidthOrHeight:adaptWidth]]autorelease];//140
        [trainPrompt setBackgroundColor:[UIColor clearColor]];
        [trainPrompt setTextColor:[UIColor darkGrayColor]];
        [trainPrompt setFont:[UIFont systemFontOfSize:13]];
        [trainPrompt setNumberOfLines:0];
        [trainPrompt setLineBreakMode:NSLineBreakByWordWrapping];
        trainPrompt.adjustsFontSizeToFitWidth = YES;
        trainPrompt.adjustsLetterSpacingToFitWidth = YES;
        trainPrompt.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        trainPrompt.minimumScaleFactor = 0.7;
        [trainPrompt setText:@"卧铺上中下铺位是随机订位，暂收下铺价格，出票后根据实际票价退还差价。"];
        trainPrompt.textAlignment = NSTextAlignmentCenter;
        [trainPromptImage addSubview:trainPrompt];
        tempValue = 30.0f;
    }else{
        tempValue = 0.0f;
    }
    
    UIImageView *passengerBackImage = [[[UIImageView alloc]initWithFrame:[Utils frameWithRect:CGRectMake(10, 155 + tempValue, 300, 110) adaptWidthOrHeight:adaptNone]]autorelease];//255
    [passengerBackImage setBackgroundColor:[UIColor clearColor]];
    [passengerBackImage setImage:imageNameAndType(@"orderfillin_passenger", @"png")];
    [self.view addSubview:passengerBackImage];
    
    self.passengers = [self getLabelWithFrame:CGRectMake(60, passengerBackImage.frame.origin.y + 5, (passengerBackImage.frame.size.width - 50)*3/5, passengerBackImage.frame.size.height/3) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    
    [self.view addSubview:passengers];
    
    UIButton *addPassenger = [UIButton buttonWithType:UIButtonTypeCustom];
    [addPassenger setFrame:CGRectMake(0, 0, (passengerBackImage.frame.size.width - passengers.frame.size.width - 50 )*4/5, passengers.frame.size.height - 10)];
    [addPassenger setCenter:CGPointMake((passengerBackImage.frame.size.width + passengerBackImage.frame.origin.x + passengers.frame.size.width + passengers.frame.origin.x)/2, (passengers.frame.origin.y*2 + passengers.frame.size.height)/2 - 1.5)];
    [addPassenger addTarget:self action:@selector(pressAddPassenger:) forControlEvents:UIControlEventTouchUpInside];
    [addPassenger setImage:imageNameAndType(@"orderfillin_addpassenger_normal", @"png") forState:UIControlStateNormal];
    [addPassenger setImage:imageNameAndType(@"orderfillin_addpassenger_press", @"png") forState:UIControlStateHighlighted];
    [self.view addSubview:addPassenger];
    
    UIImageView *contactNameBackImage = [[[UIImageView alloc]initWithFrame:CGRectMake(passengers.frame.origin.x + 15, passengers.frame.origin.y + passengers.frame.size.height + 2.5, passengers.frame.size.width - 15, passengers.frame.size.height - 10)]autorelease];
    [contactNameBackImage setImage:imageNameAndType(@"filltextbackimage", @"png")];
    [contactNameBackImage setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:contactNameBackImage];
    
    self.contactName = [[[UITextField alloc]initWithFrame:CGRectMake(contactNameBackImage.frame.origin.x + 10, contactNameBackImage.frame.origin.y, contactNameBackImage.frame.size.width, contactNameBackImage.frame.size.height)]autorelease];
    contactName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [contactName setBackgroundColor:[UIColor clearColor]];
    if ([UserDefaults shareUserDefault].realName) {
        [contactName setText:[UserDefaults shareUserDefault].realName];
    }
    //[contactName setEnabled:NO];
    [contactName setDelegate:self];
    [contactName setReturnKeyType:UIReturnKeyDone];
    //[contactName setBorderStyle:UITextBorderStyleBezel];
    [contactName setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [self.view addSubview:contactName];
    
    UIImageView *contactNumBackImage = [[[UIImageView alloc]initWithFrame:CGRectMake(contactNameBackImage.frame.origin.x, contactNameBackImage.frame.origin.y + contactNameBackImage.frame.size.height + 1.5, contactNameBackImage.frame.size.width, contactNameBackImage.frame.size.height)]autorelease];
    [contactNumBackImage setImage:imageNameAndType(@"filltextbackimage", @"png")];
    [contactNumBackImage setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:contactNumBackImage];
    
    self.contactNum = [[[UITextField alloc]initWithFrame:CGRectMake(contactNumBackImage.frame.origin.x + 10, contactNumBackImage.frame.origin.y, contactNumBackImage.frame.size.width, contactNumBackImage.frame.size.height)]autorelease];
    contactNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [contactNum setBackgroundColor:[UIColor clearColor]];
    if ([UserDefaults shareUserDefault].mobile) {
        [contactNum setText:[UserDefaults shareUserDefault].mobile];
    }
    //[contactNum setEnabled:NO];
    [contactNum setDelegate:self];
    [contactNum setReturnKeyType:UIReturnKeyDone];
    //[contactNum setBorderStyle:UITextBorderStyleBezel];
    [contactNum setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [self.view addSubview:self.contactNum];
    
    UIButton *addressBook = [UIButton buttonWithType:UIButtonTypeCustom];
    [addressBook setFrame:CGRectMake(0,0, contactName.frame.size.height*2, contactName.frame.size.height*2 * 0.8)];
    addressBook.center = CGPointMake((passengerBackImage.frame.size.width + passengerBackImage.frame.origin.x + contactName.frame.origin.x + contactName.frame.size.width)/2, contactName.frame.origin.y + contactName.frame.size.height);
    [addressBook addTarget:self action:@selector(pressAddressBook:) forControlEvents:UIControlEventTouchUpInside];
    [addressBook setImage:imageNameAndType(@"orderfillin_contacts_normal", @"png") forState:UIControlStateNormal];
    [addressBook setImage:imageNameAndType(@"orderfillin_contacts_press", @"png") forState:UIControlStateHighlighted];
    [self.view addSubview:addressBook];
    
    UIImageView *subjoinServiceBackImage = [[[UIImageView alloc]initWithFrame:[Utils frameWithRect:CGRectMake(10, 265 + tempValue + 10, 300, 40) adaptWidthOrHeight:adaptWidth]]autorelease];
    [subjoinServiceBackImage setImage:imageNameAndType(@"queryinfocell_normal", @"png")];
    [self.view addSubview:subjoinServiceBackImage];
    
    UILabel *leftBtn = [self getLabelWithFrame:CGRectMake(subjoinServiceBackImage.frame.origin.x, subjoinServiceBackImage.frame.origin.y, subjoinServiceBackImage.frame.size.width/5, subjoinServiceBackImage.frame.size.height) textAlignment:NSTextAlignmentRight backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] title:@"附加服务:" font:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [self.view addSubview:leftBtn];
    
    UIButton *subjoinService = [UIButton buttonWithType:UIButtonTypeCustom];
    subjoinService.frame = CGRectMake(leftBtn.frame.origin.x + leftBtn.frame.size.width + 20, subjoinServiceBackImage.frame.origin.y + 5.0f, (subjoinServiceBackImage.frame.size.width - 20)*3/5,subjoinServiceBackImage.frame.size.height - 10);
    [subjoinService setBackgroundImage:imageNameAndType(@"registered_normal", @"png") forState:UIControlStateNormal];
    [subjoinService setBackgroundImage:imageNameAndType(@"registered_press", @"png") forState:UIControlStateHighlighted];
    [subjoinService setTitle:@"请选择服务类型(默认10元)" forState:UIControlStateNormal];
    [subjoinService setTag:101];
    [subjoinService.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [subjoinService setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [subjoinService setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [subjoinService addTarget:self action:@selector(pressSubjoinService:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:subjoinService];
    
    UIImageView *passengerPromptImage = [[[UIImageView alloc]initWithFrame:[Utils frameWithRect:CGRectMake(10, 320 + tempValue, 300, 50) adaptWidthOrHeight:adaptWidth]]autorelease];
    [passengerPromptImage setBackgroundColor:[UIColor clearColor]];
    [passengerPromptImage setImage:imageNameAndType(@"orderfillin_prompt", @"png")];
    [self.view addSubview:passengerPromptImage];
    
    UIImageView *passengerLeftImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [passengerLeftImage setCenter:CGPointMake(15, passengerPromptImage.frame.size.height/2)];
    [passengerLeftImage setImage:imageNameAndType(@"icons", @"png")];
    [passengerLeftImage setBackgroundColor:[UIColor clearColor]];
    [passengerPromptImage addSubview:passengerLeftImage];
    
    UILabel *passengerPrompt = [[[UILabel alloc]initWithFrame:CGRectMake(passengerLeftImage.center.x * 2, 0, passengerPromptImage.frame.size.width - passengerLeftImage.center.x * 2, passengerPromptImage.frame.size.height)]autorelease];
    [passengerPrompt setBackgroundColor:[UIColor clearColor]];
    [passengerPrompt setTextColor:[UIColor darkGrayColor]];
    [passengerPrompt setFont:[UIFont systemFontOfSize:13]];
    [passengerPrompt setNumberOfLines:0];
    [passengerPrompt setLineBreakMode:NSLineBreakByWordWrapping];
    passengerPrompt.adjustsFontSizeToFitWidth = YES;
    passengerPrompt.adjustsLetterSpacingToFitWidth = YES;
    passengerPrompt.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    passengerPrompt.minimumScaleFactor = 0.7;
    [passengerPrompt setText:@"温馨提醒：支付宝作为铁路部门官方指定第三方支付平台，您的资金是安全的。若配票不成功，票款将在3-7个工作日内退还到支付账户。"];
    passengerPrompt.textAlignment = NSTextAlignmentCenter;
    [passengerPromptImage addSubview:passengerPrompt];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = [Utils frameWithRect:CGRectMake(0, 0, self.view.frame.size.width*2/3, 40) adaptWidthOrHeight:adaptWidth];
    confirmButton.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height + passengerPromptImage.frame.size.height + passengerPromptImage.frame.origin.y)/2);
    [confirmButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    [confirmButton setTitle:@"确认订单" forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"login_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"login_press" ofType:@"png"]] forState:UIControlStateSelected];
    [confirmButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"login_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [confirmButton addTarget:self action:@selector(pressConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
