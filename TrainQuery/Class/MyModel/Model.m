//
//  Model.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-14.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "Model.h"
#import "AppDelegate.h"
#import "PlistProxy.h"
#import "QueryHistory.h"

static Model *shareModel;


@implementation Model

@synthesize indicatorView;
@synthesize activityIndicatorView;
@synthesize viewControllers;
@synthesize mainView;
@synthesize allQueryHistory;
@synthesize trainCodeQueryHistory;
@synthesize viewData;
@synthesize tipView;

+(Model *)shareModel
{
    @synchronized(self){
        if (shareModel == nil) {
            shareModel = [[Model alloc]init];
        }
    }
    return shareModel;
}

- (void)dealloc
{
    [viewControllers        release];
    [mainView               release];
    [indicatorView          release];
    [activityIndicatorView  release];
    [allQueryHistory        release];
    [trainCodeQueryHistory  release];
    [viewData               release];
    [tipView                release];
    [super                  dealloc];
}

- (id)init
{
    if (self = [super init]) {
        self.viewControllers = [NSMutableArray array];
        self.allQueryHistory = [NSMutableArray array];
        self.trainCodeQueryHistory = [NSMutableArray array];
        self.viewData        = [NSMutableArray array];
        [self updateAllQueryHistory];
    }
    return self;
}

- (void)updateAllQueryHistory
{
    if (!allQueryHistory) {
        self.allQueryHistory = [NSMutableArray array];
    }
    [allQueryHistory removeAllObjects];
    NSArray *array1 = [[PlistProxy sharePlistProxy] getAllQueryHistory];
    for (NSDictionary *e in array1) {
        QueryHistory *history = [[[QueryHistory alloc]initWithPlistData:e]autorelease];
        [allQueryHistory addObject:history];
    }
    
    if (!trainCodeQueryHistory) {
        self.trainCodeQueryHistory = [NSMutableArray array];
    }
    [trainCodeQueryHistory removeAllObjects];
    NSArray *array2 = [[PlistProxy sharePlistProxy] getTrainCodeQueryHistory];
    for (NSDictionary *e in array2) {
        QueryHistory *history = [[[QueryHistory alloc]initWithPlistData:e]autorelease];
        [trainCodeQueryHistory addObject:history];
    }
}

- (UIColor *)getColor:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (BaseUIViewController *)getMainViewController
{
    return self.mainView;
}

- (void)showActivityIndicator:(BOOL)show frame:(CGRect)frame belowView:(UIView*)view enabled:(BOOL)enabled
{
    CGRect makeFrame = CGRectMake(frame.origin.x, frame.origin.y + 20, frame.size.width, frame.size.height);
    [[Model shareModel]showCoverView:show frame:makeFrame belowView:view enabled:enabled];
    indicatorView.center = CGPointMake(makeFrame.size.width/2, makeFrame.size.height/2);
    if (show) {
        [indicatorView startAnimating];
    }else{
        [indicatorView stopAnimating];
    }
}

- (void)showCoverView:(BOOL)show frame:(CGRect)frame belowView:(UIView*)view enabled:(BOOL)enabled
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *viewController = appDelegate.window.rootViewController;
    
    if (!activityIndicatorView) {
        self.activityIndicatorView = [UIButton buttonWithType:UIButtonTypeCustom];
        activityIndicatorView.backgroundColor = [UIColor blackColor];
        activityIndicatorView.alpha = 0.4;
        
        indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicatorView.hidesWhenStopped = YES;
        [activityIndicatorView addSubview:indicatorView];
    }
    if (!show) {
        [activityIndicatorView removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    }
    activityIndicatorView.frame = frame;
    activityIndicatorView.enabled = enabled;
    if (show) {
        if (activityIndicatorView.superview) {
            [activityIndicatorView removeFromSuperview];
        }
        if (view) {
            [viewController.view insertSubview:activityIndicatorView aboveSubview:view];
        }else
            [viewController.view addSubview:activityIndicatorView];
        viewController.view.userInteractionEnabled = enabled;
    }else{
        if (activityIndicatorView.superview) {
            [activityIndicatorView removeFromSuperview];
        }
        viewController.view.userInteractionEnabled = enabled;
    }
}

- (void)showPromptBoxWithText:(NSString*)text modal:(BOOL)modal
{
    [self displayTip:text modal:modal];
}

- (void)displayTip:(NSString *)tip modal:(BOOL)modal
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *viewController = appDelegate.window.rootViewController;
        
    if (!tipView) {
        self.tipView = [UIButton buttonWithType:UIButtonTypeCustom];
        tipView.frame = CGRectMake(0, 0, appFrame.size.width*2/3, 65);
        tipView.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 20);
        //[tipView setBackgroundImage:imageNameAndType(@"alert_background@2x", @"png") forState:UIControlStateDisabled];
        tipView.enabled = NO;
        [tipView.titleLabel setNumberOfLines:0];
        [tipView.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [tipView.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
        /*
        tipView.titleLabel.adjustsFontSizeToFitWidth = YES;
        tipView.titleLabel.adjustsLetterSpacingToFitWidth = YES;
        tipView.titleLabel.baselineAdjustment = UIBaselineAdjustmentNone;
        tipView.titleLabel.minimumScaleFactor = 0.5;*/
    }
    
    CGSize size = [tip sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:13] constrainedToSize:CGSizeMake(tipView.frame.size.width - 20, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = size.height + 35 >= 65?size.height + 35:65;
    NSLog(@"size height = %f",size.height);
    tipView.frame = CGRectMake(0, 0, tipView.frame.size.width, height);
    tipView.center = CGPointMake(appFrame.size.width/2, appFrame.size.height/2);
    
    UIImage *image = imageNameAndType(@"alert_background@2x", @"png");
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    [tipView setBackgroundImage:image forState:UIControlStateDisabled];
    
    [tipView setTitle:tip forState:UIControlStateNormal];
    
    if (!tipView.superview) {
        [viewController.view addSubview:tipView];
        tipView.alpha = 0.0f;
        [UIView animateWithDuration:0.3f
                         animations:^{
                             tipView.alpha = 1.0f;
                         }
                         completion:^(BOOL finished){
                             [self performSelector:@selector(tipHide:) withObject:[NSNumber numberWithBool:modal] afterDelay:1.5f];
                         }];
    }
}

- (void)tipHide:(NSNumber*)number
{
    [UIView animateWithDuration:0.5f
                     animations:^{
                         tipView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         if (tipView.superview) {
                             [tipView removeFromSuperview];
                         }
                     }];
}


@end
