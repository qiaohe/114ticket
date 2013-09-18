//
//  InSure.m
//  TrainTicketQuery
//
//  Created by M J on 13-9-11.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "InSure.h"

@implementation InSure

@synthesize inSureType;
@synthesize inSureDetail;
@synthesize selected;

- (void)dealloc
{
    [inSureType          release];
    [inSureDetail        release];
    [super               dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        selected = NO;
    }
    return self;
}

+ (NSArray*)getInSureTypeListWithData:(NSDictionary*)data
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *key in data.allKeys) {
        InSure *inSure = [[[InSure alloc]init]autorelease];
        inSure.inSureType = key;
        inSure.inSureDetail = [data objectForKey:key];
        [array addObject:inSure];
    }
    return array;
}

@end
