//
//  TrainOrder.m
//  TrainTicketQuery
//
//  Created by M J on 13-9-4.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "TrainOrder.h"
#import "Utils.h"
#import "TrainCodeAndPrice.h"

@implementation TrainOrder

@synthesize orderHeadCode;
@synthesize orderId;
@synthesize orderStatus;
@synthesize payType;
@synthesize payDateTime;
@synthesize totalTickets;
@synthesize totalAmount;
@synthesize refundTickets;
@synthesize refundAmount;
@synthesize postType;
@synthesize postAddress;
@synthesize agentOrderId;
@synthesize agentId;
@synthesize trainCode;
@synthesize trainStartTime;
@synthesize startStation;
@synthesize endStation;
@synthesize seatType;
@synthesize userMobile;
@synthesize payAccount;
@synthesize openBank;
@synthesize finaStatus;
@synthesize userName;
@synthesize orderProvince;
@synthesize orderCity;
@synthesize ordercounty;
@synthesize orderStreet;
@synthesize trainOrderDetails;
@synthesize expPrice;
@synthesize aliTradeNo;
@synthesize transactionFee;
@synthesize userEmail;
@synthesize orderTime;
@synthesize orderNum;
@synthesize userId;

@synthesize selectTicketPrice;
@synthesize isUnfold;
@synthesize amount;

- (void)dealloc
{
    [orderHeadCode           release];
    [payDateTime             release];
    [postAddress             release];
    [trainCode               release];
    [trainStartTime          release];
    [startStation            release];
    [endStation              release];
    [seatType                release];
    [userMobile              release];
    [payAccount              release];
    [openBank                release];
    [userName                release];
    [orderProvince           release];
    [orderCity               release];
    [ordercounty             release];
    [orderStreet             release];
    [trainOrderDetails       release];
    [aliTradeNo              release];
    [userEmail               release];
    [orderTime               release];
    [orderNum                release];
    
    if (amount) {
        [amount release];
    }
    [super                   dealloc];
}

- (NSString *)getOrderStatus
{
    switch (orderStatus) {
        case 1:
            return @"未付款";
            break;
        case 2:
            return @"已付款";
            break;
        case 4:
            return @"票款不足";
            break;
        case 5:
            return @"网订待付";
            break;
        case 6:
            return @"无票";
            break;
        case 7:
            return @"已补款";
            break;
        case 10:
            return @"出票成功";
            break;
        case 11:
            return @"申请退票";
            break;
            
        default:
            return @"";
            break;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        postType = 2;
        isUnfold = NO;
        agentId  = 1;
        orderHeadCode  =  @"I";
        self.trainOrderDetails = [NSMutableArray array];
    }
    return self;
}

- (id)initWithPData:(NSDictionary*)data
{
    self = [super init];
    if (self) {
        postType = 2;
        isUnfold = NO;
        agentId  = 1;
        orderHeadCode  =  @"I";
        self.trainOrderDetails = [NSMutableArray array];
        
        orderHeadCode   = [[data objectForKey:@"orderHeadCode"] retain];
        orderId         = [[data objectForKey:@"orderId"] integerValue];
        orderStatus     = [[data objectForKey:@"orderStatus"] integerValue];
        payType         = [[data objectForKey:@"payType"] integerValue];
        payDateTime     = [[data objectForKey:@"payDateTime"] retain];
        totalTickets    = [[data objectForKey:@"totalTickets"] integerValue];
        totalAmount     = [[data objectForKey:@"totalAmount"] doubleValue];
        refundTickets   = [[data objectForKey:@"refundTickets"] integerValue];
        refundAmount    = [[data objectForKey:@"refundAmount"] doubleValue];
        postType        = [[data objectForKey:@"postType"] integerValue];
        postAddress     = [[data objectForKey:@"postAddress"] retain];
        agentOrderId    = [[data objectForKey:@"agentOrderId"] integerValue];
        agentId         = [[data objectForKey:@"agentId"] integerValue];
        trainCode       = [[data objectForKey:@"trainCode"] retain];
        trainStartTime  = [[data objectForKey:@"trainStartTime"] retain];
        startStation    = [[data objectForKey:@"startStation"] retain];
        endStation      = [[data objectForKey:@"endStation"] retain];
        seatType        = [[data objectForKey:@"seatType"] retain];
        userMobile      = [[data objectForKey:@"userMobile"] retain];
        payAccount      = [[data objectForKey:@"payAccount"] retain];
        openBank        = [[data objectForKey:@"openBank"] retain];
        finaStatus      = [[data objectForKey:@"finaStatus"] integerValue];
        userName        = [[data objectForKey:@"userName"] retain];
        orderProvince   = [[data objectForKey:@"orderProvince"] retain];
        orderCity       = [[data objectForKey:@"orderCity"] retain];
        ordercounty     = [[data objectForKey:@"ordercounty"] retain];
        orderStreet     = [[data objectForKey:@"orderStreet"] retain];
        expPrice        = [[data objectForKey:@"expPrice"] integerValue];
        aliTradeNo      = [[data objectForKey:@"aliTradeNo"] retain];
        transactionFee  = [[data objectForKey:@"transactionFee"] doubleValue];
        userEmail       = [[data objectForKey:@"userEmail"] retain];
        orderTime       = [[data objectForKey:@"orderTime"] retain];
        orderNum        = [[data objectForKey:@"orderNum"] retain];
        userId          = [[data objectForKey:@"userId"] integerValue];
    }
    return self;
}

