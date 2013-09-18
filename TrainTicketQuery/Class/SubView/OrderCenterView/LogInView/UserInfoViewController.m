//
//  UserInfoViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-9-10.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "UserInfoViewController.h"
#import "User.h"
#import "Model.h"
#import "OrderDetailViewController.h"
#import "RegisterAndLogInViewController.h"
#import "UpdatePasswordViewController.h"
#import "PassengerInfoViewController.h"
#import "Utils.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

@synthesize userName;
@synthesize cardNum;
@synthesize sex;
@synthesize mailAddress;
@synthesize updatePassword;

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
    [userName        release];
    [cardNum         release];
    [sex        release];
    [mailAddress     release];
    [updatePassword  release];
    [super           dealloc];
}

- (id)initWithUserId:(NSInteger)userId
{
    self = [super init];
    if (self) {
        self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
        [self initView];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)getUserInfo:(NSInteger)userId
{
    if (![UserDefaults shareUserDefault].getUserInfo) {
        [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 40.0f - 1.5f, selfViewFrame.size.width, selfViewFrame.size.height + 1.5f) belowView:nil enabled:NO];
        NSString *urlString = [NSString stringWithFormat:@"%@/getUser",UserServiceURL];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [Utils nilToNumber:[NSNumber numberWithInteger:userId]],  @"userId",
                                       nil];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"getUser",                      @"requestType",
                                  nil];
        
        [self sendRequestWithURL:urlString params:params requestMethod:RequestGet userInfo:userInfo];
    }else{
        [userName setText:[Utils NULLToEmpty:[UserDefaults shareUserDefault].realName]];
        [mailAddress setText:[Utils NULLToEmpty:[UserDefaults shareUserDefault].email]];
        
        [sex setText:[[UserDefaults shareUserDefault].sex integerValue] == 0?@"男":@"女"];
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

    NSString *requestType = [request.userInfo objectForKey:@"requestType"];
    
    if ([requestType isEqualToString:@"updateUser"]) {
        if ([[dic objectForKey:@"performStatus"] isEqualToString:@"success"]) {
            [[Model shareModel] showPromptBoxWithText:[dic objectForKey:@"performStatus"] modal:NO];
        }
    }
    else if([requestType isEqualToString:@"getUser"]){
        if ([[dic objectForKey:@"performStatus"] isEqualToString:@"success"]) {
            User* user = [[[User alloc]initWithData:[dic objectForKey:@"performResult"]]autorelease];
            [userName setText:user.realName];
            [mailAddress setText:user.email];
            [sex setText:user.sex == 0?@"男":@"女"];

            [UserDefaults shareUserDefault].realName = user.realName;
            [UserDefaults shareUserDefault].mobile   = user.mobile;
            [UserDefaults shareUserDefault].email    = user.email;
            [UserDefaults shareUserDefault].sex      = [NSString stringWithFormat:@"%d",user.sex];
            
            [UserDefaults shareUserDefault].getUserInfo = YES;
        }
    }
}

