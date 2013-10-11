//
//  DatePickerViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-19.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "DatePickerViewController.h"
#import "Model.h"
#import "Utils.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController

@synthesize delegate;

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
    self.delegate   =   nil;
    [super               dealloc];
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
    
    UILabel *titleLabel = [self getLabelWithFrame:CGRectMake(80, 0, 160, 40) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] title:@"日期选择" font:nil];
    [self.view addSubview:titleLabel];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateSelected];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(pressReturnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    
    TdCalendarView *tdView = [[TdCalendarView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height)];
    [tdView setBackgroundColor:[UIColor clearColor]];
    [tdView setCalendarViewDelegate:self];
    [self.view addSubview:tdView];
}

- (void) selectDateChanged:(CFGregorianDate) selectDate
{
    NSString *_dateString = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)selectDate.year,(long)selectDate.month,(long)selectDate.day];
    NSDate *selectedDate    = [Utils dateWithString:_dateString withFormat:@"yyyy-MM-dd"];
    NSDate *currentDate   = [NSDate date];
    if ([selectedDate timeIntervalSince1970] < [currentDate timeIntervalSince1970]) {
        [[Model shareModel] showPromptBoxWithText:@"不能定今天以前的票" modal:NO];
        return;
    }else if ([selectedDate timeIntervalSince1970] - [currentDate timeIntervalSince1970] > 20 * 24 * 60 * 60){
        [[Model shareModel] showPromptBoxWithText:@"请选择20日以内的日期" modal:NO];
        return;
    }
    [self popViewControllerCompletion:^{
        if (self.delegate) {
            [self.delegate didSelectDate:_dateString];
        }
    }];
}

- (void) monthChanged:(CFGregorianDate) currentMonth viewLeftTop:(CGPoint)viewLeftTop height:(float)height
{
    
}

- (void) beforeMonthChange:(TdCalendarView*) calendarView willto:(CFGregorianDate) currentMonth
{
    
}

#pragma mark - other method

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
