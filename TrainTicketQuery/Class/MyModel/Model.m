//
//  Model.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-14.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "Model.h"
#import "AppDelegate.h"
#import "TransitionController.h"
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
    [super                  dealloc];
}

- (id)init
{
    if (self = [super init]) {
        self.viewControllers = [NSMutableArray array];
        self.allQueryHistory = [NSMutableArray array];
        self.trainCodeQueryHistory = [NSMutableArray array];
        [self updateAllQueryHistory];
    }
    return self;
}

- (void)pushView:(BaseUIViewController*)viewController options:(ViewTrasitionEffect)_options completion:(void (^) (void))_completion
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.transitionController transitionToViewController:viewController
                                                     withOptions:_options
                                                      completion:_completion];
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
    [[Model shareModel]showCoverView:show frame:frame belowView:view enabled:enabled];
    indicatorView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    if (show) {
        [indicatorView startAnimating];
    }else{
        [indicatorView stopAnimating];
    }
}

- (void)showCoverView:(BOOL)show frame:(CGRect)frame belowView:(UIView*)view enabled:(BOOL)enabled
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
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
            [appDelegate.transitionController.viewControl.view insertSubview:activityIndicatorView aboveSubview:view];
        }else
            [appDelegate.transitionController.viewControl.view addSubview:activityIndicatorView];
        appDelegate.transitionController.view.userInteractionEnabled = enabled;
    }else{
        if (activityIndicatorView.superview) {
            [activityIndicatorView removeFromSuperview];
        }
        appDelegate.transitionController.view.userInteractionEnabled = enabled;
    }
}

- (void)showPromptBoxWithText:(NSString*)text modal:(BOOL)modal
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.transitionController displayTip:text modal:modal];
}

@end
