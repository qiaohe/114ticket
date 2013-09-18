//
//  TrainNumQueryViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-13.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"
#import "TrainQueryViewController.h"
#import "DatePickerViewController.h"

@interface TrainNumQueryViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,DatePickerViewDelegate>

@property (retain, nonatomic) UITextField    *trainCode;
@property (retain, nonatomic) UITextField    *startDate;
@property (retain, nonatomic) UIButton       *chooseStartDate;
@property (retain, nonatomic) UIButton       *searchButton;
@property (retain, nonatomic) NSMutableArray *queryHistoryArray;
@property (retain, nonatomic) UITableView    *theTableView;
@property (assign, nonatomic) TrainQueryType trainType;

@end
