//
//  UpdatePasswordViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-9-10.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "UpdatePasswordViewController.h"
#import "Model.h"
#import "Utils.h"

@interface UpdatePasswordViewController ()

@end

@implementation UpdatePasswordViewController

@synthesize password;
@synthesize newsPassword;
@synthesize againPassword;

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
    [password        release];
    [newsPassword     release];
    [againPassword   release];
    [super           dealloc];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    [[Model shareModel] showPromptBoxWithText:[dic objectForKey:@"performResult"] modal:YES];

    if ([[dic objectForKey:@"performStatus"] isEqualToString:@"success"]) {
        [[UserDefaults shareUserDefault] clearDefaults];
        [[Model shareModel] pushView:[Model shareModel].mainView options:ViewTrasitionEffectMoveRight completion:^{
            [[Model shareModel].viewControllers removeAllObjects];
            [[Model shareModel].viewControllers addObject:[Model shareModel].mainView];
        }];
    }
}

- (void)requestError:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
}

- (void)pressSaveButton:(UIButton *)sender
{
    if (password.text.length >= 6 && password.text.length <= 20 && newsPassword.text.length >= 6 && newsPassword.text.length <= 20) {
        if (![newsPassword.text isEqualToString:againPassword.text]) {
            [[Model shareModel] showPromptBoxWithText:@"两次密码不相同" modal:NO];
            return;
        }
        [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 40 - 2, selfViewFrame.size.width, selfViewFrame.size.height + 2) belowView:nil enabled:NO];
        NSString *urlString = [NSString stringWithFormat:@"%@/updatePassword",UserServiceURL];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [Utils nilToNumber:[NSNumber numberWithInteger:[[UserDefaults shareUserDefault].userId integerValue]]],                         @"userId",
                                       [Utils NULLToEmpty:password.text],                   @"password",
                                       [Utils NULLToEmpty:newsPassword.text],               @"newPassword",
                                       nil];
        
        [self sendRequestWithURL:urlString params:params requestMethod:RequestGet userInfo:nil];
    }else {
        [[Model shareModel] showPromptBoxWithText:@"密码格式不正确" modal:NO];
    }
    
}

- (void)pressReturnButton:(UIButton*)sender
{
    BaseUIViewController *prevView = [[Model shareModel].viewControllers objectAtIndex:([[Model shareModel].viewControllers indexOfObject:self] - 1)];
    [[Model shareModel] pushView:prevView options:ViewTrasitionEffectMoveRight completion:^{
        [[Model shareModel].viewControllers removeObject:self];
    }];
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
    if ([password isFirstResponder]) {
        responder = password;
    }if ([newsPassword isFirstResponder]) {
        responder = newsPassword;
    }if ([againPassword isFirstResponder]) {
        responder = againPassword;
    }
    if (responder) {
        if (responder.frame.origin.y + responder.frame.size.height > frame.origin.y - 40) {
            CGFloat changeY = responder.frame.origin.y + responder.frame.size.height - (frame.origin.y - 40.0f);
            [UIView animateWithDuration:duration
                             animations:^{
                                 [self.view setFrame:CGRectMake(0, self.view.frame.origin.y - changeY, self.view.frame.size.width, self.view.frame.size.height)];
                             }
                             completion:^(BOOL finished){
                                 
                             }];
        }
    }
}

- (void)keyBoardHide:(CGRect)frame animationDuration:(NSTimeInterval)duration
{
    UITextField *responder = nil;
    if ([password isFirstResponder]) {
        responder = password;
    }if ([newsPassword isFirstResponder]) {
        responder = newsPassword;
    }if ([againPassword isFirstResponder]) {
        responder = againPassword;
    }
    if (responder) {
        if (responder.frame.origin.y + responder.frame.size.height < frame.origin.y) {
            [UIView animateWithDuration:duration
                             animations:^{
                                 [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                             }
                             completion:^(BOOL finished){
                                 
                             }];
        }
    }
}

- (void)clearKeyboard
{
    if ([password canResignFirstResponder]) {
        [password resignFirstResponder];
    }if ([newsPassword canResignFirstResponder]) {
        [newsPassword resignFirstResponder];
    }if ([againPassword canResignFirstResponder]) {
        [againPassword resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self clearKeyboard];
    return YES;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self clearKeyboard];
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
    
    UILabel *titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(80, 0, 160, 40)]autorelease];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor       = [UIColor whiteColor];
    titleLabel.textAlignment   = NSTextAlignmentCenter;
    [titleLabel setText:@"修改密码"];
    [self.view addSubview:titleLabel];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateSelected];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(pressReturnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    
    [self setSubViewFrame];
}

