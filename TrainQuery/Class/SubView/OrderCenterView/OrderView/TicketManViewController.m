//
//  TicketManViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-20.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "TicketManViewController.h"
#import "Utils.h"
#import "Model.h"

@interface TicketManViewController ()

@end

@implementation TicketManViewController

@synthesize delegate;
@synthesize reserveBtn;
@synthesize idCardType;
@synthesize idCardNum;
@synthesize birthDay;
@synthesize passenger;
@synthesize datePicker;
@synthesize addOrUpdate;

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
    self.delegate            = nil;
    [reserveBtn              release];
    [idCardType              release];
    [idCardNum               release];
    [birthDay                release];
    [passenger               release];
    [datePicker              release];
    [super                   dealloc];
}


- (id)initWithPassenger:(PassengerInfo*)_passenger
{
    self = [super init];
    if (self) {
        self.view.frame = CGRectMake(0, 20 + 40 + 60*2 - 12, appFrame.size.width, appFrame.size.height - (20 + 40 + 60*2) + 12);
        if (_passenger) {
            self.passenger = _passenger;
        }
//        passenger = [[PassengerInfo alloc]init];
//        [passenger copyDataWithObject:_passenger];
        
        [self initView];
        [self setDetailViewFrame];
    }
    
    return self;
}


- (id)init
{
    self = [super init];
    if (self) {
        self.view.frame = CGRectMake(0, 20 + 40 + 60*2 - 12, appFrame.size.width, appFrame.size.height - (20 + 40 + 60*2) + 12);
        passenger = [[PassengerInfo alloc]init];

        [self initView];
        [self setDetailViewFrame];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - other method
- (void)pressReserveBtn:(UIButton*)sender
{
    if (![self checkNumberLegal:idCardNum.text]) {
        [[Model shareModel] showPromptBoxWithText:@"身份证不合法" modal:NO];
        return;
    }
    if (addOrUpdate == PassengerAdd) {
        PassengerInfo *superPassenger = [self.delegate getSuperPassengerInfo];
        passenger.name                = superPassenger.name;
    }
    passenger.userId              = [[UserDefaults shareUserDefault].userId integerValue];
    passenger.birthDate           = birthDay.titleLabel.text;
    passenger.type                = 2;
    
    if (!passenger.name) {
        [[Model shareModel] showPromptBoxWithText:@"姓名不能为空" modal:NO];
        return;
    }

    if ([Utils textIsEmpty:idCardNum.text]) {
        [[Model shareModel] showPromptBoxWithText:@"身份证号码不能为空" modal:NO];
        return;
    }
    passenger.certificateType = [self checkIdCardTypeWithString:idCardType.titleLabel.text];
    passenger.certificateNumber = idCardNum.text;
    
    if (!passenger.birthDate) {
        [[Model shareModel] showPromptBoxWithText:@"请选择出生日期" modal:NO];
        return;
    }
    if (![UserDefaults shareUserDefault].userId) {
        if (addOrUpdate == PassengerAdd){
            [[UserDefaults shareUserDefault].contacts addObject:passenger];
            [[Model shareModel] showPromptBoxWithText:@"添加成功" modal:NO];
        }else if (addOrUpdate == PassengerUpdate){
            [[Model shareModel] showPromptBoxWithText:@"修改成功" modal:NO];
        }
        [self.delegate reloadData];
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/addOrUpdatePassenger",UserServiceURL];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [passenger JSONRepresentation],         @"passenger",
                            nil];
    [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 40 - 2, appFrame.size.width, appFrame.size.height + 2) belowView:nil enabled:NO];
    [self sendRequestWithURL:urlString params:params requestMethod:RequestPost userInfo:nil];
}

#pragma mark - request handle
- (void)requestDone:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
    [self parserStringBegin:request];
}

- (void)parserStringFinished:(NSString *)_string request:(ASIHTTPRequest *)request
{
    NSDictionary *dataDic = [_string JSONValue];
    if ([[dataDic objectForKey:@"performStatus"] isEqualToString:@"success"]) {
        [[Model shareModel] showPromptBoxWithText:[dataDic objectForKey:@"performResult"] modal:YES];
        [self.delegate reloadData];
    }else{
        [[Model shareModel] showPromptBoxWithText:@"新增失败" modal:YES];
    }
}

