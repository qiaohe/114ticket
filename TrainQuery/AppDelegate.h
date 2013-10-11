//
//  AppDelegate.h
//  TrainQuery
//
//  Created by M J on 13-9-30.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

typedef NS_OPTIONS(NSInteger, VerifyResult){
    VerifyError                 = 1,
    VerifySuccess
};

@interface AppDelegate : UIResponder <UIApplicationDelegate,ASIHTTPRequestDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