- (id)initWithTrainCodeAndPrice:(TrainCodeAndPrice*)codeAndPrice
{
    self = [super init];
    if (self) {
        postType = 2;
        isUnfold = NO;
        agentId  = 1;
        orderHeadCode  =  @"I";
        self.trainOrderDetails = [NSMutableArray array];
        
        seatType            = codeAndPrice.seatType;
        trainStartTime      = codeAndPrice.startTime;
        startStation        = codeAndPrice.startCity;
        endStation          = codeAndPrice.endCity;
        trainCode           = codeAndPrice.trainCode;
    }
    return self;
}

- (id) proxyForJson
{
    NSDictionary *dic =  [NSDictionary dictionaryWithObjectsAndKeys:
                          [Utils NULLToEmpty:orderHeadCode],                                @"orderHeadCode",
                          [Utils nilToNumber:[NSNumber numberWithInteger:orderId]],         @"orderId",
                          [Utils nilToNumber:[NSNumber numberWithInteger:orderStatus]],     @"orderStatus",
                          [Utils nilToNumber:[NSNumber numberWithInteger:payType]],         @"payType",
                          [Utils NULLToEmpty:payDateTime],                                  @"payDateTime",
                          [Utils nilToNumber:[NSNumber numberWithInteger:totalTickets]],    @"totalTickets",
                          [Utils nilToNumber:[NSNumber numberWithDouble:totalAmount]],      @"totalAmount",
                          [Utils nilToNumber:[NSNumber numberWithInteger:refundTickets]],   @"refundTickets",
                          [Utils nilToNumber:[NSNumber numberWithDouble:refundAmount]],     @"refundAmount",
                          [Utils nilToNumber:[NSNumber numberWithInteger:postType]],        @"postType",
                          [Utils NULLToEmpty:postAddress],                                  @"postAddress",
                          [Utils nilToNumber:[NSNumber numberWithInteger:agentOrderId]],    @"agentOrderId",
                          [Utils nilToNumber:[NSNumber numberWithInteger:agentId]],         @"agentId",
                          [Utils NULLToEmpty:trainCode],                                    @"trainCode",
                          [Utils NULLToEmpty:trainStartTime],                               @"trainStartTime",
                          [Utils NULLToEmpty:startStation],                                 @"startStation",
                          [Utils NULLToEmpty:endStation],                                   @"endStation",
                          [Utils NULLToEmpty:seatType],                                     @"seatType",
                          [Utils NULLToEmpty:userMobile],                                   @"userMobile",
                          [Utils NULLToEmpty:payAccount],                                   @"payAccount",
                          [Utils NULLToEmpty:openBank],                                     @"openBank",
                          [Utils nilToNumber:[NSNumber numberWithInteger:finaStatus]],      @"finaStatus",
                          [Utils NULLToEmpty:userName],                                     @"userName",
                          [Utils NULLToEmpty:orderProvince],                                @"orderProvince",
                          [Utils NULLToEmpty:orderCity],                                    @"orderCity",
                          [Utils NULLToEmpty:ordercounty],                                  @"ordercounty",
                          [Utils NULLToEmpty:orderStreet],                                  @"orderStreet",
                          trainOrderDetails,                                                @"trainOrderDetails",
                          [Utils nilToNumber:[NSNumber numberWithInteger:expPrice]],        @"expPrice",
                          [Utils NULLToEmpty:aliTradeNo],                                   @"aliTradeNo",
                          [Utils nilToNumber:[NSNumber numberWithDouble:transactionFee]],  @"transactionFee",
                          [Utils NULLToEmpty:userEmail],                                    @"userEmail",
                          [Utils NULLToEmpty:orderTime],                                    @"orderTime",
                          [Utils NULLToEmpty:orderNum],                                     @"orderNum",
                          [Utils nilToNumber:[NSNumber numberWithInteger:userId]],          @"userId",
                          nil];

    return dic;
}

@end
