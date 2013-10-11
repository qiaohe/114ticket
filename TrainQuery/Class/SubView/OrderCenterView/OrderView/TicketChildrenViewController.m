//
//  TicketChildrenViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-20.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "TicketChildrenViewController.h"
#import "Model.h"
#import "Utils.h"
#import "PassengerInfo.h"

@interface TicketChildrenViewController ()

@end

@implementation TicketChildrenViewController

@synthesize delegate;
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
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 20 + 40 + 60*2 - 12, appFrame.size.width, appFrame.size.height - (20 + 40 + 60*2) + 12);
    //[self setDetailViewFrame];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - request handle
- (void)requestDone:(ASIHTTPRequest *)request
{
    [self parserStringBegin:request];
}

- (void)parserStringFinished:(NSString *)_string request:(ASIHTTPRequest *)request
{
    NSDictionary *dataDic = [_string JSONValue];
    if ([[dataDic objectForKey:@"performStatus"] isEqualToString:@"success"]) {
        [[Model shareModel] showPromptBoxWithText:[dataDic objectForKey:@"performResult"] modal:YES];
        if (self.delegate) {
            [self.delegate reloadData];
        }
    }else{
        [[Model shareModel] showPromptBoxWithText:@"新增失败" modal:YES];
    }
}

- (void)requestError:(ASIHTTPRequest *)request
{
    
}

#pragma mark - obher method
- (void)pressReserveBtn:(UIButton *)sender
{
    if (addOrUpdate == PassengerAdd) {
        PassengerInfo *superPassenger = [self.delegate getSuperPassengerInfo];
        passenger.name                = superPassenger.name;
    }
    passenger.type = TicketChildren;
    //passenger.mobile = @"321456987";
    passenger.userId            = [[UserDefaults shareUserDefault].userId integerValue];
    passenger.birthDate          = birthDay.titleLabel.text;
    
    if ([Utils textIsEmpty:passenger.name]) {
        [[Model shareModel] showPromptBoxWithText:@"姓名不能为空" modal:NO];
        return;
    }
    if ([Utils textIsEmpty:birthDay.titleLabel.text] || [birthDay.titleLabel.text isEqualToString:@"出生日期"]) {
        [[Model shareModel] showPromptBoxWithText:@"请选择出生日期" modal:NO];
        return;
    }
    passenger.certificateType = @"";
    passenger.certificateNumber = @"";
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if ([birthDay canResignFirstResponder]) {
        [birthDay resignFirstResponder];
    }
}

- (void)keyBoardShow:(CGRect)frame animationDuration:(NSTimeInterval)duration
{
    UITextField *responder = nil;
    if ([birthDay isFirstResponder]) {
        //responder = birthDay;
    }
    if (responder) {
        if (responder.frame.origin.y + responder.frame.size.height  + childBaseYValue > frame.origin.y - 40) {
            CGFloat changeY = responder.frame.origin.y + responder.frame.size.height + childBaseYValue - (frame.origin.y - 40.0f);
            if (delegate) {
                [self.delegate resetViewFrame:CGRectMake(baseFrame.origin.x, baseFrame.origin.y - changeY, baseFrame.size.width, baseFrame.size.height) withAnimationDurarion:duration];
            }
        }
    }
}

- (void)keyBoardHide:(CGRect)frame animationDuration:(NSTimeInterval)duration
{
    UITextField *responder = nil;
    if ([birthDay isFirstResponder]) {
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
    if ([birthDay canResignFirstResponder]) {
        [birthDay resignFirstResponder];
    }
}

#pragma mark - view init
- (void)initView
{
    self.view.backgroundColor = [UIColor clearColor];
    UIImageView *baseImage1 = [self getImageViewWithFrame:CGRectMake(10, 0, selfViewFrame.size.width - 20, 60) image:imageNameAndType(@"infoframe_deep", @"png") highLightImage:nil backGroundColor:[UIColor clearColor]];
    [self.view addSubview:baseImage1];
    
    UILabel *label1 = [self getLabelWithFrame:CGRectMake(baseImage1.frame.origin.x, baseImage1.frame.origin.y, 80, 60) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:nil title:@"出生日期" font:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    [self.view addSubview:label1];
    
    self.birthDay = [UIButton buttonWithType:UIButtonTypeCustom];
    [birthDay setFrame:CGRectMake(label1.frame.origin.x + label1.frame.size.width + 10, label1.frame.origin.y, baseImage1.frame.size.width - label1.frame.size.width - 10, label1.frame.size.height)];
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
    
    UIButton *reserveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reserveBtn.frame = CGRectMake(label1.frame.origin.x, label1.frame.origin.y, selfViewFrame.size.width*2/3, 50);
    [reserveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [reserveBtn addTarget:self action:@selector(pressReserveBtn:) forControlEvents:UIControlEventTouchUpInside];
    reserveBtn.center = CGPointMake(selfViewFrame.size.width/2, (selfViewFrame.size.height + label1.frame.origin.y + label1.frame.size.height)/2);
    [reserveBtn setBackgroundImage:imageNameAndType(@"search_normal", @"png") forState:UIControlStateNormal];
    [reserveBtn setBackgroundImage:imageNameAndType(@"search_press", @"png") forState:UIControlStateSelected];
    [reserveBtn setBackgroundImage:imageNameAndType(@"search_press", @"png") forState:UIControlStateHighlighted];
    [self.view addSubview:reserveBtn];
}


- (void)pressBirthDay:(UIButton*)sender
{
    BirthdayChooseViewController *birthdayView = [[BirthdayChooseViewController alloc]init];
    [birthdayView setDelegate:self];
    [self.delegate pushToViewController:birthdayView completion:nil];
    /*
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"出生日期" message:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alertView setDelegate:self];
    alertView.tag = 101;
    
    if (datePicker) {
        [datePicker release];
    }
    datePicker = [[UIDatePicker alloc]init];
    [datePicker setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"]autorelease]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.frame = CGRectMake(10, 40, self.view.frame.size.width - 35 - 20, 100);
    [alertView addSubview:datePicker];
    
    [alertView show];
    
    [alertView release];*/
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   if(alertView.tag == 101){
        if (buttonIndex == 1) {
            [birthDay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [birthDay setTitle:[Utils stringWithDate:datePicker.date withFormat:@"yyyy-MM-dd"]   forState:UIControlStateNormal];
        }
    }
}

- (void)setBirthdayWithText:(NSString*)text
{
    [birthDay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [birthDay setTitle:text forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
