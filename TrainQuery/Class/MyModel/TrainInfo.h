//
//  TrainInfo.h
//  TrainTicketQuery
//
//  Created by M J on 13-9-4.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainInfo : NSObject

@property (retain, nonatomic)   NSString        *trainCode;                 //车次
@property (retain, nonatomic)   NSString        *beginStation;              //始发车站
@property (retain, nonatomic)   NSString        *beginTime;                 //始发时间
@property (retain, nonatomic)   NSString        *endStation;                //终点车站
@property (retain, nonatomic)   NSString        *endTime;                   //终点事件
@property (retain, nonatomic)   NSString        *elapsedTime;               //耗时
@property (assign, nonatomic)   NSInteger       *mile;                      //里程
@property (retain, nonatomic)   NSMutableArray  *trainInfoDetails;          

@end
