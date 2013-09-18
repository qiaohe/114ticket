//
//  OrderCenterViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-19.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"

typedef NS_OPTIONS(NSInteger, OrderDate){
    OrderThreeMonthAgo,
    OrderThreeMonth
};

typedef NS_OPTIONS(NSInteger, OrderStatus){
    OrderWaitPay,
    OrderProcess,
    OrderFinished
};

@interface OrderCenterViewController : BaseUIViewController<UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) UITableView    *theTableView;
@property (retain, nonatomic) NSMutableArray *dataSource;
@property (retain, nonatomic) UITabBar       *theTabBar;
@property (retain, nonatomic) UIButton       *ThreeMonthAgo;
@property (retain, nonatomic) UIButton       *ThreeMonth;
@property (assign, nonatomic) OrderDate      orderDate;
@property (assign, nonatomic) OrderStatus    orderStatus;

- (void)threeMonthAgoListShow;
- (void)threeMonthListShow;

@end
