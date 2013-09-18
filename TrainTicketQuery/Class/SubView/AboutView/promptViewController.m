//
//  promptViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-9-11.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "promptViewController.h"
#import "Model.h"

@interface promptViewController ()

@end

@implementation promptViewController
@synthesize webView;
@synthesize titleLabel;
@synthesize type;

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
    [webView         release];
    [titleLabel      release];
    [super           dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (id)initWithPromptType:(promptType)_type
{
    if (self = [super init]) {
        self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
        [self initView];
        self.type = _type;
        //[self getPrompt];
    }
    return self;
}

- (void)getPrompt
{
    [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 40.0f - 1.5f, selfViewFrame.size.width, selfViewFrame.size.height + 1.5f) belowView:nil enabled:NO];
    NSString *urlString = nil;
    if (self.type == ShowUserProtocol) {
        [titleLabel setText:@"用户协议"];
        urlString = [NSString stringWithFormat:@"%@/getServiceAgreement",TrainOrderServiceURL];
    }else if (self.type == ShowCommonQuestion){
        [titleLabel setText:@"常见问题"];
        urlString = [NSString stringWithFormat:@"%@/getFaq",TrainOrderServiceURL];
    }
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    [webView loadRequest:request];
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
    [webView loadHTMLString:_string baseURL:nil];
}

- (void)requestError:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
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
    
    titleLabel = [self getLabelWithFrame:CGRectMake(80, 0, 160, 40) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] title:nil font:nil];
    [self.view addSubview:titleLabel];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateSelected];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(pressReturnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 40 - 1.5f, self.view.frame.size.width, self.view.frame.size.height - 40 + 1.5f)];
    [webView setDelegate:self];
    [webView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:webView];
}

- (void)pressReturnButton:(UIButton*)sender
{
    BaseUIViewController *prevView = [[Model shareModel].viewControllers objectAtIndex:([[Model shareModel].viewControllers indexOfObject:self] - 1)];
    [[Model shareModel] pushView:prevView options:ViewTrasitionEffectMoveRight completion:^{
        [[Model shareModel].viewControllers removeObject:self];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
