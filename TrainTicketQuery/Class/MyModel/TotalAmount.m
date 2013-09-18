//
//  TotalAmount.m
//  TrainTicketQuery
//
//  Created by M J on 13-9-3.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "TotalAmount.h"

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
        totalAmount    = 0.0;
        ticketAmount   = 0.0;
        alipayAmount   = 0.0;
        premiumAmount  = 0.0;
        saleSiteAmount = 0.0;
        expressAmount  = 0.0;
    }
    return self;
}
@end
