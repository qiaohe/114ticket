//
//  QueryHistory.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-13.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseUIViewController.h"

@interface QueryHistory : NSObject<NSCopying>

@property (copy,   nonatomic) NSString *startCity;
@property (copy,   nonatomic) NSString *endCity;
@property (copy,   nonatomic) NSString *startDate;
@property (copy,   nonatomic) NSString *trainCode;
@property (assign, nonatomic) QueryTrainType type;

- (id)initWithStartCity:(NSString*)_start
                endCity:(NSString*)_end
              startDate:(NSString*)_date
              trainCode:(NSString*)_code
              queryType:(QueryTrainType)_type;
- (id)initWithPlistData:(NSDictionary*)PData;
- (NSDictionary*)getData;

@end
