//
//  Model.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-14.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseUIViewController.h"

@interface Model : NSObject

+ (Model*)shareModel;

@property (retain, nonatomic) UIActivityIndicatorView *indicatorView;
@property (retain, nonatomic) UIButton                *activityIndicatorView;
@property (retain, nonatomic) NSMutableArray          *viewControllers;
@property (retain, nonatomic) BaseUIViewController    *mainView;
@property (retain, nonatomic) NSMutableArray          *allQueryHistory;
@property (retain, nonatomic) NSMutableArray          *trainCodeQueryHistory;

- (void)pushView:(BaseUIViewController*)viewController options:(ViewTrasitionEffect)_options completion:(void (^) (void))_completion;

- (BaseUIViewController*)getMainViewController;
- (UIColor *)getColor:(NSString *)stringToConvert;

- (void)showActivityIndicator:(BOOL)show frame:(CGRect)frame belowView:(UIView*)view  enabled:(BOOL)enabled;
- (void)showCoverView:(BOOL)show frame:(CGRect)frame belowView:(UIView*)view  enabled:(BOOL)enabled;

- (void)showPromptBoxWithText:(NSString*)text modal:(BOOL)modal;

@end
