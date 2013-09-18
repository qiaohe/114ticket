//
//  QueryHistory.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-13.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "QueryHistory.h"
#import "Utils.h"

@implementation QueryHistory

@synthesize startCity;
@synthesize endCity;
@synthesize startDate;
@synthesize trainCode;
@synthesize type;

- (void)dealloc
{
    [startCity release];
    [endCity   release];
    [startDate release];
    [trainCode release];
    [super     dealloc];
}

- (id)initWithStartCity:(NSString*)_start
                endCity:(NSString*)_end
              startDate:(NSString*)_date
              trainCode:(NSString*)_code
              queryType:(QueryTrainType)_type
{
    if (self = [super init]) {
        self.startCity = _start;
        self.endCity   = _end;
        self.startDate = _date;
        self.trainCode = _code;
        self.type      = _type;
    }
    return self;
}

- (id)initWithPlistData:(NSDictionary*)PData
{
    if (self = [super init]) {
        startCity = [[PData objectForKey:@"startCity"] retain];
        endCity   = [[PData objectForKey:@"endCity"] retain];
        startDate = [[PData objectForKey:@"startDate"] retain];
        trainCode = [[PData objectForKey:@"trainCode"] retain];
        type      = [[PData objectForKey:@"type"]intValue];
    }
    return self;
}

- (NSDictionary*)getData
{
    NSString *queryType = [NSString stringWithFormat:@"%d",type];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [Utils NULLToEmpty:startCity],                             @"startCity",
                         [Utils NULLToEmpty:endCity],                               @"endCity",
                         [Utils NULLToEmpty:startDate],                             @"startDate",
                         [Utils NULLToEmpty:trainCode],                             @"trainCode",
                         [Utils NULLToEmpty:queryType],@"type",
                         nil];
    return dic;
}

- (id)copyWithZone:(NSZone *)zone
{
    QueryHistory *result = [[QueryHistory alloc]initWithStartCity:self.startCity endCity:endCity startDate:startDate trainCode:trainCode queryType:type];
    return result;
}

@end
