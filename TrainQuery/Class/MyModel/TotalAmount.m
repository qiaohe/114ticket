//
//  TotalAmount.m
//  TrainTicketQuery
//
//  Created by M J on 13-9-3.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "TotalAmount.h"
#import "TrainOrderDetail.h"

@implementation TotalAmount

@synthesize totalAmount;
@synthesize ticketAmount;
@synthesize alipayAmount;
@synthesize premiumAmount;
@synthesize saleSiteAmount;
@synthesize expressAmount;

- (id)init
{
    self = [super init];
    if (self) {
        totalAmount    = 0.0f;
        ticketAmount   = 0.0f;
        alipayAmount   = 0.0f;
        premiumAmount  = 0.0f;
        saleSiteAmount = 0.0f;
        expressAmount  = 0.0f;
    }
    return self;
}

- (id)initWithPData:(NSDictionary*)data
{
    self = [super init];
    if (self) {
        totalAmount = [[data objectForKey:@"totalAmount"] floatValue];
        alipayAmount = [[data objectForKey:@"transactionFee"] doubleValue];
        if ([[data objectForKey:@"trainOrderDetails"] count] != 0) {
            TrainOrderDetail *orderDetail = [[[TrainOrderDetail alloc]initWithPData:[[data objectForKey:@"trainOrderDetails"] objectAtIndex:0]]autorelease];
            ticketAmount = orderDetail.ticketPrice;
            premiumAmount = orderDetail.insurance;
        }else{
            premiumAmount = 0.0f;
        }
        saleSiteAmount = 0.0f;
        expressAmount  = 0.0f;
    }
    return self;
}

@end
