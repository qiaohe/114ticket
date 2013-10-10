//
//  BirthdayChooseViewController.h
//  TrainQuery
//
//  Created by M J on 13-10-10.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"

@protocol BirthdayChooseDelegate <NSObject>

@optional
- (void)setBirthdayWithText:(NSString*)text;

@end

@interface BirthdayChooseViewController : BaseUIViewController

@property (assign, nonatomic) id <BirthdayChooseDelegate> delegate;
@property (retain, nonatomic) UIDatePicker          *datePicker;

@end
