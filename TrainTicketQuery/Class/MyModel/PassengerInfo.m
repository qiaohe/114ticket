//
//  PassengerInfo.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-19.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "PassengerInfo.h"
#import "Utils.h"

@implementation PassengerInfo

@synthesize name;
//@synthesize ticketType;
@synthesize type;
@synthesize mobile;
@synthesize certificateNumber;
@synthesize certificateType;
@synthesize birthDate;
@synthesize userId;
@synthesize passengerId;
/*
@synthesize papersType;
@synthesize papersNum;
@synthesize reserve;*/
@synthesize selected;

- (id)init
{
    if (self = [super init]) {
//        reserve = NO;
        selected = NO;
        certificateType = @"0";
        type            = 1;
    }
    return self;
}

- (id)initWithJSONData:(NSDictionary*)data
{
    self = [super init];
    if (self) {
//        reserve = NO;
        selected = NO;
        name               = [[data objectForKey:@"name"] retain];
        mobile             = [[data objectForKey:@"mobile"] retain];
        certificateType    = [[data objectForKey:@"certificateType"] retain];
        certificateNumber  = [[data objectForKey:@"certificateNumber"] retain];
        birthDate          = [[data objectForKey:@"birthDate"] retain];
        userId             = [[data objectForKey:@"userId"] integerValue];
        passengerId        = [[data objectForKey:@"id"] integerValue];
        type               = [[data objectForKey:@"type"] integerValue];
    }
    
    return self;
}

- (id) proxyForJson
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [Utils nilToNumber:[NSNumber numberWithInteger:type]],          @"type",
            [Utils NULLToEmpty:name],                                       @"name",
            [Utils NULLToEmpty:mobile],                                     @"mobile",
            [Utils NULLToEmpty:certificateType],                            @"certificateType",
            [Utils NULLToEmpty:certificateNumber],                          @"certificateNumber",
            [Utils NULLToEmpty:birthDate],                                  @"birthDate",
            [Utils nilToNumber:[NSNumber numberWithInteger:userId]],        @"userId",
            [Utils nilToNumber:[NSNumber numberWithInteger:passengerId]],   @"passengerId",
            nil];
}

- (void)dealloc
{
    [name                release];
    [mobile              release];
    [certificateType     release];
    [certificateNumber   release];
    [birthDate            release];
//    [papersType          release];
//    [papersNum           release];
    [super               dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
    PassengerInfo *passenger = [[[self class] alloc]init];
    passenger.name                  = name;
    passenger.mobile                = mobile;
    passenger.certificateType       = certificateType;
    passenger.certificateNumber     = certificateNumber;
    passenger.birthDate             = birthDate;
    passenger.userId                = userId;
    passenger.passengerId           = passengerId;
    passenger.type                  = type;
    
    return passenger;
}

@end
