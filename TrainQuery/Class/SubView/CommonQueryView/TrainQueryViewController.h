//
//  TrainQueryViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-12.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"
#import "StationQueryViewController.h"
#import "TrainNumQueryViewController.h"

@interface TrainQueryViewController : BaseUIViewController<StationQueryViewDelegate,TrainNumQueryViewDelegate>

@property (retain, nonatomic) StationQueryViewController  *stationQueryView;
@property (retain, nonatomic) TrainNumQueryViewController *trainNumQueryView;
@property (retain, nonatomic) NSMutableArray              *viewControllers;
@property (assign, nonatomic) TrainQueryType              trainType;

- (id)initWithTrainType:(TrainQueryType)_trainType;

@end
