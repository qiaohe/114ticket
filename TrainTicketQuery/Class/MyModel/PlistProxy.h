//
//  PlistProxy.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-19.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseUIViewController.h"

@interface PlistProxy : NSObject

+(PlistProxy*)sharePlistProxy;
@property (retain, nonatomic) NSString *allQueryHistoryPath;
@property (retain, nonatomic) NSString *trainCodeQueryHistroyPath;
@property (retain, nonatomic) NSString *sandPath;

- (NSMutableArray*)getAllQueryHistory;
- (NSMutableArray*)getTrainCodeQueryHistory;
- (void)updateQueryHistory;

@end