- (void)requestError:(ASIHTTPRequest *)request
{
    [[Model shareModel] showPromptBoxWithText:@"新增失败" modal:YES];
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if ([idCardType canResignFirstResponder]) {
        [idCardType resignFirstResponder];
    }if ([idCardNum canResignFirstResponder]) {
        [idCardNum resignFirstResponder];
    }if ([birthDay canResignFirstResponder]) {
        [birthDay resignFirstResponder];
    }
}

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
    if ([idCardType isFirstResponder]) {
        //responder = idCardType;
    }if ([idCardNum isFirstResponder]) {
        responder = idCardNum;
    }if ([birthDay isFirstResponder]) {
        //responder = birthDay;
    }
    if (responder) {
        if (responder.frame.origin.y + responder.frame.size.height  + manBaseYValue > frame.origin.y - 40) {
            CGFloat changeY = responder.frame.origin.y + responder.frame.size.height + manBaseYValue - (frame.origin.y - 40.0f);
            if (delegate) {
                [self.delegate resetViewFrame:CGRectMake(baseFrame.origin.x, baseFrame.origin.y - changeY, baseFrame.size.width, baseFrame.size.height) withAnimationDurarion:duration];
            }
        }
    }
}

- (void)keyBoardHide:(CGRect)frame animationDuration:(NSTimeInterval)duration
{
    UITextField *responder = nil;
    if ([idCardType isFirstResponder]) {
        //responder = idCardType;
    }if ([idCardNum isFirstResponder]) {
        responder = idCardNum;
    }if ([birthDay isFirstResponder]) {
        //responder = birthDay;
    }
    if (responder) {
        if (responder.frame.origin.y + responder.frame.size.height < frame.origin.y) {
            [self.delegate resetViewFrame:baseFrame withAnimationDurarion:duration];
        }
    }
}

- (void)clearKeyboard
{
    if ([idCardType canResignFirstResponder]) {
        [idCardType resignFirstResponder];
    }if ([idCardNum canResignFirstResponder]) {
        [idCardNum resignFirstResponder];
    }if ([birthDay canResignFirstResponder]) {
        [birthDay resignFirstResponder];
    }
}

