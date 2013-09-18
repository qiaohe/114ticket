//
//  AppDelegate.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-20.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@class TransitionController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TransitionController *transitionController;

@end
