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
        self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
        [self initView];
    }
    return self;
}

- (id)initWithTrainOrder:(TrainOrder*)order
{
    self = [super init];
    if (self) {
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
    NSLog(@"response = %@",request.responseString);
    [self parserStringBegin:request];
}

- (void)parserStringFinished:(NSString *)_string request:(ASIHTTPRequest *)request
{
    NSDictionary *resultData = [_string JSONValue];
    NSLog(@"resultData = %@",resultData);
   
    if ([[resultData objectForKey:@"performStatus"] isEqualToString:@"success"]) {
        NSString *requestType = [request.userInfo objectForKey:@"requestType"];

        if ([requestType isEqualToString:@"checkTicketStatus"]) {
            
        }
    }else{
        TrainOrder *order = [[[TrainOrder alloc]init]autorelease];
        order.orderNum = [resultData objectForKey:@"orderNum"];
        order.orderId  = [[resultData objectForKey:@"orderId"] integerValue];
        order.amount   = amount;
        OrderDetailViewController *orderDetailView = [[[OrderDetailViewController alloc]initWithOrder:order]autorelease];
        [[Model shareModel] pushView:orderDetailView options:ViewTrasitionEffectMoveLeft completion:^{
            [[Model shareModel].viewControllers addObject:orderDetailView];
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
    /*
    if(![trainOrder.trainOrderDetails count]){
        [[Model shareModel] showPromptBoxWithText:@"请选择购票人" modal:NO];
    }else if ([Utils textIsEmpty:contactName.text] || [Utils textIsEmpty:contactNum.text]) {
        [[Model shareModel] showPromptBoxWithText:@"联系人和手机号不能为空" modal:NO];
    }else{
        [self inviteTicketPriceWithTrainOrder:trainOrder];
        trainOrder.totalAmount    = [[NSString stringWithFormat:@"%.2lf",amount.totalAmount] doubleValue];
        trainOrder.totalTickets   = [trainOrder.trainOrderDetails count];
        
        trainOrder.transactionFee = [[NSString stringWithFormat:@"%.2lf",amount.alipayAmount] doubleValue];
        trainOrder.userName       = contactName.text;
        trainOrder.userMobile     = contactNum.text;
                
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
        
        NSString *jsonString = [trainOrder JSONRepresentation];
                
        NSString *urlString = [NSString stringWithFormat:@"%@?trainOrderSync",TrainOrderServiceURL];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                jsonString,                 @"trainOrder",
                                nil];
    [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 40 - 2.0f, self.view.frame.size.width, self.view.frame.size.height - 40 + 2.0f) belowView:nil enabled:NO];
        [self sendRequestWithURL:urlString params:params requestMethod:RequestPost userInfo:nil];
    }*/
    [[Model shareModel] showPromptBoxWithText:@"暂不支持购票" modal:NO];
}

- (void)pressAddPassenger:(UIButton*)sender
{
    PassengerInfoViewController *passengerInfo = [[PassengerInfoViewController alloc]initWithCodeAndPrice:codeAndPrice];
    passengerInfo.trainOrder = self.trainOrder;
    passengerInfo.delegate = self;
    [[Model shareModel] pushView:passengerInfo options:ViewTrasitionEffectMoveLeft completion:^{
        [[Model shareModel].viewControllers addObject:passengerInfo];
        [passengerInfo getPassengers];
    }];
}

- (void)pressAddressBook:(UIButton*)sender
{
    /*
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc]init];
    
    peoplePicker.peoplePickerDelegate = self;
    
    [self presentViewController:peoplePicker animated:YES completion:^{
        
    }];*/
    [[Model shareModel] showPromptBoxWithText:@"暂不支持从电话薄中添加" modal:NO];
}

#pragma mark - addressbook delegate method
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (TotalAmount*)inviteTicketPriceWithTrainOrder:(TrainOrder*)order
{
    if (!amount) {
        amount = [[TotalAmount alloc]init];
    }
    
    if (selectedInsure) {
        amount.premiumAmount = [selectedInsure.inSureType doubleValue] * [order.trainOrderDetails count];
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
    
    amount.alipayAmount = (amount.ticketAmount + 10.0 * [order.trainOrderDetails count])/100;
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
    amount.saleSiteAmount = 5.0  * [order.trainOrderDetails count];
    amount.expressAmount  = 30.0 * [order.trainOrderDetails count];
    amount.alipayAmount = (amount.ticketAmount + amount.saleSiteAmount + amount.expressAmount + 10 * [order.trainOrderDetails count])/100;
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
    BaseUIViewController *prevView = [[Model shareModel].viewControllers objectAtIndex:([[Model shareModel].viewControllers indexOfObject:self] - 1)];
    [[Model shareModel] pushView:prevView options:ViewTrasitionEffectMoveRight completion:^{
        [[Model shareModel].viewControllers removeObject:self];
    }];
}

- (void)pressSubjoinService:(UIButton *)sender
{
    SubjoinServiceViewController *subjoinService = [[[SubjoinServiceViewController alloc]init]autorelease];
    subjoinService.delegate = self;
    [[Model shareModel] pushView:subjoinService options:ViewTrasitionEffectMoveLeft completion:^{
        [[Model shareModel].viewControllers addObject:subjoinService];
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
    
    UITextView *trainPrompt = [[UITextView alloc]initWithFrame:[Utils frameWithRect:CGRectMake(10, 140, 300, 40) adaptWidthOrHeight:adaptWidth]];//140
    [trainPrompt setBackgroundColor:[UIColor clearColor]];
    [trainPrompt setTextColor:[UIColor darkGrayColor]];
    trainPrompt.editable = NO;
    trainPrompt.scrollEnabled = NO;
    [trainPrompt setText:@"这里是提示这里是提示这里是提示这里是提示这里是提示这里是提示这里是提示这里是提示这里是提示"];
    trainPrompt.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:trainPrompt];
    
    UIImageView *passengerBackImage = [[UIImageView alloc]initWithFrame:[Utils frameWithRect:CGRectMake(10, 195, 300, 110) adaptWidthOrHeight:adaptNone]];//255
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
    
    UIImageView *contactNameBackImage = [[UIImageView alloc]initWithFrame:CGRectMake(passengers.frame.origin.x + 15, passengers.frame.origin.y + passengers.frame.size.height + 2.5, passengers.frame.size.width - 15, passengers.frame.size.height - 10)];
    [contactNameBackImage setImage:imageNameAndType(@"filltextbackimage", @"png")];
    [contactNameBackImage setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:contactNameBackImage];
    
    self.contactName = [[UITextField alloc]initWithFrame:CGRectMake(contactNameBackImage.frame.origin.x + 10, contactNameBackImage.frame.origin.y, contactNameBackImage.frame.size.width, contactNameBackImage.frame.size.height)];
    contactName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [contactName setBackgroundColor:[UIColor clearColor]];
    [contactName setText:[UserDefaults shareUserDefault].realName];
    //[contactName setEnabled:NO];
    [contactName setDelegate:self];
    [contactName setReturnKeyType:UIReturnKeyDone];
    //[contactName setBorderStyle:UITextBorderStyleBezel];
    [contactName setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [self.view addSubview:contactName];
    
    UIImageView *contactNumBackImage = [[UIImageView alloc]initWithFrame:CGRectMake(contactNameBackImage.frame.origin.x, contactNameBackImage.frame.origin.y + contactNameBackImage.frame.size.height + 1.5, contactNameBackImage.frame.size.width, contactNameBackImage.frame.size.height)];
    [contactNumBackImage setImage:imageNameAndType(@"filltextbackimage", @"png")];
    [contactNumBackImage setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:contactNumBackImage];
    
    self.contactNum = [[UITextField alloc]initWithFrame:CGRectMake(contactNumBackImage.frame.origin.x + 10, contactNumBackImage.frame.origin.y, contactNumBackImage.frame.size.width, contactNumBackImage.frame.size.height)];
    contactNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [contactNum setBackgroundColor:[UIColor clearColor]];
    [contactNum setText:[UserDefaults shareUserDefault].mobile];
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
    
    UIImageView *subjoinServiceBackImage = [[UIImageView alloc]initWithFrame:[Utils frameWithRect:CGRectMake(10, 305 + 10, 300, 40) adaptWidthOrHeight:adaptWidth]];
    [subjoinServiceBackImage setImage:imageNameAndType(@"queryinfocell_normal", @"png")];
    [self.view addSubview:subjoinServiceBackImage];
    
    UILabel *leftBtn = [self getLabelWithFrame:CGRectMake(subjoinServiceBackImage.frame.origin.x, subjoinServiceBackImage.frame.origin.y, subjoinServiceBackImage.frame.size.width/5, subjoinServiceBackImage.frame.size.height) textAlignment:NSTextAlignmentRight backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] title:@"附加服务:" font:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [self.view addSubview:leftBtn];
    
    UIButton *subjoinService = [UIButton buttonWithType:UIButtonTypeCustom];
    subjoinService.frame = CGRectMake(leftBtn.frame.origin.x + leftBtn.frame.size.width + 20, subjoinServiceBackImage.frame.origin.y + 5.0f, (subjoinServiceBackImage.frame.size.width - 20)*3/5,subjoinServiceBackImage.frame.size.height - 10);
    [subjoinService setBackgroundImage:imageNameAndType(@"registered_normal", @"png") forState:UIControlStateNormal];
    [subjoinService setBackgroundImage:imageNameAndType(@"registered_press", @"png") forState:UIControlStateHighlighted];
    [subjoinService setTitle:@"假一包赔100" forState:UIControlStateNormal];
    [subjoinService setTag:101];
    [subjoinService.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [subjoinService setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [subjoinService setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [subjoinService addTarget:self action:@selector(pressSubjoinService:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:subjoinService];
    
    UITextView *passengerPrompt = [[UITextView alloc]initWithFrame:[Utils frameWithRect:CGRectMake(10, 355, 300, 40) adaptWidthOrHeight:adaptWidth]];
    [passengerPrompt setBackgroundColor:[UIColor clearColor]];
    [passengerPrompt setTextColor:[UIColor darkGrayColor]];
    passengerPrompt.editable = NO;
    passengerPrompt.scrollEnabled = NO;
    [passengerPrompt setText:@"这里是提示这里是提示这里是提示这里是提示这里是提示这里是提示这里是提示这里是提示这里是提示"];
    passengerPrompt.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:passengerPrompt];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = [Utils frameWithRect:CGRectMake(0, 0, self.view.frame.size.width*2/3, 40) adaptWidthOrHeight:adaptWidth];
    confirmButton.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height + passengerPrompt.frame.size.height + passengerPrompt.frame.origin.y)/2);
    [confirmButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    [confirmButton setTitle:@"确认订单支付" forState:UIControlStateNormal];
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
