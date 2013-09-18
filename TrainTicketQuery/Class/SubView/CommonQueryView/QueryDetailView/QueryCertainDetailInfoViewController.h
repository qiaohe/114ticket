//
//  QueryCertainDetailInfoViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-17.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"
#import "TrainQueryViewController.h"

@interface TrainStationTimetable : NSObject

@property (retain, nonatomic) NSString          *dzTime;
@property (retain, nonatomic) NSString          *fcTime;
@property (retain, nonatomic) NSString          *stayTime;
@property (retain, nonatomic) NSString          *trainStation;
@property (assign, nonatomic) NSInteger         zhanci;

+ (NSMutableArray*)getDataSourceWithData:(NSArray*)data;

@end

@interface QueryCertainDetailInfoViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) UITableView    *theTableView;
@property (retain, nonatomic) NSMutableArray *dataSource;
@property (copy,   nonatomic) QueryHistory   *history;
@property (assign, nonatomic) TrainQueryType queryType;
@property (retain, nonatomic) UILabel        *distanceLabel;
@property (retain, nonatomic) UILabel        *costTimeLabel;
@property (retain, nonatomic) UILabel        *startCityLabel;
@property (retain, nonatomic) UILabel        *endCityLabel;
@property (retain, nonatomic) UILabel        *trainCodeLabel;
@property (retain, nonatomic) UILabel        *startDateLabel;
@property (retain, nonatomic) UILabel        *endDateLabel;

- (void)requestTrainDataWithType:(TrainQueryType)_type;
- (void)getTrainCodeAndPrice;

@end
