//
//  AboutViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-9-11.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "AboutViewController.h"
#import "Model.h"
#import "promptViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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


#pragma mark - view init
- (void)initView
{
    UIImageView *backImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
    [backImageView setImage:imageNameAndType(@"backgroundimage", @"png")];
    [self.view addSubview:backImageView];
    
    UIImageView *topImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, -1, self.view.frame.size.width, 40 + 1)]autorelease];
    [topImageView setImage:imageNameAndType(@"topbar_image", @"png")];
    [self.view addSubview:topImageView];
    
    UILabel *titleLabel = [self getLabelWithFrame:CGRectMake(80, 0, 160, 40) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] title:@"关于" font:nil];
    [self.view addSubview:titleLabel];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateSelected];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(pressReturnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    
    UIImageView *iconImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 100)]autorelease];
    [iconImageView setBackgroundColor:[UIColor clearColor]];
    [iconImageView setImage:imageNameAndType(@"abouticon", @"png")];
    [iconImageView setCenter:CGPointMake(appFrame.size.width/2, 40 + 40 + 55)];
    [self.view addSubview:iconImageView];
    
    UIImageView *userProtocolImage = [self getImageViewWithFrame:CGRectMake(25, iconImageView.frame.origin.y + iconImageView.frame.size.height + 50, self.view.frame.size.width - 50, 45) image:imageNameAndType(@"userlabel", @"png") highLightImage:nil backGroundColor:[UIColor clearColor]];
    [self.view addSubview:userProtocolImage];
    
    UIButton *userProtocolButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [userProtocolButton setFrame:userProtocolImage.frame];
    [userProtocolButton setBackgroundImage:imageNameAndType(@"userarrow", @"png") forState:UIControlStateNormal];
    [userProtocolButton setTitle:@"用户协议" forState:UIControlStateNormal];
    [userProtocolButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [userProtocolButton setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [userProtocolButton addTarget:self action:@selector(pressUserProtocolButton:) forControlEvents:UIControlEventTouchUpInside];
    [userProtocolButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [userProtocolButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [userProtocolButton setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:userProtocolButton];
    
    UIImageView *commonQuestionImage = [self getImageViewWithFrame:CGRectMake(userProtocolImage.frame.origin.x, userProtocolImage.frame.origin.y + userProtocolImage.frame.size.height - 1, userProtocolImage.frame.size.width, userProtocolImage.frame.size.height) image:imageNameAndType(@"userlabel", @"png") highLightImage:nil backGroundColor:[UIColor clearColor]];
    [self.view addSubview:commonQuestionImage];
    
    UIButton *commonQuestionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commonQuestionButton setFrame:commonQuestionImage.frame];
    [commonQuestionButton setBackgroundImage:imageNameAndType(@"userarrow", @"png") forState:UIControlStateNormal];
    [commonQuestionButton setTitle:@"常见问题" forState:UIControlStateNormal];
    [commonQuestionButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [commonQuestionButton setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [commonQuestionButton addTarget:self action:@selector(pressCommonQuestionButton:) forControlEvents:UIControlEventTouchUpInside];
    [commonQuestionButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [commonQuestionButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [commonQuestionButton setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:commonQuestionButton];
    
    UIImageView *aboutUsImage = [self getImageViewWithFrame:CGRectMake(commonQuestionImage.frame.origin.x, commonQuestionImage.frame.origin.y + commonQuestionImage.frame.size.height - 1, commonQuestionImage.frame.size.width, commonQuestionImage.frame.size.height) image:imageNameAndType(@"userlabel", @"png") highLightImage:nil backGroundColor:[UIColor clearColor]];
    [self.view addSubview:aboutUsImage];
    
    UIButton *aboutUsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aboutUsButton setFrame:aboutUsImage.frame];
    [aboutUsButton setBackgroundImage:imageNameAndType(@"userarrow", @"png") forState:UIControlStateNormal];
    [aboutUsButton setTitle:@"关于我们" forState:UIControlStateNormal];
    [aboutUsButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [aboutUsButton setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [aboutUsButton addTarget:self action:@selector(pressAboutUsButton:) forControlEvents:UIControlEventTouchUpInside];
    [aboutUsButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [aboutUsButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [aboutUsButton setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:aboutUsButton];
}

- (void)pressUserProtocolButton:(UIButton*)sender
{
    promptViewController *promptView = [[[promptViewController alloc]initWithPromptType:ShowUserProtocol]autorelease];
    [self pushViewController:promptView completion:^{
        [promptView getPrompt];
    }];
}

- (void)pressCommonQuestionButton:(UIButton*)sender
{
    promptViewController *promptView = [[[promptViewController alloc]initWithPromptType:ShowCommonQuestion]autorelease];
    [self pushViewController:promptView completion:^{
        [promptView getPrompt];
    }];
}

- (void)pressAboutUsButton:(UIButton*)sender
{
    promptViewController *promptView = [[[promptViewController alloc]initWithPromptType:ShowAboutUs]autorelease];
    [self pushViewController:promptView completion:^{
        [promptView getPrompt];
    }];
}

- (void)pressReturnButton:(UIButton*)sender
{
    [self popViewControllerCompletion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
