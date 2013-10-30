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
#import "InSure.h"


@interface OrderFillInViewController ()

@property (assign, nonatomic) CGFloat           tempValue;

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
        [self.contentView setHidden:NO];
        [self.contentView setBackgroundColor:[UIColor blackColor]];
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
        [self.contentView setHidden:NO];
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
    
    [self setSubjoinviewFrame:self.selectPassengers];
}

- (void)addSubjoinService:(InSure*)insure
{
    self.selectedInsure = insure;
    NSLog(@"add insure = %@",selectedInsure.inSureType);
    UIButton *insureButton = (UIButton*)[self.contentView viewWithTag:101];
    [insureButton setTitle:selectedInsure.inSureDetail forState:UIControlStateNormal];
}

- (void)getInsureType
{
    if ([[UserDefaults shareUserDefault].subService count] == 0) {
        [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 40.0f - 1.5f, selfViewFrame.size.width, selfViewFrame.size.height + 1.5f) belowView:nil enabled:NO];
        NSString *urlString = nil;
        urlString = [NSString stringWithFormat:@"%@/getInsureType",TrainOrderServiceURL];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"getInsure",                         @"requestType",
                                  nil];
        [self sendRequestWithURL:urlString params:nil requestMethod:RequestGet userInfo:userInfo];
    }else{
        [self setSubService];
    }
}

- (void)setSubService
{
    if ([[UserDefaults shareUserDefault].subService count] != 0) {
        for (InSure *insure in [UserDefaults shareUserDefault].subService) {
            if ([insure.inSureType isEqualToString:@"10"]) {
                self.selectedInsure = insure;
                UIButton *insureButton = (UIButton*)[self.contentView viewWithTag:101];
                [insureButton setTitle:selectedInsure.inSureDetail forState:UIControlStateNormal];
                return;
            }
        }
        InSure *insure = [[UserDefaults shareUserDefault].subService objectAtIndex:0];
        if (insure) {
            self.selectedInsure = insure;
            UIButton *insureButton = (UIButton*)[self.contentView viewWithTag:101];
            [insureButton setTitle:selectedInsure.inSureDetail forState:UIControlStateNormal];
        }
    }else{
        [[Model shareModel] showPromptBoxWithText:@"获取附加服务失败" modal:YES];
    }
}

#pragma mark - request handle
- (void)requestDone:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
    [self parserStringBegin:request];
}

- (void)parserStringFinished:(NSString *)_string request:(ASIHTTPRequest *)request
{
    NSDictionary *resultData = [_string JSONValue];
    
    NSLog(@"data = %@",resultData);
    
    NSString *requestType = [request.userInfo objectForKey:@"requestType"];
    if ([requestType isEqualToString:@"getInsure"]) {
        [UserDefaults shareUserDefault].subService = [NSMutableArray arrayWithArray:[InSure getInSureTypeListWithData:[_string JSONValue]]];
        NSLog(@"array = %@",[UserDefaults shareUserDefault].subService);
        [self setSubService];
    }else{
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
}

- (void)requestError:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
    [[Model shareModel] showPromptBoxWithText:[NSString stringWithFormat:@"%d",request.responseStatusCode] modal:NO];
}

