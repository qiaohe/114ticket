//
//  TrainInfoDetail.h
//  TrainTicketQuery
//
//  Created by M J on 13-9-4.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainInfoDetail : NSObject

@property (retain, nonatomic)   NSString        *trainStation;              //站名
@property (assign, nonatomic)   NSInteger       zhanci;                     //站次
@property (retain, nonatomic)   NSString        *dzTime;                    //到站时间
@property (retain, nonatomic)   NSString        *fcTime;                    //发车时间
@property (retain, nonatomic)   NSString        *stayTime;                  //停留时间

@end
