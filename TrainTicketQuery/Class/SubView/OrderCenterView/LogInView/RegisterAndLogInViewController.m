//
//  RegisterAndLogInViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-17.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "RegisterAndLogInViewController.h"
#import "FreeRegisterViewController.h"
#import "Model.h"
#import "UserDefaults.h"
#import "OrderFillInViewController.h"
#import "TrainQueryViewController.h"
#import "OrderCenterViewController.h"
#import "UserInfoViewController.h"

@interface RegisterAndLogInViewController ()

@end

@implementation RegisterAndLogInViewController

@synthesize userName;
@synthesize passWord;
@synthesize performResult;
@synthesize trainOrder;
@synthesize codeAndPrice;
@synthesize responseData;

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
    [userName                release];
    [passWord                release];
    [performResult           release];
    [trainOrder              release];
    [codeAndPrice            release];
    [responseData            release];
    [super                   dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
    [self initView];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - view init
- (void)initView
{
    [self setTopView];
    if (codeAndPrice) {
        [self setDetailView];
    }
    [self setLogInFrame];
}

- (void)setTopView
{
    UIImageView *backImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
    [backImageView setImage:imageNameAndType(@"backgroundimage", @"png")];
    [self.view addSubview:backImageView];
    
    UIImageView *topImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, -1, self.view.frame.size.width, 40 + 1)]autorelease];
    [topImageView setImage:imageNameAndType(@"topbar_image", @"png")];
    [self.view addSubview:topImageView];
    
    UILabel *titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(80, 0, 160, 40)]autorelease];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor       = [UIColor whiteColor];
    titleLabel.textAlignment   = NSTextAlignmentCenter;
    [titleLabel setText:@"登陆"];
    [self.view addSubview:titleLabel];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateSelected];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(pressReturnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
}

