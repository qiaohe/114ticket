//
//  UserDefaults.h
//  TrainTicketQuery
//
//  Created by M J on 13-9-2.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject

+(UserDefaults*)shareUserDefault;

@property (retain, nonatomic, getter = userName, setter = setUserName:) NSString        *userName;
@property (retain, nonatomic, getter = passWord, setter = setPassWord:) NSString        *passWord;
@property (retain, nonatomic, getter = userId,   setter = setUserId:)   NSString        *userId;
@property (retain, nonatomic, getter = cookie,   setter = setCookie:)   NSString        *cookie;
@property (retain, nonatomic, getter = realName, setter = setRealName:) NSString        *realName;
@property (retain, nonatomic, getter = mobile,   setter = setMobile:)   NSString        *mobile;
@property (retain, nonatomic, getter = email,    setter = setEmail:)    NSString        *email;
@property (retain, nonatomic, getter = sex,      setter = getSex:)      NSString        *sex;
@property (retain, nonatomic, getter = contacts, setter = setContacts:) NSMutableArray  *contacts;
@property (assign, nonatomic)                                           BOOL            getUserInfo;

- (void)clearDefaults;

@end
