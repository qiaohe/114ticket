//
//  HomeViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-11.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "HomeViewController.h"
#import "Model.h"
#import "PlistProxy.h"
#import "UserDefaults.h"
#import "TrainQueryViewController.h"
#import "RegisterAndLogInViewController.h"
#import "OrderCenterViewController.h"
#import "AboutViewController.h"
#import "UserInfoViewController.h"
#import "WapAlipayViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize topShowView;
@synthesize trainQuery;
@synthesize bulletTrainQuery;
@synthesize about;
@synthesize orderCenter;

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
    [bulletTrainQuery release];
    [topShowView      release];
    [trainQuery       release];
    [orderCenter      release];
    [about            release];
    [super            dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [PlistProxy sharePlistProxy];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - view init
- (void)initView
{
    UIImageView *backGroundImage = [[[UIImageView alloc]initWithFrame:CGRectMake(0, -1, appFrame.size.width, appFrame.size.height + 1)]autorelease];
    [backGroundImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"homebackgroundimage.png" ofType:nil]]];
    [self.view addSubview:backGroundImage];
    
    [self setTopViewFrame];
    [self setTrainQueryViewFrame];
    [self setAboutViewFrame];
    [self setBullentTrainQueryViewFrame];
    [self setOrderCenterViewFrame];
    
}

- (void)setTopViewFrame
{
    topShowView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 10, appFrame.size.width - 20, appFrame.size.height/3)];
    topShowView.contentSize = CGSizeMake(topShowView.frame.size.width*3, topShowView.frame.size.height/3);
    topShowView.showsHorizontalScrollIndicator = NO;
    topShowView.showsVerticalScrollIndicator   = NO;
    topShowView.pagingEnabled                  = YES;
    topShowView.delegate                       = self;
    
    NSArray *topViewImageArray = [NSArray arrayWithObjects:@"image1.png",@"image2.png",@"image3.png", nil];
    for (int i = 0; i<[topViewImageArray count]; i++) {
        NSString *imageName = [topViewImageArray objectAtIndex:i];
        UIImageView *imageView = [[[UIImageView alloc]initWithFrame:CGRectMake(topShowView.frame.size.width * i, 0, topShowView.frame.size.width, topShowView.frame.size.height)]autorelease];
        [imageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:nil]]];
        [topShowView addSubview:imageView];
    }
    [self.view addSubview:topShowView];
}

- (void)setTrainQueryViewFrame
{
    self.trainQuery = [UIButton buttonWithType:UIButtonTypeCustom];
    self.trainQuery.frame = CGRectMake(topShowView.frame.origin.x, topShowView.frame.origin.y + topShowView.frame.size.height + 10, (topShowView.frame.size.width - 10)/2, (appFrame.size.height - (topShowView.frame.origin.y + topShowView.frame.size.height + 10))*2/3 - 10);
    [self.trainQuery setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"]] forState:UIControlStateNormal];
    [self.trainQuery setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"home_trainquery" ofType:@"png"]] forState:UIControlStateNormal];
    [self.trainQuery addTarget:self action:@selector(pressTrainQueryButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.trainQuery];
}

- (void)setAboutViewFrame
{
    self.about = [UIButton buttonWithType:UIButtonTypeCustom];
    self.about.frame = CGRectMake(self.trainQuery.frame.origin.x, self.trainQuery.frame.origin.y + self.trainQuery.frame.size.height + 10, self.trainQuery.frame.size.width, (appFrame.size.height - (topShowView.frame.origin.y + topShowView.frame.size.height + 10))/3 - 10);
    [self.about setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"3" ofType:@"png"]] forState:UIControlStateNormal];
    [self.about setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"home_about" ofType:@"png"]] forState:UIControlStateNormal];
    [self.about addTarget:self action:@selector(pressAboutButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.about];
}

