//
//  ReturnTicketViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-22.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"

@interface ReturnTicketViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) TrainOrder        *trainOrder;
@property (retain, nonatomic) UITextField       *orderCode;
@property (retain, nonatomic) UITextField       *totalPrice;
@property (retain, nonatomic) UITextField       *trainCodeAndRoute;
@property (retain, nonatomic) UITextField       *startDate;
@property (retain, nonatomic) UITableView       *theTableView;
@property (retain, nonatomic) NSMutableArray    *dataSource;
@property (retain, nonatomic) NSMutableArray    *selectDataSource;

- (id)initWithTrainOrder:(TrainOrder*)_trainOrder;
- (void)getTrainOrderDetails;

@end