#pragma mark - view init
- (void)initView
{
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)setDetailViewFrame
{
    UIImageView *baseImage1 = [self getImageViewWithFrame:CGRectMake(10, 0, selfViewFrame.size.width - 20, 60) image:imageNameAndType(@"infoframe_deep", @"png") highLightImage:nil backGroundColor:[UIColor clearColor]];
    UIImageView *baseImage2 = [self getImageViewWithFrame:CGRectMake(10, baseImage1.frame.origin.y + baseImage1.frame.size.height - 6, baseImage1.frame.size.width, baseImage1.frame.size.height) image:imageNameAndType(@"infoframe_light", @"png") highLightImage:nil backGroundColor:[UIColor clearColor]];
    UIImageView *baseImage3 = [self getImageViewWithFrame:CGRectMake(10, baseImage2.frame.origin.y + baseImage2.frame.size.height - 7, baseImage1.frame.size.width, baseImage1.frame.size.height) image:imageNameAndType(@"infoframe_deep", @"png") highLightImage:nil backGroundColor:[UIColor clearColor]];
    
    
    [self.view addSubview:baseImage1];
    [self.view addSubview:baseImage2];
    [self.view addSubview:baseImage3];
    
    UILabel *label1 = [self getLabelWithFrame:CGRectMake(baseImage1.frame.origin.x, baseImage1.frame.origin.y, 80, 60) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:nil title:@"证件类型" font:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    UILabel *label2 = [self getLabelWithFrame:CGRectMake(baseImage2.frame.origin.x, baseImage2.frame.origin.y, label1.frame.size.width, label1.frame.size.height) textAlignment:label1.textAlignment backGroundColor:label1.backgroundColor textColor:nil title:@"证件号码" font:label1.font];
    UILabel *label3 = [self getLabelWithFrame:CGRectMake(baseImage3.frame.origin.x, baseImage3.frame.origin.y, label1.frame.size.width, label1.frame.size.height) textAlignment:label1.textAlignment backGroundColor:label1.backgroundColor textColor:nil title:@"出生日期" font:label1.font];
    
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    [self.view addSubview:label3];
    
    self.idCardType = [UIButton buttonWithType:UIButtonTypeCustom];
    [idCardType setFrame:CGRectMake(label1.frame.origin.x + label1.frame.size.width + 10, label1.frame.origin.y, baseImage1.frame.size.width - label1.frame.size.width - 10, label1.frame.size.height)];
    [idCardType setBackgroundColor:[UIColor clearColor]];
    if (passenger.certificateType) {
        [idCardType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [idCardType setTitle:[self checkIdCardTypeWithValue:[passenger.certificateType integerValue]] forState:UIControlStateNormal];
    }else{
        [idCardType setTitle:@"身份证" forState:UIControlStateNormal];
        [idCardType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [idCardType.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [idCardType addTarget:self action:@selector(pressIdCardType:) forControlEvents:UIControlEventTouchUpInside];
    [idCardType setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.view addSubview:idCardType];
    
    idCardNum = [[UITextField alloc]initWithFrame:CGRectMake(label2.frame.origin.x + label2.frame.size.width + 10, label2.frame.origin.y, baseImage2.frame.size.width - label2.frame.size.width - 10, label2.frame.size.height)];
    idCardNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [idCardNum setPlaceholder:@"请输入证件号码"];
    if (passenger.certificateNumber) {
        [idCardNum setText:passenger.certificateNumber];
    }
    [idCardNum setDelegate:self];
    idCardNum.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:idCardNum];
    
    self.birthDay = [UIButton buttonWithType:UIButtonTypeCustom];
    [birthDay setFrame:CGRectMake(label3.frame.origin.x + label3.frame.size.width + 10, label3.frame.origin.y, baseImage3.frame.size.width - label3.frame.size.width - 10, label3.frame.size.height)];
    [birthDay setBackgroundColor:[UIColor clearColor]];
    [birthDay.titleLabel setFont:[UIFont systemFontOfSize:16]];
    if (passenger.birthDate) {
        [birthDay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [birthDay setTitle:passenger.birthDate forState:UIControlStateNormal];
    }else{
        [birthDay setTitle:@"出生日期" forState:UIControlStateNormal];
        [birthDay setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    [birthDay addTarget:self action:@selector(pressBirthDay:) forControlEvents:UIControlEventTouchUpInside];
    [birthDay setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.view addSubview:birthDay];
    
    self.reserveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reserveBtn.frame = CGRectMake(label3.frame.origin.x, label3.frame.origin.y, selfViewFrame.size.width*2/3, 50);
    [reserveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [reserveBtn addTarget:self action:@selector(pressReserveBtn:) forControlEvents:UIControlEventTouchUpInside];
    reserveBtn.center = CGPointMake(selfViewFrame.size.width/2, (selfViewFrame.size.height + label3.frame.origin.y + label3.frame.size.height)/2);
    [reserveBtn setBackgroundImage:imageNameAndType(@"search_normal", @"png") forState:UIControlStateNormal];
    [reserveBtn setBackgroundImage:imageNameAndType(@"search_press", @"png") forState:UIControlStateSelected];
    [reserveBtn setBackgroundImage:imageNameAndType(@"search_press", @"png") forState:UIControlStateHighlighted];
    [self.view addSubview:reserveBtn];
}

- (void)pressIdCardType:(UIButton*)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"选择证件类型" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"身份证",@"护照",@"港澳通行证", nil];
    [alertView setDelegate:self];
    alertView.tag = 101;
    [alertView show];
    
    [alertView release];
}

- (void)pressBirthDay:(UIButton*)sender
{
    if (datePicker) {
        [datePicker release];
    }
    BirthdayChooseViewController *birthdayView = [[BirthdayChooseViewController alloc]init];
    [birthdayView setDelegate:self];
    [self.delegate pushToViewController:birthdayView completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        switch (buttonIndex) {
            case 1:
                [idCardType setTitle:@"身份证" forState:UIControlStateNormal];
                break;
            case 2:
                [idCardType setTitle:@"护照" forState:UIControlStateNormal];
                break;
            case 3:
                [idCardType setTitle:@"港澳通行证" forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
    }else if(alertView.tag == 102){
        if (buttonIndex == 1) {
            
        }
    }
}

- (void)setBirthdayWithText:(NSString*)text
{
    [birthDay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [birthDay setTitle:text forState:UIControlStateNormal];
}

#pragma mark - textfield delegate method
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == idCardNum){
        passenger.certificateNumber = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField canResignFirstResponder]){
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)checkNumberLegal:(NSString*)text
{
    if (idCardNum.text != nil && ![idCardNum.text isEqualToString:@""]) {
        if ([idCardType.titleLabel.text isEqualToString:@"身份证"]) {
            if ([Utils isValidateIdNum:text]) {
                return YES;
            }else{
                return NO;
            }
        }else
            return YES;
    }else
        return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
