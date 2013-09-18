//
//  StationQueryViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-12.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"
#import "CityPickerViewController.h"
#import "TrainQueryViewController.h"
#import "DatePickerViewController.h"

@interface StationQueryViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CityPickerViewDelegate,DatePickerViewDelegate>

@property (retain, nonatomic) UIImageView    *backGroundImage;
@property (retain, nonatomic) UITextField    *startCity;
@property (retain, nonatomic) UIButton       *chooseStartCity;
@property (retain, nonatomic) UITextField    *endCity;
@property (retain, nonatomic) UIButton       *chooseEndCity;
@property (retain, nonatomic) UITextField    *startDate;
@property (retain, nonatomic) UIButton       *chooseStartDate;
@property (retain, nonatomic) UIButton       *searchButton;
@property (retain, nonatomic) UITableView    *theTableView;
@property (retain, nonatomic) NSMutableArray *queryHistoryArray;
@property (assign, nonatomic) TrainQueryType trainType;

- (void)pressSearchBtn:(UIButton*)sender;

@end
