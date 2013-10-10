//
//  OrderCenterViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-19.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadingMoreTableFooterView.h"

#define             pageSize            15

typedef NS_OPTIONS(NSInteger, OrderDate){
    OrderThreeMonthAgo,
    OrderThreeMonth
};

typedef NS_OPTIONS(NSInteger, OrderStatus){
    OrderWaitPay,
    OrderProcess,
    OrderFinished
};

@interface OrderCenterViewController : BaseUIViewController<UITabBarDelegate,UITableViewDataSource,UITableViewDelegate,LoadingMoreTableFooterDelegate>

@property (retain, nonatomic) EGORefreshTableHeaderView     *refreshHeaderView;
@property (retain, nonatomic) LoadingMoreTableFooterView    *loadMoreView;
@property (assign, nonatomic) BOOL                          hasMoreData;
@property (assign, nonatomic) NSInteger                     pageNO;
@property (retain, nonatomic) UITableView                   *theTableView;
@property (retain, nonatomic) NSMutableArray                *dataSource;
@property (retain, nonatomic) UITabBar                      *theTabBar;
@property (retain, nonatomic) UIButton                      *ThreeMonthAgo;
@property (retain, nonatomic) UIButton                      *ThreeMonth;
@property (assign, nonatomic) OrderDate                     orderDate;
@property (assign, nonatomic) OrderStatus                   orderStatus;
@property (retain, nonatomic) UILabel                       *logUserName;
@property (retain, nonatomic) UISegmentedControl            *segmentedControl;

- (void)threeMonthAgoListShow;
- (void)threeMonthListShow;

@end
