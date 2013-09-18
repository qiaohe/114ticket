//
//  TrainOrderDetail.m
//  TrainTicketQuery
//
//  Created by M J on 13-9-4.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "TrainOrderDetail.h"
#import "Utils.h"
#import "PassengerInfo.h"

@implementation TrainOrderDetail

@synthesize orderDetailId;
@synthesize orderId;
@synthesize userName;
@synthesize seatType;
@synthesize ticketPrice;
@synthesize idCard;
@synthesize cardType;
@synthesize insurance;
@synthesize birthdate;
@synthesize type;
@synthesize childrenName;

- (void)dealloc
{
    [userName            release];
    [seatType            release];
    [idCard              release];
    [cardType            release];
    [birthdate           release];
    [childrenName        release];
    [super               dealloc];
}

- (id)initWithPassenger:(PassengerInfo*)passenger
{
    self = [super init];
    if (self) {
        userName = passenger.name;
        idCard   = passenger.certificateNumber;
        cardType = passenger.certificateType;
        birthdate = passenger.birthDate;
        type      = passenger.type;
    }
    return self;
}

- (id)initWithPData:(NSDictionary*)data
{
    self = [super init];
    if (self) {
        orderDetailId   =   [[data objectForKey:@"orderDetailId"] integerValue];
        orderId         =   [[data objectForKey:@"orderId"] integerValue];
        userName        =   [[data objectForKey:@"userName"] retain];
        seatType        =   [[data objectForKey:@"seatType"] retain];
        ticketPrice     =   [[data objectForKey:@"ticketPrice"] floatValue];
        idCard          =   [[data objectForKey:@"idCard"] retain];
        cardType        =   [[data objectForKey:@"cardType"] retain];
        insurance       =   [[data objectForKey:@"insurance"] doubleValue];
        birthdate       =   [[data objectForKey:@"birthdate"] retain];
        type            =   [[data objectForKey:@"type"] integerValue];
        childrenName    =   [[data objectForKey:@"childrenName"] retain];
    }

    return self;
}

- (id) proxyForJson
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [Utils nilToNumber:[NSNumber numberWithInteger:orderDetailId]],     @"orderDetailId",
            [Utils nilToNumber:[NSNumber numberWithInteger:orderId]],           @"orderId",
            [Utils NULLToEmpty:userName],                                       @"userName",
            [Utils NULLToEmpty:seatType],                                       @"seatType",
            [Utils nilToNumber:[NSNumber numberWithFloat:ticketPrice]],         @"ticketPrice",
            [Utils NULLToEmpty:idCard],                                         @"idCard",
            [Utils NULLToEmpty:cardType],                                       @"cardType",
            [Utils nilToNumber:[NSNumber numberWithDouble:insurance]],          @"insurance",
            [Utils NULLToEmpty:birthdate],                                      @"birthdate",
            [Utils nilToNumber:[NSNumber numberWithInteger:type]],              @"type",
            [Utils NULLToEmpty:childrenName],                                   @"childrenName",
            nil];
}

@end
