//
//  PaymentTypeViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-22.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"

@interface PaymentTypeViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) UITableView               *theTableView;
@property (retain, nonatomic) NSMutableArray            *dataSource;

@end
