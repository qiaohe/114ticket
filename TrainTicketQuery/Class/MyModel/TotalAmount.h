//
//  TotalAmount.h
//  TrainTicketQuery
//
//  Created by M J on 13-9-3.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TotalAmount : NSObject

@property (assign, nonatomic) CGFloat totalAmount;
@property (assign, nonatomic) CGFloat ticketAmount;
@property (assign, nonatomic) CGFloat alipayAmount;
@property (assign, nonatomic) CGFloat premiumAmount;
@property (assign, nonatomic) CGFloat saleSiteAmount;
@property (assign, nonatomic) CGFloat expressAmount;

@end
