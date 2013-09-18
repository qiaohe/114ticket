//
//  TransitionController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-15.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"

@interface TransitionController : BaseUIViewController

@property (copy,   nonatomic) void (^completionHandler) (void);
@property (nonatomic, retain) UIView                 *containerView;
@property (nonatomic, retain) UIViewController       *viewControl;
@property (nonatomic, retain) UIButton               *tipView;

- (id)initWithViewController:(BaseUIViewController *)viewController;
- (void)transitionToViewController:(UIViewController *)aViewController
                       withOptions:(ViewTrasitionEffect)options
                        completion:(void (^) (void))_completionHandler;

- (void)displayTip:(NSString *)tip modal:(BOOL)modal;

@end