- (void)requestError:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
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
    [titleLabel setText:@"个人信息"];
    [self.view addSubview:titleLabel];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateSelected];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(pressReturnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(selfViewFrame.size.width - returnBtn.frame.size.width - 5, returnBtn.frame.origin.y, returnBtn.frame.size.width + 5, returnBtn.frame.size.height);
    [rightBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"usersetting_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"usersetting_press" ofType:@"png"]] forState:UIControlStateSelected];
    [rightBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"usersetting_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(pressRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    [self setSubViewFrame];
}

- (void)setSubViewFrame
{
    UIButton *userNameButton = [self getButtonWithFrame:CGRectMake(0, 0, 80, 45) title:@"姓名:" textColor:[UIColor darkGrayColor] forState:UIControlStateNormal backGroundColor:[UIColor clearColor]];
    [userNameButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [userNameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [userNameButton setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [userNameButton setEnabled:NO];
    userName = [[UITextField alloc]initWithFrame:CGRectMake(10, 20 + 40, self.view.frame.size.width - 20, 45)];
    [userName setBackgroundColor:[UIColor clearColor]];
    [userName setBackground:imageNameAndType(@"userlabel", @"png")];
    userName.leftView = userNameButton;
    userName.leftViewMode = UITextFieldViewModeAlways;
    [userName setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.view addSubview:userName];
    
    /*
    UIButton *cardNumButton = [self getButtonWithFrame:CGRectMake(0, 0, 80, 45) title:@"身份证:" textColor:[UIColor darkGrayColor] forState:UIControlStateNormal backGroundColor:[UIColor clearColor]];
    [cardNumButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cardNumButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [cardNumButton setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [cardNumButton setEnabled:NO];
    cardNum = [[UITextField alloc]initWithFrame:CGRectMake(userName.frame.origin.x, userName.frame.origin.y + userName.frame.size.height - 1, userName.frame.size.width, userName.frame.size.height)];
    [cardNum setBackgroundColor:[UIColor clearColor]];
    [cardNum setBackground:imageNameAndType(@"userlabel", @"png")];
    cardNum.leftView = cardNumButton;
    cardNum.leftViewMode = UITextFieldViewModeAlways;
    [cardNum setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.view addSubview:cardNum];*/
    
    UIButton *mailAddressButton = [self getButtonWithFrame:CGRectMake(0, 0, 80, 45) title:@"邮箱:" textColor:[UIColor darkGrayColor] forState:UIControlStateNormal backGroundColor:[UIColor clearColor]];
    [mailAddressButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [mailAddressButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [mailAddressButton setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [mailAddressButton setEnabled:NO];
    mailAddress = [[UITextField alloc]initWithFrame:CGRectMake(userName.frame.origin.x, userName.frame.origin.y + userName.frame.size.height - 1, userName.frame.size.width, userName.frame.size.height)];
    [mailAddress setBackgroundColor:[UIColor clearColor]];
    [mailAddress setBackground:imageNameAndType(@"userlabel", @"png")];
    mailAddress.leftView = mailAddressButton;
    mailAddress.leftViewMode = UITextFieldViewModeAlways;
    [mailAddress setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.view addSubview:mailAddress];
    
    UIButton *sexButton = [self getButtonWithFrame:CGRectMake(0, 0, 80, 45) title:@"性别:" textColor:[UIColor darkGrayColor] forState:UIControlStateNormal backGroundColor:[UIColor clearColor]];
    [sexButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [sexButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [sexButton setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [sexButton setEnabled:NO];
    sex = [[UITextField alloc]initWithFrame:CGRectMake(mailAddress.frame.origin.x, mailAddress.frame.origin.y + mailAddress.frame.size.height - 1, mailAddress.frame.size.width, mailAddress.frame.size.height)];
    [sex setBackgroundColor:[UIColor clearColor]];
    [sex setBackground:imageNameAndType(@"userlabel", @"png")];
    sex.leftView = sexButton;
    sex.leftViewMode = UITextFieldViewModeAlways;
    [sex setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.view addSubview:sex];
    
    UIButton *chooseSex = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseSex setFrame:sex.frame];
    [chooseSex setBackgroundColor:[UIColor clearColor]];
    [chooseSex addTarget:self action:@selector(pressChooseSex:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseSex];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(sex.frame.origin.x, sex.frame.origin.y + sex.frame.size.height + 20, sex.frame.size.width, sex.frame.size.height)];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [imageView setImage:imageNameAndType(@"userlabel", @"png")];
    [self.view addSubview:imageView];
    
    self.updatePassword = [UIButton buttonWithType:UIButtonTypeCustom];
    [updatePassword setFrame:imageView.frame];
    [updatePassword setBackgroundImage:imageNameAndType(@"userarrow", @"png") forState:UIControlStateNormal];
    [updatePassword setTitle:@"修改密码" forState:UIControlStateNormal];
    [updatePassword.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [updatePassword setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [updatePassword addTarget:self action:@selector(pressUpdatePassword:) forControlEvents:UIControlEventTouchUpInside];
    [updatePassword setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [updatePassword setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [updatePassword setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:updatePassword];
    
    UIButton *saveButton = [self getButtonWithFrame:CGRectMake(0, 0, self.view.frame.size.width*2/3, 50) title:@"保存" textColor:nil forState:UIControlStateNormal backGroundColor:[UIColor clearColor]];
    [saveButton setCenter:CGPointMake(appFrame.size.width/2, (appFrame.size.height + updatePassword.frame.origin.y + updatePassword.frame.size.height)/2)];
    [saveButton setBackgroundImage:imageNameAndType(@"search_normal", @"png") forState:UIControlStateNormal];
    [saveButton setBackgroundImage:imageNameAndType(@"search_press", @"png") forState:UIControlStateHighlighted];
    [saveButton setBackgroundImage:imageNameAndType(@"search_press", @"png") forState:UIControlStateSelected];
    [saveButton addTarget:self action:@selector(pressSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
}

- (void)pressUpdatePassword:(UIButton *)sender
{
    UpdatePasswordViewController *updatePasswordView = [[[UpdatePasswordViewController alloc]init]autorelease];
    [[Model shareModel] pushView:updatePasswordView options:ViewTrasitionEffectMoveLeft completion:^{
        [[Model shareModel].viewControllers addObject:updatePasswordView];
    }];
}

- (void)pressChooseSex:(UIButton*)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"选择性别" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女", nil];
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [sex setText:@"男"];
            break;
        case 2:
            [sex setText:@"女"];
            break;
        default:
            break;
    }
}

- (void)pressSaveButton:(UIButton *)sender
{
    [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 40 - 2, selfViewFrame.size.width, selfViewFrame.size.height - 40 + 2) belowView:nil enabled:NO];
    NSString *urlString = [NSString stringWithFormat:@"%@/updateUser",UserServiceURL];
    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [Utils NULLToEmpty:[UserDefaults shareUserDefault].userId],      @"userId",
                                   //[Utils NULLToEmpty:[UserDefaults shareUserDefault].userName],    @"userName",
                                   //[Utils NULLToEmpty:[UserDefaults shareUserDefault].passWord],    @"password",
                                   [Utils NULLToEmpty:userName.text],                               @"realName",
                                   [Utils NULLToEmpty:mailAddress.text],                            @"email",
                                    [Utils nilToNumber:[NSNumber numberWithInteger:[sex.text isEqualToString:@"男"]?0:1]],                                    @"sex",
                                   nil];
    User *user = [[User alloc]initWithData:userDic];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Utils NULLToEmpty:[user JSONRepresentation]],          @"user",
                            nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"updateUser",                    @"requestType",
                              nil];
    
    [self sendRequestWithURL:urlString params:params requestMethod:RequestPost userInfo:userInfo];
}

- (void)pressRightButton:(UIButton*)sender
{
    PassengerInfoViewController *passengerInfo = [[[PassengerInfoViewController alloc]init]autorelease];
        [[Model shareModel] pushView:passengerInfo options:ViewTrasitionEffectMoveLeft completion:^{
            [[Model shareModel].viewControllers addObject:passengerInfo];
            [passengerInfo getPassengers];
        }];
}

- (void)pressReturnButton:(UIButton*)sender
{
    BaseUIViewController *prevView = [[Model shareModel].viewControllers objectAtIndex:([[Model shareModel].viewControllers indexOfObject:self] - 1)];
    [[Model shareModel] pushView:prevView options:ViewTrasitionEffectMoveRight completion:^{
        [[Model shareModel].viewControllers removeObject:self];
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self clearKeyboard];
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
    }if ([mailAddress isFirstResponder]) {
        responder = mailAddress;
    }if ([sex isFirstResponder]) {
        responder = sex;
    }
    if (responder) {
        if (responder.frame.origin.y + responder.frame.size.height  > frame.origin.y - 40) {
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
    if ([userName isFirstResponder]) {
        responder = userName;
    }if ([mailAddress isFirstResponder]) {
        responder = mailAddress;
    }if ([sex isFirstResponder]) {
        responder = sex;
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
    if ([userName canResignFirstResponder]) {
        [userName resignFirstResponder];
    }if ([cardNum canResignFirstResponder]) {
        [cardNum resignFirstResponder];
    }if ([sex canResignFirstResponder]) {
        [sex resignFirstResponder];
    }if ([mailAddress canResignFirstResponder]) {
        [mailAddress resignFirstResponder];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
