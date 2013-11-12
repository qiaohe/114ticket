//
//  RegisterAndLogInViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-17.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"

#define         baseYValue      40.0f

@protocol RegisterAndLogInViewDelegate <NSObject>

@optional
- (void)pushToViewController:(BaseUIViewController*)viewController completion:(void (^) (void))_completionhandler;

@end

@interface RegisterAndLogInViewController : BaseUIViewController<NSURLConnectionDataDelegate,NSURLConnectionDelegate>

@property (assign, nonatomic) id <RegisterAndLogInViewDelegate> delegate;
@property (retain, nonatomic) UITextField       *userName;
@property (retain, nonatomic) UITextField       *passWord;
@property (retain, nonatomic) NSMutableString   *performResult;
@property (retain, nonatomic) TrainOrder        *trainOrder;
@property (retain, nonatomic) TrainCodeAndPrice *codeAndPrice;
@property (retain, nonatomic) NSMutableData     *responseData;

@property (retain, nonatomic) UIButton          *tipView;

- (id)initWithObject:(id)object;

@end
