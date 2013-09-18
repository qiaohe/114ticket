//
//  DatePickerViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-19.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"
#import "TdCalendarView.h"

@protocol DatePickerViewDelegate <NSObject>

@optional
- (void)didSelectDate:(NSString*)date;

@end

@interface DatePickerViewController : BaseUIViewController<CalendarViewDelegate>

@property (assign, nonatomic) id <DatePickerViewDelegate> delegate;

@end
