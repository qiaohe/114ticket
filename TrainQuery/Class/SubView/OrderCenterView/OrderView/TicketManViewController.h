//
//  TicketManViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-20.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"
#import "BirthdayChooseViewController.h"

#define         manBaseYValue      20.0f + 40.0f + 60.0f*2 - 12.0f

@protocol TicketManViewDelegate <NSObject>

@optional
- (void)resetViewFrame:(CGRect)frame withAnimationDurarion:(NSTimeInterval)duration;
- (PassengerInfo*)getSuperPassengerInfo;
- (void)superViewAddSubview:(UIView*)view;
- (void)reloadData;
- (void)pushToViewController:(BaseUIViewController*)viewController completion:(void (^)(void))completionhandler;
@end

@interface TicketManViewController : BaseUIViewController<UITextFieldDelegate,UIAlertViewDelegate,BirthdayChooseDelegate>

@property (assign, nonatomic) id <TicketManViewDelegate>delegate;
@property (retain, nonatomic) UIButton                  *reserveBtn;
@property (retain, nonatomic) UIButton                  *idCardType;
@property (retain, nonatomic) UITextField               *idCardNum;
@property (retain, nonatomic) UIButton                  *birthDay;
@property (retain, nonatomic) PassengerInfo             *passenger;
@property (retain, nonatomic) UIDatePicker              *datePicker;
@property (assign, nonatomic) PassengerInitType         addOrUpdate;

- (id)initWithPassenger:(PassengerInfo*)_passenger;
- (void)clearKeyboard;

@end
