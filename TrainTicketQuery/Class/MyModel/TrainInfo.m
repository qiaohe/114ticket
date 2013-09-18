//
//  TrainInfo.m
//  TrainTicketQuery
//
//  Created by M J on 13-9-4.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "TrainInfo.h"

@implementation TrainInfo

@synthesize trainCode;
@synthesize beginStation;
@synthesize beginTime;
@synthesize endStation;
@synthesize endTime;
@synthesize elapsedTime;
@synthesize mile;
@synthesize trainInfoDetails;

- (void)dealloc
{
    [trainCode           release];
    [beginStation        release];
    [beginTime           release];
    [endStation          release];
    [endTime             release];
    [elapsedTime         release];
    [trainInfoDetails    release];
    [super               dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.trainInfoDetails = [NSMutableArray array];
    }
    return self;
}

@end
