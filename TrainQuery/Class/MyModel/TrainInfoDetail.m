//
//  TrainInfoDetail.m
//  TrainTicketQuery
//
//  Created by M J on 13-9-4.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "TrainInfoDetail.h"

@implementation TrainInfoDetail

@synthesize trainStation;
@synthesize zhanci;
@synthesize dzTime;
@synthesize fcTime;
@synthesize stayTime;

- (void)dealloc
{
    [trainStation        release];
    [dzTime              release];
    [fcTime              release];
    [stayTime            release];
    [super               dealloc];
}

@end
