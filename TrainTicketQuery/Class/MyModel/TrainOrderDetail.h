//
//  TrainOrderDetail.h
//  TrainTicketQuery
//
//  Created by M J on 13-9-4.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PassengerInfo;

@interface TrainOrderDetail : NSObject

@property (assign, nonatomic) NSInteger         orderDetailId;      //子订单ID
@property (assign, nonatomic) NSInteger         orderId;            //订单ID
@property (retain, nonatomic) NSString          *userName;          //旅客姓名
@property (retain, nonatomic) NSString          *seatType;          //车座类型,子订单不可设,父订单统一的
@property (assign, nonatomic) CGFloat           ticketPrice;        //票价
@property (retain, nonatomic) NSString          *idCard;            //证件号码
@property (retain, nonatomic) NSString          *cardType;          //证件类型
@property (assign, nonatomic) double            insurance;          //保险费
@property (retain, nonatomic) NSString          *birthdate;         //出生日期
@property (assign, nonatomic) NSInteger         type;               //车票类型
@property (retain, nonatomic) NSString          *childrenName;      //儿童姓名

- (id)initWithPData:(NSDictionary*)data;
- (id)initWithPassenger:(PassengerInfo*)passenger;

@end
