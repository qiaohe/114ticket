//
//  ReturnTicketViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-22.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"

@interface ReturnTicketViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) UILabel           *orderCode;
@property (retain, nonatomic) UILabel           *totalPrice;
@property (retain, nonatomic) UILabel           *trainCodeAndRoute;
@property (retain, nonatomic) UILabel           *startDate;
@property (retain, nonatomic) UITableView       *theTableView;
@property (retain, nonatomic) NSMutableArray    *dataSource;

@end