- (void)setDetailView
{
    UIButton *unMemberReserve = [UIButton buttonWithType:UIButtonTypeCustom];
    unMemberReserve.frame = CGRectMake(10, 40 + (selfViewFrame.size.height - 40)/10 - 10, 300, 45);
    unMemberReserve.contentEdgeInsets = UIEdgeInsetsMake(2, 15, 0, 0);
    unMemberReserve.tag = 101;
    unMemberReserve.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [unMemberReserve.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [unMemberReserve setTitle:@"非会员直接预订" forState:UIControlStateNormal];
    [unMemberReserve setBackgroundImage:imageNameAndType(@"member_normal", @"png") forState:UIControlStateNormal];
    [unMemberReserve setBackgroundImage:imageNameAndType(@"member_press", @"png") forState:UIControlStateHighlighted];
    [unMemberReserve addTarget:self action:@selector(pressUnMemberReserve:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:unMemberReserve];    
}

- (void)setLogInFrame
{
    UILabel *label = nil;
    UIButton *button = (UIButton*)[self.view viewWithTag:101];
    if (button) {
        label = [[[UILabel alloc]initWithFrame:CGRectMake(10, 40 + (selfViewFrame.size.height - 40)/5, 300, 30)]autorelease];
    }else
        label = [[[UILabel alloc]initWithFrame:CGRectMake(10, (selfViewFrame.size.height)/5, 300, 30)]autorelease];
    
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [label setText:@"老用户登录"];
    [self.view addSubview:label];
        
    UIImageView *logInfoImage = [[[UIImageView alloc]initWithFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y + label.frame.size.height, self.view.frame.size.width - label.frame.origin.x * 2, 120)]autorelease];
    [logInfoImage setImage:imageNameAndType(@"registeredinfoframe", @"png")];
    [self.view addSubview:logInfoImage];
    
    UILabel *userNameLabel = [[[UILabel alloc]initWithFrame:CGRectMake(logInfoImage.frame.origin.x, logInfoImage.frame.origin.y, 80, logInfoImage.frame.size.height/2)]autorelease];
    [userNameLabel setText:@"用户名"];
    [userNameLabel setTextAlignment:NSTextAlignmentCenter];
    [userNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    [userNameLabel setTextColor:[UIColor darkGrayColor]];
    [userNameLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:userNameLabel];
    
    userName = [[UITextField alloc]initWithFrame:CGRectMake(logInfoImage.frame.origin.x + 100, userNameLabel.frame.origin.y, logInfoImage.frame.size.width - 100, userNameLabel.frame.size.height)];
    userName.placeholder = @"邮箱/手机号";
    userName.keyboardType = UIKeyboardTypeEmailAddress;
    //userName.textAlignment = NSTextAlignmentCenter;
    [userName setBackgroundColor:[UIColor clearColor]];
    [userName setText:@"18211913910"];
    userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [userName setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [self.view addSubview:userName];
    
    UILabel *passWordLabel = [[[UILabel alloc]initWithFrame:CGRectMake( userNameLabel.frame.origin.x, userNameLabel.frame.origin.y + userNameLabel.frame.size.height, userNameLabel.frame.size.width, userNameLabel.frame.size.height)]autorelease];
    [passWordLabel setText:@"密码"];
    [passWordLabel setTextAlignment:NSTextAlignmentCenter];
    [passWordLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    [passWordLabel setTextColor:[UIColor darkGrayColor]];
    [passWordLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:passWordLabel];
    
    passWord = [[UITextField alloc]initWithFrame:CGRectMake(userName.frame.origin.x, passWordLabel.frame.origin.y, logInfoImage.frame.size.width - 100, userName.frame.size.height)];
    passWord.placeholder = @"请输入密码";
    passWord.keyboardType = UIKeyboardTypeEmailAddress;
    //userName.textAlignment = NSTextAlignmentCenter;
    [passWord setBackgroundColor:[UIColor clearColor]];
    [passWord setText:@"w5998991"];
    passWord.secureTextEntry = YES;
    passWord.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [passWord setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [self.view addSubview:passWord];
    
    
    UIButton *freeRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    freeRegister.frame = CGRectMake(logInfoImage.frame.origin.x, 40 + (selfViewFrame.size.height - 40)*3/5, logInfoImage.frame.size.width, 50);
    freeRegister.contentEdgeInsets = UIEdgeInsetsMake(2, 15, 0, 0);
    freeRegister.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [freeRegister.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [freeRegister setTitle:@"免费注册" forState:UIControlStateNormal];
    [freeRegister setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [freeRegister setBackgroundImage:imageNameAndType(@"registered_normal", @"png") forState:UIControlStateNormal];
    [freeRegister setBackgroundImage:imageNameAndType(@"registered_press", @"png") forState:UIControlStateHighlighted];
    [freeRegister addTarget:self action:@selector(pressFreeRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:freeRegister];
    
    UIButton *logInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logInButton.frame = CGRectMake(60, 40 + (selfViewFrame.size.height - 40)*4/5, selfViewFrame.size.width*2/3, 50);
    [logInButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    [logInButton setTitle:@"登陆" forState:UIControlStateNormal];
    [logInButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"login_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [logInButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"login_press" ofType:@"png"]] forState:UIControlStateSelected];
    [logInButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"login_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [logInButton addTarget:self action:@selector(pressLogInButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logInButton];
}

#pragma mark - press button handle
- (void)pressUnMemberReserve:(UIButton*)sender
{
    if (codeAndPrice) {
        OrderFillInViewController *fillInView = [[OrderFillInViewController alloc]initWithTrainOrder:trainOrder];
        fillInView.codeAndPrice = codeAndPrice;
        //fillInView.trainOrder = self.trainOrder;
        [fillInView.trainOrder setUserId:[[UserDefaults shareUserDefault].userId integerValue]];
        [[Model shareModel] pushView:fillInView options:ViewTrasitionEffectMoveLeft completion:^{
            [[Model shareModel].viewControllers addObject:fillInView];
        }];
    }else{
        TrainQueryViewController *trainQueryView = [[[TrainQueryViewController alloc]initWithTrainType:TrainQueryCommon]autorelease];
        [[Model shareModel] pushView:trainQueryView options:ViewTrasitionEffectMoveLeft completion:^{
            [[Model shareModel].viewControllers addObject:trainQueryView];
        }];
    }
}

- (void)pressFreeRegister:(UIButton*)sender
{
    FreeRegisterViewController *freeRegister = [[[FreeRegisterViewController alloc]init]autorelease];
    [[Model shareModel] pushView:freeRegister options:ViewTrasitionEffectMoveLeft completion:^{
        [[Model shareModel].viewControllers addObject:freeRegister];
    }];
}

- (void)pressLogInButton:(UIButton*)sender
{
    [self logIn];
}

- (void)logIn
{
    [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 0, selfViewFrame.size.width, selfViewFrame.size.height) belowView:nil enabled:NO];
    NSString *urlString = [NSString stringWithFormat:@"%@/login",UserServiceURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   userName.text,@"userName",
                                   passWord.text,@"password",
                                   //@"application/json",@"response",
                                   nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInteger:RequestLogIn],             @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params requestMethod:RequestLogIn userInfo:userInfo];
}
/*
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
*/
- (void)pressReturnButton:(UIButton*)sender
{
    BaseUIViewController *prevView = [[Model shareModel].viewControllers objectAtIndex:([[Model shareModel].viewControllers indexOfObject:self] - 1)];
    [[Model shareModel] pushView:prevView options:ViewTrasitionEffectMoveRight completion:^{
        [[Model shareModel].viewControllers removeObject:self];
    }];
}

#pragma mark - request handle
- (void)requestDone:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];

    NSInteger requestType = [[request.userInfo objectForKey:@"requestType"]integerValue];
    if (requestType == RequestLogIn) {
        [UserDefaults shareUserDefault].cookie = [request.responseHeaders objectForKey:@"Set-Cookie"];
    }else if(requestType == RequestLogOut){
        [[UserDefaults shareUserDefault] clearDefaults];
    }
    
    [self parserStringBegin:request];
}

- (void)parserStringFinished:(NSString *)_string request:(ASIHTTPRequest *)request
{
    NSDictionary *dic = [_string JSONValue];
    [[Model shareModel] showPromptBoxWithText:[dic objectForKey:@"performResult"] modal:YES];
    
    if ([[dic objectForKey:@"performStatus"] isEqualToString:@"success"]) {
        [UserDefaults shareUserDefault].userName = self.userName.text;
        [UserDefaults shareUserDefault].passWord = self.passWord.text;
        [UserDefaults shareUserDefault].userId   = [dic objectForKey:@"userId"];

        if (codeAndPrice) {

            OrderFillInViewController *fillInView = [[OrderFillInViewController alloc]initWithTrainOrder:trainOrder];
            fillInView.codeAndPrice = codeAndPrice;
            [[Model shareModel] pushView:fillInView options:ViewTrasitionEffectMoveLeft completion:^{
                [[Model shareModel].viewControllers addObject:fillInView];
            }];
        }else{
            OrderCenterViewController *orderCenterView = [[[OrderCenterViewController alloc]init]autorelease];
            [[Model shareModel] pushView:orderCenterView options:ViewTrasitionEffectMoveLeft completion:^{
                [[Model shareModel].viewControllers removeObject:self];
                [[Model shareModel].viewControllers addObject:orderCenterView];
                [orderCenterView threeMonthListShow];
            }];
        }
        
        
    }
}

- (void)requestError:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
}

#pragma mark - clear keyboard
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if ([userName canResignFirstResponder]) {
        [userName resignFirstResponder];
    }if ([passWord canResignFirstResponder]) {
        [passWord resignFirstResponder];
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
    if ([userName isFirstResponder]) {
        responder = userName;
    }if ([passWord isFirstResponder]) {
        responder = passWord;
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
    if ([userName isFirstResponder]) {
        responder = userName;
    }if ([passWord isFirstResponder]) {
        responder = passWord;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