- (void)pressConfirmButton:(UIButton*)sender
{
    if([self.selectPassengers count] == 0){
        [[Model shareModel] showPromptBoxWithText:@"请选择购票人" modal:NO];
        return;
    }else if ([Utils textIsEmpty:contactName.text] || [Utils textIsEmpty:contactNum.text]) {
        [[Model shareModel] showPromptBoxWithText:@"联系人和电话不能为空" modal:NO];
        return;
    }else if (![Utils isValidatePhoneNum:contactNum.text]){
        [[Model shareModel] showPromptBoxWithText:@"电话号码格式不正确" modal:NO];
        return;
    }else{
        [self inviteTicketPriceWithTrainOrder:trainOrder];
        trainOrder.totalAmount    = [[NSString stringWithFormat:@"%.2lf",amount.totalAmount] doubleValue];
        trainOrder.totalTickets   = [self.selectPassengers count];
        
        trainOrder.transactionFee = [[NSString stringWithFormat:@"%.2lf",amount.alipayAmount] doubleValue];
        trainOrder.userName       = contactName.text;
        trainOrder.userMobile     = contactNum.text;
                
        if (!selectedInsure) {
            self.selectedInsure = [[[InSure alloc]init]autorelease];
            [selectedInsure setInSureType:@"10"];
        }
        
        NSLog(@"press insure = %@",selectedInsure.inSureType);
        
        NSMutableArray *orderDetails = [NSMutableArray array];
        for (id passenger in self.selectPassengers) {
            if ([passenger isKindOfClass:[PassengerInfo class]]) {
                PassengerInfo *info = (PassengerInfo*)passenger;
                TrainOrderDetail *orderDetail = [[[TrainOrderDetail alloc]initWithPassenger:info]autorelease];
                orderDetail.ticketPrice = [[NSString stringWithFormat:@"%.2f",trainOrder.selectTicketPrice] floatValue];
                orderDetail.seatType = trainOrder.seatType;
                NSLog(@"insure = %@",selectedInsure.inSureType);
                orderDetail.insurance = [[NSString stringWithFormat:@"%.2lf",[selectedInsure.inSureType doubleValue]] doubleValue];
                
                [orderDetails addObject:orderDetail];
            }
        }
        if ([orderDetails count] != 0) {
            trainOrder.trainOrderDetails = orderDetails;
        }
        
        if ([UserDefaults shareUserDefault].userId) {
            trainOrder.userId = [[UserDefaults shareUserDefault].userId integerValue];
        }
        
        NSString *jsonString = [trainOrder JSONRepresentation];
        
        NSLog(@"jsonString = %@",[NSString stringWithFormat:@"%@",[jsonString JSONValue]]);
                
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
    //NSLog(@"person num = %@,first = %@,last = %@",personNumber,firstName,lastName);
    
    personNumber = [personNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if (![Utils isValidatePhoneNum:personNumber]) {
        UIAlertView *alertView = [[[UIAlertView alloc]initWithTitle:nil message:@"选择的联系人号码必须为手机号码" delegate:peoplePicker cancelButtonTitle:@"取消" otherButtonTitles:nil]autorelease];
        [alertView show];
        
        return YES;
    }
    
    NSString *name = [[Utils NULLToEmpty:lastName] stringByAppendingString:[Utils NULLToEmpty:firstName]];
    
    //NSLog(@"name = %@",name);
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        [contactName setText:[NSString stringWithFormat:@"%@",name]];
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
        
    if (!selectedInsure) {
        self.selectedInsure = [[[InSure alloc]init]autorelease];
        [selectedInsure setInSureType:@"10"];
    }
    
    NSLog(@"invite insure = %@",selectedInsure.inSureType);
    
    amount.premiumAmount = [selectedInsure.inSureType doubleValue] * [self.selectPassengers count];
    
    switch (codeAndPrice.selectSeatType) {
        case SeatTypeYZ:
            amount.ticketAmount = [codeAndPrice.yz floatValue] * [self.selectPassengers count];
            break;
        case SeatTypeRZ:
            amount.ticketAmount = [codeAndPrice.rz floatValue] * [self.selectPassengers count];
            break;
        case SeatTypeYW:
            amount.ticketAmount = [codeAndPrice.ywx floatValue] * [self.selectPassengers count];
            break;
        case SeatTypeRW:
            amount.ticketAmount = [codeAndPrice.rwx floatValue] * [self.selectPassengers count];
            break;
        case SeatTypeRZ1:
            amount.ticketAmount = [codeAndPrice.rz1 floatValue] * [self.selectPassengers count];
            break;
        case SeatTypeRZ2:
            amount.ticketAmount = [codeAndPrice.rz2 floatValue] * [self.selectPassengers count];
            break;
            
        default:
            amount.ticketAmount = 0.0;
            break;
    }
    
    amount.alipayAmount = amount.ticketAmount/100;
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
    [self clearKeyboard];
}

- (void)clearKeyboard
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
    UIImageView *backImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
    [backImageView setImage:imageNameAndType(@"backgroundimage", @"png")];
    if (!self.contentView.hidden) {
        [self.view insertSubview:backImageView belowSubview:nil];
    }else
        [self.view addSubview:backImageView];
    
    UIImageView *topImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, -1, self.view.frame.size.width + 10, 40 + 1)]autorelease];
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
    
    UIImageView *trainInfoBackImage = [[[UIImageView alloc]initWithFrame:CGRectMake(10, topImageView.frame.size.height + 10, 300, 90)]autorelease];
    [trainInfoBackImage setImage:imageNameAndType(@"orderfillin_traininfo", @"png")];
    [trainInfoBackImage setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:trainInfoBackImage];
    
    UILabel *startTimeLabel = [self getLabelWithFrame:CGRectMake(trainInfoBackImage.frame.origin.x, trainInfoBackImage.frame.origin.y, trainInfoBackImage.frame.size.width/5, trainInfoBackImage.frame.size.height/3) textAlignment:NSTextAlignmentRight backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] title:@"出发时间:" font:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [self.contentView addSubview:startTimeLabel];
    self.startTime = [self getLabelWithFrame:CGRectMake(startTimeLabel.frame.origin.x + startTimeLabel.frame.size.width, startTimeLabel.frame.origin.y, trainInfoBackImage.frame.size.width - startTimeLabel.frame.size.width, startTimeLabel.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:trainOrder.trainStartTime font:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [self.contentView addSubview:startTime];
    
    UILabel *trainCodeLabel = [self getLabelWithFrame:CGRectMake(trainInfoBackImage.frame.origin.x, startTimeLabel.frame.origin.y + startTimeLabel.frame.size.height, trainInfoBackImage.frame.size.width/5, trainInfoBackImage.frame.size.height/3) textAlignment:NSTextAlignmentRight backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] title:@"火车车次:" font:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [self.contentView addSubview:trainCodeLabel];
    self.trainCode = [self getLabelWithFrame:CGRectMake(trainCodeLabel.frame.origin.x + trainCodeLabel.frame.size.width, trainCodeLabel.frame.origin.y, trainInfoBackImage.frame.size.width - trainCodeLabel.frame.size.width, trainCodeLabel.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:[NSString stringWithFormat:@"%@\t%@-%@",trainOrder.trainCode,trainOrder.startStation,trainOrder.endStation] font:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [self.contentView addSubview:trainCode];
    
    UILabel *seatTypeAndPriceLabel = [self getLabelWithFrame:CGRectMake(trainInfoBackImage.frame.origin.x, trainCodeLabel.frame.origin.y + trainCodeLabel.frame.size.height, startTimeLabel.frame.size.width, startTimeLabel.frame.size.height) textAlignment:NSTextAlignmentRight backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] title:@"车票坐席:" font:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [self.contentView addSubview:seatTypeAndPriceLabel];
    self.seatTypeAndPrice = [self getLabelWithFrame:CGRectMake(seatTypeAndPriceLabel.frame.origin.x + seatTypeAndPriceLabel.frame.size.width, seatTypeAndPriceLabel.frame.origin.y, trainInfoBackImage.frame.size.width - seatTypeAndPriceLabel.frame.size.width, seatTypeAndPriceLabel.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:[self getColor:@"ff6c00"] title:[NSString stringWithFormat:@"%@  ￥:%.2f",trainOrder.seatType,trainOrder.selectTicketPrice] font:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [self.contentView addSubview:seatTypeAndPrice];
    
    if ([trainOrder.seatType hasPrefix:@"硬卧"] || [trainOrder.seatType hasPrefix:@"软卧"]) {
        UIImageView *trainPromptImage = [[[UIImageView alloc]initWithFrame:[Utils frameWithRect:CGRectMake(10, controlYLength(trainInfoBackImage) + 10.0f, 300, 40) adaptWidthOrHeight:adaptWidth]]autorelease];
        [trainPromptImage setBackgroundColor:[UIColor clearColor]];
        [trainPromptImage setImage:imageNameAndType(@"orderfillin_prompt", @"png")];
        [self.contentView addSubview:trainPromptImage];
        
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
        _tempValue = controlYLength(trainPromptImage) + 10.0f;
    }else{
        _tempValue = controlYLength(trainInfoBackImage) + 10.0f;
    }
    

    
    UIImageView *passengerBackImage = [[[UIImageView alloc]initWithFrame:CGRectMake(10, _tempValue, self.contentView.frame.size.width - 20, 45)]autorelease];//255
    [passengerBackImage setBackgroundColor:[UIColor clearColor]];
    [passengerBackImage setTag:300];
    [passengerBackImage setImage:stretchImage(@"queryinfocell_normal", @"png")];
    [self.contentView addSubview:passengerBackImage];
    
    self.passengers = [self getLabelWithFrame:CGRectMake(passengerBackImage.frame.origin.x + 10, passengerBackImage.frame.origin.y, passengerBackImage.frame.size.width - 20, passengerBackImage.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [self.passengers setText:@"请添加乘客"];
    [self.passengers setNumberOfLines:0];
    [self.passengers setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:passengers];
    
    UIButton *addPassenger = [UIButton buttonWithType:UIButtonTypeCustom];
    [addPassenger setFrame:CGRectMake(0, 0, 80, 30)];
    [addPassenger setTag:301];
    [addPassenger setCenter:CGPointMake(controlXLength(passengerBackImage) - 85 + addPassenger.frame.size.width/2, (controlYLength(passengerBackImage) + passengerBackImage.frame.origin.y)/2)];
    [addPassenger addTarget:self action:@selector(pressAddPassenger:) forControlEvents:UIControlEventTouchUpInside];
    [addPassenger setImage:imageNameAndType(@"orderfillin_addpassenger_normal", @"png") forState:UIControlStateNormal];
    [addPassenger setImage:imageNameAndType(@"orderfillin_addpassenger_press", @"png") forState:UIControlStateHighlighted];
    [self.contentView addSubview:addPassenger];
    
    UIView *movingSubview = [[[UIView alloc]initWithFrame:CGRectMake(0, controlYLength(passengerBackImage) + 10, self.view.frame.size.width, 0)]autorelease];
    [movingSubview setBackgroundColor:[UIColor clearColor]];
    [movingSubview setTag:200];
    [self.contentView addSubview:movingSubview];

    UIImageView *addContactsBackImage = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, passengerBackImage.frame.size.width, 80)]autorelease];//255
    [addContactsBackImage setBackgroundColor:[UIColor clearColor]];
    [addContactsBackImage setImage:stretchImage(@"queryinfocell_normal", @"png")];
    [movingSubview addSubview:addContactsBackImage];
    
    UIImageView *contactNameInput = [[UIImageView alloc]initWithFrame:CGRectMake(addContactsBackImage.frame.origin.x + addContactsBackImage.frame.size.width/4 - 10, addContactsBackImage.frame.origin.y, addContactsBackImage.frame.size.width *3/4 - 80, addContactsBackImage.frame.size.height/2)];
    [contactNameInput setBackgroundColor:[UIColor clearColor]];
    [contactNameInput setBounds:CGRectMake(0, 0, contactNameInput.frame.size.width, contactNameInput.frame.size.height * 0.8)];
    [contactNameInput setImage:stretchImage(@"filltextbackimage", @"png")];
    [movingSubview addSubview:contactNameInput];
    
    UIImageView *contactNumInput = [[UIImageView alloc]initWithFrame:CGRectMake(contactNameInput.frame.origin.x, controlYLength(addContactsBackImage) - contactNameInput.frame.size.height - 4, contactNameInput.frame.size.width, contactNameInput.frame.size.height)];
    [contactNumInput setBackgroundColor:[UIColor clearColor]];
    [contactNumInput setImage:stretchImage(@"filltextbackimage", @"png")];
    [movingSubview addSubview:contactNumInput];


    UIButton *contactNameLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactNameLeft setBackgroundColor:[UIColor clearColor]];
    [contactNameLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [contactNameLeft setTitle:@"联 系 人" forState:UIControlStateNormal];
    [contactNameLeft.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [contactNameLeft addTarget:self action:@selector(clearKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [contactNameLeft setFrame:CGRectMake(0,0, addContactsBackImage.frame.size.width/4, addContactsBackImage.frame.size.height/2)];
    
        
    
    self.contactName = [[[UITextField alloc]initWithFrame:CGRectMake(addContactsBackImage.frame.origin.x, addContactsBackImage.frame.origin.y, addContactsBackImage.frame.size.width, addContactsBackImage.frame.size.height/2)]autorelease];
    contactName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [contactName setLeftView:contactNameLeft];
    [contactName setLeftViewMode:UITextFieldViewModeAlways];
    [contactName setBackgroundColor:[UIColor clearColor]];
    if ([UserDefaults shareUserDefault].realName) {
        [contactName setText:[UserDefaults shareUserDefault].realName];
    }
    [contactName setDelegate:self];
    [contactName setReturnKeyType:UIReturnKeyDone];
    [contactName setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [movingSubview addSubview:contactName];
    
    UIButton *contactNumLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactNumLeft setBackgroundColor:[UIColor clearColor]];
    [contactNumLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [contactNumLeft setTitle:@"联系电话" forState:UIControlStateNormal];
    [contactNumLeft.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [contactNumLeft addTarget:self action:@selector(clearKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [contactNumLeft setFrame:CGRectMake(0, 0, contactNameLeft.frame.size.width,  contactNameLeft.frame.size.height)];
    
    self.contactNum = [[[UITextField alloc]initWithFrame:CGRectMake(contactName.frame.origin.x, controlYLength(contactName), contactName.frame.size.width, contactName.frame.size.height)]autorelease];
    contactNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [contactNum setLeftView:contactNumLeft];
    [contactNum setLeftViewMode:UITextFieldViewModeAlways];
    [contactNum setBackgroundColor:[UIColor clearColor]];
    if ([UserDefaults shareUserDefault].mobile) {
        [contactNum setText:[UserDefaults shareUserDefault].mobile];
    }
    //[contactNum setEnabled:NO];
    [contactNum setDelegate:self];
    [contactNum setReturnKeyType:UIReturnKeyDone];
    //[contactNum setBorderStyle:UITextBorderStyleBezel];
    [contactNum setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [movingSubview addSubview:self.contactNum];
    
    UIButton *addressBook = [UIButton buttonWithType:UIButtonTypeCustom];
    [addressBook setFrame:CGRectMake(0,0, contactName.frame.size.height*2, contactName.frame.size.height*2 * 0.8)];
    addressBook.center = CGPointMake((controlXLength(addContactsBackImage) + controlXLength(contactNameInput))/2, (controlYLength(addContactsBackImage) + addContactsBackImage.frame.origin.y)/2);
    [addressBook addTarget:self action:@selector(pressAddressBook:) forControlEvents:UIControlEventTouchUpInside];
    [addressBook setImage:imageNameAndType(@"orderfillin_contacts_normal", @"png") forState:UIControlStateNormal];
    [addressBook setImage:imageNameAndType(@"orderfillin_contacts_press", @"png") forState:UIControlStateHighlighted];
    [movingSubview addSubview:addressBook];
    
    UIImageView *subjoinServiceBackImage = [[[UIImageView alloc]initWithFrame:CGRectMake(addContactsBackImage.frame.origin.x, controlYLength(addContactsBackImage) + 10, addContactsBackImage.frame.size.width, 40)]autorelease];
    [subjoinServiceBackImage setImage:imageNameAndType(@"queryinfocell_normal", @"png")];
    [movingSubview addSubview:subjoinServiceBackImage];
    
    UILabel *leftBtn = [self getLabelWithFrame:CGRectMake(subjoinServiceBackImage.frame.origin.x, subjoinServiceBackImage.frame.origin.y, subjoinServiceBackImage.frame.size.width/5, subjoinServiceBackImage.frame.size.height) textAlignment:NSTextAlignmentRight backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] title:@"附加服务:" font:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [movingSubview addSubview:leftBtn];
    
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
    [movingSubview addSubview:subjoinService];
    
    UIImageView *passengerPromptImage = [[[UIImageView alloc]initWithFrame:CGRectMake(subjoinServiceBackImage.frame.origin.x, controlYLength(subjoinServiceBackImage) + 10, subjoinServiceBackImage.frame.size.width, 50)]autorelease];
    [passengerPromptImage setBackgroundColor:[UIColor clearColor]];
    [passengerPromptImage setImage:imageNameAndType(@"orderfillin_prompt", @"png")];
    [movingSubview addSubview:passengerPromptImage];
    
    UIImageView *passengerLeftImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [passengerLeftImage setCenter:CGPointMake(15, passengerPromptImage.frame.size.height/2)];
    [passengerLeftImage setImage:imageNameAndType(@"icons", @"png")];
    [passengerLeftImage setBackgroundColor:[UIColor clearColor]];
    [passengerPromptImage addSubview:passengerLeftImage];
    
    UILabel *passengerPrompt = [[[UILabel alloc]initWithFrame:CGRectMake(passengerLeftImage.center.x * 2, 0, passengerPromptImage.frame.size.width - passengerLeftImage.center.x * 2, passengerPromptImage.frame.size.height)]autorelease];
    [passengerPrompt setBackgroundColor:[UIColor clearColor]];
    [passengerPrompt setTextColor:[UIColor darkGrayColor]];
    [passengerPrompt setFont:[UIFont systemFontOfSize:11]];
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
    confirmButton.frame = CGRectMake(movingSubview.frame.size.width/6, controlYLength(passengerPromptImage) + 10, movingSubview.frame.size.width *2/3, 50);
    [confirmButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    [confirmButton setTitle:@"确认订单" forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"login_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"login_press" ofType:@"png"]] forState:UIControlStateSelected];
    [confirmButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"login_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [confirmButton addTarget:self action:@selector(pressConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    [movingSubview addSubview:confirmButton];
    /*
    
    
    UIImageView *contactNumBackImage = [[[UIImageView alloc]initWithFrame:CGRectMake(contactNameBackImage.frame.origin.x, contactNameBackImage.frame.origin.y + contactNameBackImage.frame.size.height + 1.5, contactNameBackImage.frame.size.width, contactNameBackImage.frame.size.height)]autorelease];
    [contactNumBackImage setImage:imageNameAndType(@"filltextbackimage", @"png")];
    [contactNumBackImage setBackgroundColor:[UIColor clearColor]];
    [movingSubview addSubview:contactNumBackImage];
    
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
    [movingSubview addSubview:self.contactNum];
    
    
    
    
    
    
    
    
    */

    [movingSubview setFrame:CGRectMake(movingSubview.frame.origin.x, movingSubview.frame.origin.y, movingSubview.frame.size.width, controlYLength(confirmButton) + 10)];
    [self.contentView resetContentSize];
        
}

- (void) setSubjoinviewFrame:(NSArray*)data
{
    
    NSMutableString *str = [NSMutableString string];
    for (int i = 0;i<[data count];i++) {
        PassengerInfo *passenger = [data objectAtIndex:i];
        [str appendFormat:@"乘客%d:  %@",i+1,passenger.name];
        if (passenger != [data lastObject]) {
            [str appendFormat:@"\n"];
        }
    }
    
    UIView *passengerBack = [self.contentView viewWithTag:300];
    UIButton *addPassenger = (UIButton*)[self.contentView viewWithTag:301];
    UIView *movingView = [self.contentView viewWithTag:200];

    CGFloat height = [Utils heightForWidth:passengers.frame.size.width text:str font:passengers.font];
    height = height >= 45?height:45;

    [UIView animateWithDuration:0.35
                     animations:^{
                         [passengers setText:[Utils textIsEmpty:str]?@"请添加乘客":str];

                         [passengerBack setFrame:CGRectMake(passengerBack.frame.origin.x, passengerBack.frame.origin.y, passengerBack.frame.size.width, height)];
                         [passengers setFrame:CGRectMake(passengers.frame.origin.x, passengers.frame.origin.y, passengers.frame.size.width, height)];
                         [addPassenger setCenter:CGPointMake(addPassenger.center.x, (controlYLength(passengerBack) + passengerBack.frame.origin.y)/2)];
                         
                         [movingView setFrame:CGRectMake(movingView.frame.origin.x, controlYLength(passengerBack) + 10, movingView.frame.size.width, movingView.frame.size.height)];
                     }completion:^(BOOL finished){
                         [self.contentView resetContentSize];
                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
