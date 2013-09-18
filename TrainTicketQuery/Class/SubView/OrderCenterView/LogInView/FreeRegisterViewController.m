//
//  FreeRegisterViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-21.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "FreeRegisterViewController.h"
#import "Model.h"
#import "Utils.h"

@interface FreeRegisterViewController ()

@end

@implementation FreeRegisterViewController

@synthesize userName;
@synthesize passWord;
@synthesize againPassWord;
@synthesize textView;
@synthesize performResult;

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
    [userName      release];
    [passWord      release];
    [againPassWord release];
    [textView      release];
    [performResult release];
    [super         dealloc];
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
    UIImageView *backImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
    [backImageView setImage:imageNameAndType(@"backgroundimage", @"png")];
    [self.view addSubview:backImageView];
    
    UIImageView *topImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, -1, self.view.frame.size.width, 40 + 1)]autorelease];
    [topImageView setImage:imageNameAndType(@"topbar_image", @"png")];
    [self.view addSubview:topImageView];
    
    UILabel *titleLabel = [self getLabelWithFrame:CGRectMake(80, 0, 160, 40) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] title:@"免费注册" font:nil];
    [self.view addSubview:titleLabel];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateSelected];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(pressReturnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    
    [self setDetailViewFrame];
}

- (void)setDetailViewFrame
{
    UIImageView *baseImage1 = [self getImageViewWithFrame:CGRectMake(10, 40 + 40, selfViewFrame.size.width - 20, 60) image:imageNameAndType(@"infoframe_deep", @"png") highLightImage:nil backGroundColor:[UIColor clearColor]];
    UIImageView *baseImage2 = [self getImageViewWithFrame:CGRectMake(10, baseImage1.frame.origin.y + baseImage1.frame.size.height - 6, baseImage1.frame.size.width, baseImage1.frame.size.height) image:imageNameAndType(@"infoframe_light", @"png") highLightImage:nil backGroundColor:[UIColor clearColor]];
    UIImageView *baseImage3 = [self getImageViewWithFrame:CGRectMake(10, baseImage2.frame.origin.y + baseImage2.frame.size.height - 6, baseImage2.frame.size.width, baseImage2.frame.size.height) image:imageNameAndType(@"infoframe_light", @"png") highLightImage:nil backGroundColor:[UIColor clearColor]];
    
    [self.view addSubview:baseImage1];
    [self.view addSubview:baseImage2];
    [self.view addSubview:baseImage3];
    
    
    UILabel *label1 = [self getLabelWithFrame:CGRectMake(baseImage1.frame.origin.x, baseImage1.frame.origin.y, 80, 60) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:nil title:@"用户名" font:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    UILabel *label2 = [self getLabelWithFrame:CGRectMake(baseImage2.frame.origin.x, baseImage2.frame.origin.y, label1.frame.size.width, label1.frame.size.height) textAlignment:label1.textAlignment backGroundColor:label1.backgroundColor textColor:nil title:@"密码" font:label1.font];
    UILabel *label3 = [self getLabelWithFrame:CGRectMake(baseImage3.frame.origin.x, baseImage3.frame.origin.y, label1.frame.size.width, label1.frame.size.height) textAlignment:label1.textAlignment backGroundColor:label1.backgroundColor textColor:nil title:@"确认密码" font:label1.font];
    
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    [self.view addSubview:label3];
    
    userName = [[UITextField alloc]initWithFrame:CGRectMake(label1.frame.origin.x + label1.frame.size.width + 10, label1.frame.origin.y, baseImage1.frame.size.width - label1.frame.size.width - 10, label1.frame.size.height)];
    userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [userName setPlaceholder:@"请输入乘客姓名"];
    userName.text = @"18211913910";
    userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:userName];
    
    passWord = [[UITextField alloc]initWithFrame:CGRectMake(label2.frame.origin.x + label2.frame.size.width + 10, label2.frame.origin.y, baseImage2.frame.size.width - label2.frame.size.width - 10, label2.frame.size.height)];
    passWord.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [passWord setPlaceholder:@"请输入乘客姓名"];
    passWord.text = @"w5998991";
    passWord.secureTextEntry = YES;
    passWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:passWord];
    
    againPassWord = [[UITextField alloc]initWithFrame:CGRectMake(label3.frame.origin.x + label3.frame.size.width + 10, label3.frame.origin.y, baseImage3.frame.size.width - label3.frame.size.width - 10, label3.frame.size.height)];
    againPassWord.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [againPassWord setPlaceholder:@"请输入乘客姓名"];
    againPassWord.text = @"w5998991";
    againPassWord.secureTextEntry = YES;
    againPassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:againPassWord];
    
    UIButton *reserveButton = [self getButtonWithFrame:CGRectMake(0, 0, selfViewFrame.size.width*2/3, 50) title:@"提交注册" textColor:nil forState:UIControlStateNormal backGroundColor:[UIColor clearColor]];
    reserveButton.center = CGPointMake(selfViewFrame.size.width/2, (selfViewFrame.size.height - label3.frame.origin.y - label3.frame.size.height)/3 + (label3.frame.origin.y + label3.frame.size.height));
    [reserveButton addTarget:self action:@selector(pressReserveButton:) forControlEvents:UIControlEventTouchUpInside];
    [reserveButton setBackgroundImage:imageNameAndType(@"search_normal", @"png") forState:UIControlStateNormal];
    [reserveButton setBackgroundImage:imageNameAndType(@"search_press", @"png") forState:UIControlStateSelected];
    [reserveButton setBackgroundImage:imageNameAndType(@"search_press", @"png") forState:UIControlStateHighlighted];
    [self.view addSubview:reserveButton];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(20, reserveButton.frame.origin.y + reserveButton.frame.size.height, selfViewFrame.size.width - 40, reserveButton.frame.size.height*2)];
    [textView setText:@"注意:密码需要填写6-20位字符,可由英文字母,数字和符号组成,不能含空格"];
    [textView setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [textView setTextColor:[UIColor darkGrayColor]];
    textView.editable = NO;
    [textView setTextAlignment:NSTextAlignmentCenter];
    [textView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:textView];
}