- (void)setSubViewFrame
{
    UIButton *passwordButton = [self getButtonWithFrame:CGRectMake(0, 0, 80, 45) title:@"旧密码:" textColor:[UIColor darkGrayColor] forState:UIControlStateNormal backGroundColor:[UIColor clearColor]];
    [passwordButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [passwordButton addTarget:self action:@selector(clearKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [passwordButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [passwordButton setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    //[passwordButton setEnabled:NO];
    password = [[UITextField alloc]initWithFrame:CGRectMake(10, 20 + 40, self.view.frame.size.width - 20, 45)];
    [password setBackgroundColor:[UIColor clearColor]];
    [password setBackground:imageNameAndType(@"userlabel", @"png")];
    password.leftView = passwordButton;
    [password setDelegate:self];
    password.secureTextEntry = YES;
    password.leftViewMode = UITextFieldViewModeAlways;
    [password setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.view addSubview:password];
    
    UIButton *newPasswordButton = [self getButtonWithFrame:CGRectMake(0, 0, 80, 45) title:@"新密码:" textColor:[UIColor darkGrayColor] forState:UIControlStateNormal backGroundColor:[UIColor clearColor]];
    [newPasswordButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [newPasswordButton addTarget:self action:@selector(clearKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [newPasswordButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [newPasswordButton setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    //[newPasswordButton setEnabled:NO];
    newsPassword = [[UITextField alloc]initWithFrame:CGRectMake(password.frame.origin.x, password.frame.origin.y + password.frame.size.height - 1, password.frame.size.width, password.frame.size.height)];
    [newsPassword setBackgroundColor:[UIColor clearColor]];
    [newsPassword setBackground:imageNameAndType(@"userlabel", @"png")];
    newsPassword.leftView = newPasswordButton;
    [newsPassword setDelegate:self];
    newsPassword.secureTextEntry = YES;
    newsPassword.leftViewMode = UITextFieldViewModeAlways;
    [newsPassword setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.view addSubview:newsPassword];
    
    UIButton *userNameButton = [self getButtonWithFrame:CGRectMake(0, 0, 80, 45) title:@"确认密码:" textColor:[UIColor darkGrayColor] forState:UIControlStateNormal backGroundColor:[UIColor clearColor]];
    [userNameButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [userNameButton addTarget:self action:@selector(clearKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [userNameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [userNameButton setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    //[userNameButton setEnabled:NO];
    againPassword = [[UITextField alloc]initWithFrame:CGRectMake(newsPassword.frame.origin.x, newsPassword.frame.origin.y + newsPassword.frame.size.height - 1, newsPassword.frame.size.width, newsPassword.frame.size.height)];
    [againPassword setBackgroundColor:[UIColor clearColor]];
    [againPassword setBackground:imageNameAndType(@"userlabel", @"png")];
    againPassword.leftView = userNameButton;
    [againPassword setDelegate:self];
    [newsPassword setSecureTextEntry:YES];
    againPassword.leftViewMode = UITextFieldViewModeAlways;
    [againPassword setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.view addSubview:againPassword];
    
    UIButton *saveButton = [self getButtonWithFrame:CGRectMake(0, 0, self.view.frame.size.width*2/3, 50) title:@"保存" textColor:nil forState:UIControlStateNormal backGroundColor:[UIColor clearColor]];
    [saveButton setCenter:CGPointMake(appFrame.size.width/2, (appFrame.size.height + againPassword.frame.origin.y + againPassword.frame.size.height)/2)];
    [saveButton setBackgroundImage:imageNameAndType(@"search_normal", @"png") forState:UIControlStateNormal];
    [saveButton setBackgroundImage:imageNameAndType(@"search_press", @"png") forState:UIControlStateHighlighted];
    [saveButton setBackgroundImage:imageNameAndType(@"search_press", @"png") forState:UIControlStateSelected];
    [saveButton addTarget:self action:@selector(pressSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
