//
//  TrainNumQueryViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-13.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"
#import "DatePickerViewController.h"

@protocol TrainNumQueryViewDelegate <NSObject>

@optional
- (void)pushToViewController:(BaseUIViewController*)viewController completion:(void (^) (void))_completionhandler;

@end

@interface TrainNumQueryViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,DatePickerViewDelegate>

@property (retain, nonatomic) id <TrainNumQueryViewDelegate> delegate;
@property (retain, nonatomic) UITextField    *trainCode;
@property (retain, nonatomic) UITextField    *startDate;
@property (retain, nonatomic) UIButton       *chooseStartDate;
@property (retain, nonatomic) UIButton       *searchButton;
@property (retain, nonatomic) NSMutableArray *queryHistoryArray;
@property (retain, nonatomic) UITableView    *theTableView;
@property (assign, nonatomic) TrainQueryType trainType;

@end