#pragma mark - other method

- (void)pressReturnButton:(UIButton*)sender
{
    BaseUIViewController *prevView = [[Model shareModel].viewControllers objectAtIndex:([[Model shareModel].viewControllers indexOfObject:self] - 1)];
    [[Model shareModel] pushView:prevView options:ViewTrasitionEffectMoveRight completion:^{
        [[Model shareModel].viewControllers removeObject:self];
    }];
}

- (void)pressReserveButton:(UIButton*)sender
{
    [self freeRegister];
}

- (void)freeRegister
{
    if (![Utils isValidatePhoneNum:userName.text]) {
        [[Model shareModel] showPromptBoxWithText:@"用户名不正确" modal:NO];
    }else if (![passWord.text isEqualToString:againPassWord.text]){
        [[Model shareModel] showPromptBoxWithText:@"两次密码不同" modal:NO];
    }else if (!(passWord.text.length <= 20 && passWord.text.length >= 6)){
        [[Model shareModel] showPromptBoxWithText:@"密码格式不正确" modal:NO];
    }else{
        [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 0, selfViewFrame.size.width, selfViewFrame.size.height) belowView:nil enabled:NO];
        NSString *urlString = [NSString stringWithFormat:@"%@/register",UserServiceURL];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       userName.text,       @"userName",
                                       passWord.text,       @"password",
                                       //@"application/json", @"response",
                                       nil];
        [self sendRequestWithURL:urlString params:params requestMethod:RequestGet userInfo:nil];
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
    NSDictionary *dic = [_string JSONValue];
    [[Model shareModel] showPromptBoxWithText:[dic objectForKey:@"performResult"] modal:YES];
}

- (void)requestError:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
}

#pragma mark - clear blackboard handle
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if ([userName canResignFirstResponder]) {
        [userName resignFirstResponder];
    }if ([passWord canResignFirstResponder]) {
        [passWord resignFirstResponder];
    }if ([againPassWord canResignFirstResponder]) {
        [againPassWord resignFirstResponder];
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
    }if ([againPassWord isFirstResponder]) {
        responder = againPassWord;
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
    }if ([againPassWord isFirstResponder]) {
        responder = againPassWord;
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
