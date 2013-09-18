//
//  TransitionController.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-15.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "TransitionController.h"
#import "Model.h"
#import "AppDelegate.h"

@interface TransitionController ()

@end

@implementation TransitionController

@synthesize completionHandler;
@synthesize containerView;
@synthesize viewControl;
@synthesize tipView;

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
    if (self.completionHandler) {
        [completionHandler release];
    }
    [containerView    release];
    [viewControl   release];
    if (tipView) {
        [tipView       release];
    }
    [super             dealloc];
}

- (id)initWithViewController:(BaseUIViewController *)_viewController
{
    if (self = [super init]) {
        [Model shareModel].mainView = _viewController;
        [[Model shareModel].viewControllers addObject:_viewController];
        viewControl = [_viewController retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    containerView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, appFrame.size.width, appFrame.size.height)]autorelease];
    [self.view addSubview:containerView];
    
    [containerView addSubview:viewControl.view];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload {
    containerView = nil;
    [super viewDidUnload];
}

- (void)transitionToViewController:(UIViewController *)aViewController
                       withOptions:(ViewTrasitionEffect)options
                        completion:(void (^) (void))_completionHandler
{
    if (options == ViewTrasitionEffectMoveLeft) {
        aViewController.view.frame = CGRectMake(aViewController.view.frame.size.width,  aViewController.view.frame.origin.y, aViewController.view.frame.size.width, aViewController.view.frame.size.height);
        [containerView addSubview:aViewController.view];
    }else if(options == ViewTrasitionEffectMoveRight){
        aViewController.view.frame = CGRectMake( - aViewController.view.frame.size.width,  aViewController.view.frame.origin.y, aViewController.view.frame.size.width, aViewController.view.frame.size.height);
        [containerView addSubview:aViewController.view];
    }
    [UIView transitionWithView:self.containerView
                      duration:0.5f
                       options:UIViewAnimationOptionCurveLinear
                    animations:^{
                        if (options == ViewTrasitionEffectMoveLeft) {
                            self.viewControl.view.frame = CGRectMake( - viewControl.view.frame.size.width, viewControl.view.frame.origin.y, viewControl.view.frame.size.width, viewControl.view.frame.size.height);
                            aViewController.view.frame = CGRectMake(0, aViewController.view.frame.origin.y, aViewController.view.frame.size.width, aViewController.view.frame.size.height);
                        }else if(options == ViewTrasitionEffectMoveRight) {
                            self.viewControl.view.frame = CGRectMake(self.viewControl.view.frame.size.width, viewControl.view.frame.origin.y, viewControl.view.frame.size.width, viewControl.view.frame.size.height);
                            aViewController.view.frame = CGRectMake(0, aViewController.view.frame.origin.y, aViewController.view.frame.size.width, aViewController.view.frame.size.height);
                        }
                    }completion:^(BOOL finished){
                        if (options == ViewTrasitionEffectMoveLeft || options == ViewTrasitionEffectMoveRight) {
                            //[[Model shareModel].viewControllers addObject:aViewController];
                            [self.viewControl.view removeFromSuperview];

                            //[[Model shareModel].viewControllers removeObject:self.viewController];
                        }
                        self.viewControl = aViewController;
                        if (_completionHandler) {
                            _completionHandler();
                            [_completionHandler  release];
                        }
                    }];
}

#pragma mark - show prompt
- (void)displayTip:(NSString *)tip modal:(BOOL)modal
{
    if (!tipView) {
        self.tipView = [UIButton buttonWithType:UIButtonTypeCustom];
        tipView.frame = CGRectMake(0, 0, selfViewFrame.size.width*2/3, 65);
        tipView.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 20);
        tipView.center = self.viewControl.view.center;
        [tipView setBackgroundImage:imageNameAndType(@"alert_background@2x", @"png") forState:UIControlStateDisabled];
        tipView.enabled = NO;
        [tipView.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
        tipView.titleLabel.adjustsFontSizeToFitWidth = YES;
        tipView.titleLabel.adjustsLetterSpacingToFitWidth = YES;
        tipView.titleLabel.baselineAdjustment = UIBaselineAdjustmentNone;
        tipView.titleLabel.minimumScaleFactor = 0.7;

    }
    [tipView setTitle:tip forState:UIControlStateNormal];
    
    if (!tipView.superview) {
        [self.view addSubview:tipView];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
