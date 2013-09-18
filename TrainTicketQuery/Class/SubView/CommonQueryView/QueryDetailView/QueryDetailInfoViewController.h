//
//  QueryDetailInfoViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-14.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"
#import "TrainQueryViewController.h"


@class QueryHistory;
@interface QueryDetailInfoViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) UIButton        *currentDate;
@property (retain, nonatomic) UITableView     *theTableView;
@property (retain, nonatomic) NSMutableArray  *dataSource;
@property (copy,   nonatomic) QueryHistory    *history;
@property (assign, nonatomic) TrainQueryType  queryType;
@property (retain, nonatomic) NSMutableString *dataString;
@property (retain, nonatomic) TrainOrder      *trainOrder;
@property (retain, nonatomic) NSString        *changeDate;
@property (retain, nonatomic) TrainCodeAndPrice *codeAndPrice;

- (void)requestTrainDataWithType:(TrainQueryType)_type;
- (id)initWithHistory:(QueryHistory*)_history;
@end
