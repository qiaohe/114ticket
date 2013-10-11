//
//  InsureDetailViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-9-11.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "InsureDetailViewController.h"
#import "Model.h"

@interface InsureDetailViewController ()

@end

@implementation InsureDetailViewController

@synthesize textView;

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
    [textView            release];
    [super               dealloc];
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

- (void)getInsureDescription
{
    NSString *urlString = [NSString stringWithFormat:@"%@/getInsureDesc",TrainOrderServiceURL];
     [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 40.0f - 1.50f, selfViewFrame.size.width, selfViewFrame.size.height - 40.0f + 1.50f) belowView:nil enabled:NO];
    [self sendRequestWithURL:urlString params:nil requestMethod:RequestGet userInfo:nil];
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
    NSArray *keys = [[dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *value = [NSMutableString string];
    for (int i = 0; i<[keys count]; i++) {
        NSString *key = [keys objectAtIndex:i];
        if (i != 0) {
            [value appendFormat:@"\n"];
        }
        [value appendFormat:@"%@:%@",key,[dic objectForKey:key]];
    }
    if (value.length) {
        [textView setText:value];
    }
}

- (void)requestError:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
    [[Model shareModel]showPromptBoxWithText:@"请求失败" modal:NO];
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
    
    UILabel *titleLabel = [self getLabelWithFrame:CGRectMake(80, 0, 160, 40) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] title:@"服务说明" font:nil];
    [self.view addSubview:titleLabel];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateSelected];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(pressReturnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(10, topImageView.frame.size.height, self.view.frame.size.width - 20, self.view.frame.size.height - topImageView.frame.size.height)];
    [textView setEditable:NO];
    [textView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:textView];
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
