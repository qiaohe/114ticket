//
//  PassengerInfo.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-19.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, TrainTicketType){
    TicketMan                   =   1,
    TicketChildren,
    TicketOldMan
};

@interface PassengerInfo : NSObject<NSCopying>

//@property (assign, nonatomic) TrainTicketType   ticketType;
@property (assign, nonatomic) TrainTicketType   type;                           //乘客类型  1:儿童   2:成年人   3:老年人
@property (copy,   nonatomic) NSString          *name;                          //乘客姓名
@property (copy,   nonatomic) NSString          *mobile;                        //常用旅客手机号
@property (copy,   nonatomic) NSString          *certificateType;               //证件类型    0身份证  1护照 2港澳台通行证
@property (copy,   nonatomic) NSString          *certificateNumber;             //证件号码
@property (copy,   nonatomic) NSString          *birthDate;                     //出生年月日
@property (assign, nonatomic) NSInteger         userId;                         //用户ID
@property (assign, nonatomic) NSInteger         passengerId;                    //常用旅客ID
/*
@property (copy,   nonatomic) NSString          *papersType;
@property (copy,   nonatomic) NSString          *papersNum;*/
@property (assign, nonatomic) BOOL              selected;
//@property (assign, nonatomic) BOOL              reserve;

- (id)initWithJSONData:(NSDictionary*)data;

@end
