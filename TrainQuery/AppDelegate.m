//
//  AppDelegate.m
//  TrainQuery
//
//  Created by M J on 13-9-30.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "AppDelegate.h"
#import <sys/utsname.h>
#import "AlixPay.h"
#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "Model.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)isSingleTask{
	struct utsname name;
	uname(&name);
	float version = [[UIDevice currentDevice].systemVersion floatValue];//判定系统版本。
	if (version < 4.0 || strstr(name.machine, "iPod1,1") != 0 || strstr(name.machine, "iPod2,1") != 0) {
		return YES;
	}
	else {
		return NO;
	}
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    HomeViewController *viewController = [[[HomeViewController alloc]init]autorelease];
    UINavigationController *navigationController = [[[UINavigationController alloc]initWithRootViewController:viewController]autorelease];
    navigationController.navigationBarHidden = YES;
    self.window.rootViewController = navigationController;
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if ([self isSingleTask]) {
		NSURL *url = [launchOptions objectForKey:@"UIApplicationLaunchOptionsURLKey"];
		
		if (nil != url) {
			[self parseURL:url application:application];
		}
	}
    
    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	
	[self parseURL:url application:application];
	return YES;
}

- (void)parseURL:(NSURL *)url application:(UIApplication *)application {
    AlixPay *alixpay = [AlixPay shared];
    AlixPayResult *result = [alixpay handleOpenURL:url];
    
    if (result) {
        //是否支付成功
        if (9000 == result.statusCode) {
            NSString *urlString = @"http://www.114piaowu.com:8043/axis2/RSACallBack";
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    result.resultString,            @"content",
                                    result.signString,              @"sign",
                                    nil];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      result,                       @"userInfo",
                                      nil];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
            for (NSString *key in params.allKeys) {
                [request setPostValue:[params objectForKey:key] forKey:key];
            }
            [request setUserInfo:userInfo];
            [request setDelegate:self];
            [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 40.0f - 1.5f, [Model shareModel].mainView.view.frame.size.width, [Model shareModel].mainView.view.frame.size.height - 40.0f + 1.5f) belowView:nil enabled:NO];
            [request startAsynchronous];
        }
        //如果支付失败,可以通过result.statusCode查询错误码
        else {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:result.statusMessage
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