- (void)setBullentTrainQueryViewFrame
{
    self.bulletTrainQuery = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bulletTrainQuery.frame = CGRectMake(trainQuery.frame.origin.x + trainQuery.frame.size.width + 10, trainQuery.frame.origin.y, trainQuery.frame.size.width, (appFrame.size.height - (topShowView.frame.origin.y + topShowView.frame.size.height + 10))*2/5 - 10);
    [self.bulletTrainQuery setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"2" ofType:@"png"]] forState:UIControlStateNormal];
    [self.bulletTrainQuery setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"home_bullettrain" ofType:@"png"]] forState:UIControlStateNormal];
    [self.bulletTrainQuery addTarget:self action:@selector(pressBulletTrainQueryButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bulletTrainQuery];
}

- (void)setOrderCenterViewFrame
{
    self.orderCenter = [UIButton buttonWithType:UIButtonTypeCustom];
    self.orderCenter.frame = CGRectMake(bulletTrainQuery.frame.origin.x, bulletTrainQuery.frame.origin.y + bulletTrainQuery.frame.size.height + 10, bulletTrainQuery.frame.size.width, (appFrame.size.height - (topShowView.frame.origin.y + topShowView.frame.size.height + 10))*3/5 - 10);
    [self.orderCenter setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"png"]] forState:UIControlStateNormal];
    [self.orderCenter setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"home_ordercenter" ofType:@"png"]] forState:UIControlStateNormal];
    [self.orderCenter addTarget:self action:@selector(pressOrderCenterButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.orderCenter];
}

#pragma mark - button method
- (void)pressTrainQueryButton:(UIButton*)sender
{
    TrainQueryViewController *trainQueryView = [[[TrainQueryViewController alloc]initWithTrainType:TrainQueryCommon]autorelease];
    [[Model shareModel] pushView:trainQueryView options:ViewTrasitionEffectMoveLeft completion:^{
        [[Model shareModel].viewControllers addObject:trainQueryView];
    }];
}

- (void)pressBulletTrainQueryButton:(UIButton*)sender
{
    TrainQueryViewController *trainQueryView = [[[TrainQueryViewController alloc]initWithTrainType:TrainQueryHighSpeed]autorelease];
    [[Model shareModel] pushView:trainQueryView options:ViewTrasitionEffectMoveLeft completion:^{
        [[Model shareModel].viewControllers addObject:trainQueryView];
    }];
}

- (void)pressAboutButton:(UIButton*)sender
{
    
    AboutViewController *aboutView = [[[AboutViewController alloc]init]autorelease];
    [[Model shareModel] pushView:aboutView options:ViewTrasitionEffectMoveLeft completion:^{
        [[Model shareModel].viewControllers addObject:aboutView];
    }];
    /*WapAlipayViewController *wapAlipayView = [[[WapAlipayViewController alloc]init]autorelease];
    [[Model shareModel] pushView:wapAlipayView options:ViewTrasitionEffectMoveLeft completion:^{
        [[Model shareModel].viewControllers addObject:wapAlipayView];
        [wapAlipayView createDirect];
    }];*/
}

- (void)pressOrderCenterButton:(UIButton*)sender
{
    
    if (![UserDefaults shareUserDefault].userId) {
        RegisterAndLogInViewController *registerAndLog = [[[RegisterAndLogInViewController alloc]init]autorelease];
        [[Model shareModel] pushView:registerAndLog options:ViewTrasitionEffectMoveLeft completion:^{
            [[Model shareModel].viewControllers addObject:registerAndLog];
        }];
    }else{
        OrderCenterViewController *orderCenterView = [[[OrderCenterViewController alloc]init]autorelease];
        [[Model shareModel] pushView:orderCenterView options:ViewTrasitionEffectMoveLeft completion:^{
            [[Model shareModel].viewControllers addObject:orderCenterView];
            [orderCenterView threeMonthListShow];
        }];
    }
}

#pragma mark - delegate method
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
