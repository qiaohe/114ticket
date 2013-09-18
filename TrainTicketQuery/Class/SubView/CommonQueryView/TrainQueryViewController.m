//
//  TrainQueryViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-12.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "TrainQueryViewController.h"
#import "StationQueryViewController.h"
#import "TrainNumQueryViewController.h"
#import "Model.h"

@interface TrainQueryViewController ()

@end

@implementation TrainQueryViewController

@synthesize stationQueryView;
@synthesize trainNumQueryView;
@synthesize viewControllers;
@synthesize trainType;

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
    [stationQueryView   release];
    [trainNumQueryView  release];
    [viewControllers    release];
    [super              dealloc];
}

- (id)initWithTrainType:(TrainQueryType)_trainType
{
    if (self = [super init]) {
        trainType = _trainType;
        [self initView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
    
    //[self initView];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - view init
- (void)initView
{
    stationQueryView  = [[StationQueryViewController alloc]init];
    stationQueryView.trainType = trainType;
    trainNumQueryView = [[TrainNumQueryViewController alloc]init];
    trainNumQueryView.trainType = trainType;
    //[self.view addSubview:stationQueryView.view];
    //[self.view addSubview:trainNumQueryView.view];
    //self.viewControllers = [NSMutableArray arrayWithObjects:stationQueryView,trainNumQueryView, nil];
    
    UIImageView *backGroundImage    = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, appFrame.size.width, appFrame.size.height)]autorelease];
    [backGroundImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"backgroundimage" ofType:@"png"]]];
    [self.view addSubview:backGroundImage];
    
    UIImageView *topBackGroundImage = [[[UIImageView alloc]initWithFrame:CGRectMake(0, -1, appFrame.size.width, 40 + 3)]autorelease];
    [topBackGroundImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"topbar_image" ofType:@"png"]]];
    [self.view addSubview:topBackGroundImage];
    
    UIImageView *subJoinTopImage = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 40, appFrame.size.width, 40)]autorelease];
    [subJoinTopImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"subjointopbar_image" ofType:@"png"]]];
    [self.view addSubview:subJoinTopImage];
    
    [self setTopBarElement];
    [self setJoinBarElement];
}

- (void)setTopBarElement
{
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateSelected];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(pressReturnBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    
    UILabel *titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(80, 0, 160, 40)]autorelease];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor       = [UIColor whiteColor];
    titleLabel.textAlignment   = NSTextAlignmentCenter;
    [titleLabel setText:trainType == TrainQueryCommon?@"列车查询":@"高铁查询"];
    [self.view addSubview:titleLabel];
}

- (void)setJoinBarElement
{
    UIButton *stationQueryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stationQueryButton.frame = CGRectMake(40.0f, 40.0f + 3.5f, 120.0f, 40.0f - 3.0f);
    //[stationQueryButton setTitle:@"站站查询" forState:UIControlStateNormal];
    //[stationQueryButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    //[stationQueryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [stationQueryButton setBackgroundImage:imageNameAndType(@"stationquery_normal", @"png") forState:UIControlStateNormal];
    [stationQueryButton setBackgroundImage:imageNameAndType(@"stationquery_press", @"png") forState:UIControlStateDisabled];
    [stationQueryButton setBackgroundImage:imageNameAndType(@"stationquery_press", @"png") forState:UIControlStateHighlighted];
    stationQueryButton.tag = 200;
    [stationQueryButton addTarget:self action:@selector(pressQueryBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stationQueryButton];
    
    UIButton *trainNumQueryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    trainNumQueryButton.frame = CGRectMake(stationQueryButton.frame.origin.x + stationQueryButton.frame.size.width, stationQueryButton.frame.origin.y, stationQueryButton.frame.size.width, stationQueryButton.frame.size.height);
    [trainNumQueryButton setBackgroundImage:imageNameAndType(@"trainnumquery_normal", @"png") forState:UIControlStateNormal];
    [trainNumQueryButton setBackgroundImage:imageNameAndType(@"trainnumquery_press", @"png") forState:UIControlStateDisabled];
    [trainNumQueryButton setBackgroundImage:imageNameAndType(@"trainnumquery_press", @"png") forState:UIControlStateHighlighted];
    trainNumQueryButton.tag = 201;
    [trainNumQueryButton addTarget:self action:@selector(pressQueryBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:trainNumQueryButton];
    
    [self pressQueryBtn:stationQueryButton];
}

#pragma mark - method achieve
- (void)pressReturnBtn:(UIButton*)sender
{
    BaseUIViewController *prevView = [[Model shareModel].viewControllers objectAtIndex:([[Model shareModel].viewControllers indexOfObject:self] - 1)];
    [[Model shareModel]pushView:prevView options:ViewTrasitionEffectMoveRight completion:^{
        [[Model shareModel].viewControllers removeObject:self];
    }];
}

- (void)pressQueryBtn:(UIButton*)sender
{
    [self setButtonStatus:sender];
    [self setSubviewShowWithSender:sender];
}

- (void)setButtonStatus:(UIButton*)sender
{
    sender.enabled = NO;
    NSInteger customTag = sender.tag == 200?201:200;
    UIButton *prevBtn   = (UIButton*)[self.view viewWithTag:customTag];
    prevBtn.selected = NO;
    prevBtn.enabled  = YES;
}

- (void)setSubviewShowWithSender:(UIButton*)sender
{
    if (sender.tag == 200) {
        if (!stationQueryView.view.superview) {
            [self.view addSubview:stationQueryView.view];
        }else
            [self.view bringSubviewToFront:stationQueryView.view];
    }else{
        if (!trainNumQueryView.view.superview) {
            [self.view addSubview:trainNumQueryView.view];
        }else
            [self.view bringSubviewToFront:trainNumQueryView.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
