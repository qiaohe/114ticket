//
//  User.h
//  TrainTicketQuery
//
//  Created by M J on 13-9-4.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PassengerInfo.h"
#import "TrainInfo.h"
#import "TrainInfoDetail.h"
#import "TrainOrder.h"
#import "TrainOrderDetail.h"

@interface User : NSObject

@property (assign, nonatomic)   NSInteger           userId;                 //用户ID
@property (retain, nonatomic)   NSString            *userName;              //用户名
@property (retain, nonatomic)   NSString            *mobile;                //手机号码
@property (retain, nonatomic)   NSString            *password;              //密码
@property (retain, nonatomic)   NSString            *email;                 //用户邮箱
@property (retain, nonatomic)   NSString            *realName;              //用户真实姓名
@property (assign, nonatomic)   NSInteger           sex;                    //性别(1:男,0:女)

- (id)initWithData:(NSDictionary*)data;

@end
