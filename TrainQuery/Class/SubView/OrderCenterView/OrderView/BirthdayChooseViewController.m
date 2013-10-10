//
//  BirthdayChooseViewController.m
//  TrainQuery
//
//  Created by M J on 13-10-10.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BirthdayChooseViewController.h"
#import "Utils.h"
#import "Model.h"

@interface BirthdayChooseViewController ()

@end

@implementation BirthdayChooseViewController

@synthesize delegate;
@synthesize datePicker;

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
    self.delegate        = nil;
    [datePicker          release];
    [super               dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
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

- (void)initView
{
    UIImageView *backImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
    [backImageView setImage:imageNameAndType(@"backgroundimage", @"png")];
    [self.view addSubview:backImageView];
    
    UIImageView *topImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, -1, self.view.frame.size.width, 40 + 1)]autorelease];
    [topImageView setImage:imageNameAndType(@"topbar_image", @"png")];
    [self.view addSubview:topImageView];
    
    UILabel *titleLabel = [self getLabelWithFrame:CGRectMake(80, 0, 160, 40) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] title:@"选择出生日期" font:nil];
    [self.view addSubview:titleLabel];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateSelected];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(pressReturnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    
}

- (void)setDetailViewFrame
{
    datePicker = [[UIDatePicker alloc]init];
    [datePicker setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"]autorelease]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setFrame:CGRectMake(10, 40 + 25, self.view.frame.size.width - 20, 100)];
    [self.view addSubview:datePicker];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:@"确定" forState:UIControlStateNormal];
    [saveButton setBackgroundImage:imageNameAndType(@"search_normal", @"png") forState:UIControlStateNormal];
    [saveButton setBackgroundImage:imageNameAndType(@"search_press", @"png") forState:UIControlStateHighlighted];
    [saveButton setBackgroundImage:imageNameAndType(@"search_press", @"png") forState:UIControlStateSelected];
    [saveButton setBackgroundColor:[UIColor clearColor]];
    [saveButton setFrame:CGRectMake(0, 0, self.view.frame.size.width*2/3, 45)];
    [saveButton setCenter:CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height + datePicker.frame.origin.y + datePicker.frame.size.height)/2 )];
    [saveButton addTarget:self action:@selector(pressSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
}

- (void)pressSaveButton:(UIButton*)sender
{
    NSDate *birthday = datePicker.date;
    NSDate *currentDate = [NSDate date];
    if ([birthday timeIntervalSince1970] > [currentDate timeIntervalSince1970]) {
        [[Model shareModel] showPromptBoxWithText:@"出生日期不能在今天以后" modal:NO];
        return;
    }
    
    [self.delegate setBirthdayWithText:[Utils stringWithDate:datePicker.date withFormat:@"yyyy-MM-dd"]];
    [self popViewControllerCompletion:nil];
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
