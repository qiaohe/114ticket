//
//  UserDefaults.m
//  TrainTicketQuery
//
//  Created by M J on 13-9-2.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "UserDefaults.h"

static UserDefaults *shareUserDefault;

@implementation UserDefaults

@synthesize userName;
@synthesize passWord;
@synthesize userId;
@synthesize cookie;
@synthesize realName;
@synthesize mobile;
@synthesize email;
@synthesize sex;
@synthesize contacts;
@synthesize getUserInfo;

- (void)dealloc
{
    [userName        release];
    [passWord        release];
    [userId          release];
    [cookie          release];
    [realName        release];
    [mobile          release];
    [email           release];
    [sex             release];
    [contacts        release];
    [super           dealloc];
}

+ (UserDefaults*)shareUserDefault
{
    @synchronized(self){
        if (shareUserDefault == nil) {
            shareUserDefault = [[UserDefaults alloc]init];
        }
    }
    return shareUserDefault;
}

- (id)init
{
    self = [super init];
    if (self) {
        getUserInfo = NO;
        self.contacts = [NSMutableArray array];
    }
    return self;
}

- (void)clearDefaults
{
    [self setUserId:nil];
    [self setPassWord:nil];
    [self setUserName:nil];
    [self setCookie:nil];
    [self setRealName:nil];
    [self setMobile:nil];
    [self setEmail:nil];
    [self setSex:nil];
    [self setGetUserInfo:NO];
}

- (NSString *)userId
{
    if (!userId) {
        userId = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] retain];
    }
    return userId;
}

- (void)setUserId:(NSString *)_userId
{
    if (self.userId != _userId) {
        if (userId) {
            [userId release];
        }
        [[NSUserDefaults standardUserDefaults] setValue:_userId forKey:@"userId"];
        userId = [_userId retain];
    }
}

- (NSString *)userName
{
    if (!userName) {
        userName = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] retain];
    }
    return userName;
}

- (void)setUserName:(NSString *)_userName
{
    if (self.userName != _userName) {
        if (userName) {
            [userName release];
        }
        [[NSUserDefaults standardUserDefaults] setValue:_userName forKey:@"userName"];
        userName = [_userName retain];
    }
}

- (NSString *)passWord
{
    if (!passWord) {
        passWord = [[[NSUserDefaults standardUserDefaults] valueForKey:@"passWord"] retain];
    }
    return passWord;
}

- (void)setPassWord:(NSString *)_passWord
{
    if (self.passWord != _passWord) {
        if (passWord) {
            [passWord release];
        }
        [[NSUserDefaults standardUserDefaults] setValue:_passWord forKey:@"passWord"];
        passWord = [_passWord retain];
    }
}

- (NSString *)cookie
{
    if (!cookie) {
        cookie = [[[NSUserDefaults standardUserDefaults] valueForKey:@"cookie"] retain];
    }
    return cookie;
}

- (void)setCookie:(NSString *)_cookie
{
    if (self.cookie != _cookie) {
        if (cookie) {
            [cookie release];
        }
        [[NSUserDefaults standardUserDefaults] setValue:_cookie forKey:@"passWord"];
        cookie = [_cookie retain];
    }
}


- (NSString *)realName
{
    if (!realName) {
        realName = [[[NSUserDefaults standardUserDefaults] valueForKey:@"realName"] retain];
    }
    return realName;
}

- (void)setRealName:(NSString *)_realName
{
    if (self.realName != _realName) {
        if (realName) {
            [realName release];
        }
        [[NSUserDefaults standardUserDefaults] setValue:_realName forKey:@"realName"];
        realName = [_realName retain];
    }
}


- (NSString *)mobile
{
    if (!mobile) {
        mobile = [[[NSUserDefaults standardUserDefaults] valueForKey:@"mobile"] retain];
    }
    return mobile;
}

- (void)setMobile:(NSString *)_mobile
{
    if (self.mobile != _mobile) {
        if (mobile) {
            [mobile release];
        }
        [[NSUserDefaults standardUserDefaults] setValue:_mobile forKey:@"mobile"];
        mobile = [_mobile retain];
    }
}

- (NSString *)email
{
    if (!email) {
        email = [[[NSUserDefaults standardUserDefaults] valueForKey:@"email"] retain];
    }
    return email;
}

- (void)setEmail:(NSString *)_email
{
    if (self.email != _email) {
        if (email) {
            [email release];
        }
        [[NSUserDefaults standardUserDefaults] setValue:_email forKey:@"email"];
        email = [_email retain];
    }
}


- (NSString *)sex
{
    if (!sex) {
        sex = [[[NSUserDefaults standardUserDefaults] valueForKey:@"sex"] retain];
    }
    return sex;
}

- (void)setSex:(NSString *)_sex
{
    if (self.sex != _sex) {
        if (sex) {
            [sex release];
        }
        [[NSUserDefaults standardUserDefaults] setValue:_sex forKey:@"sex"];
        sex = [_sex retain];
    }
}


- (NSMutableArray *)contacts
{
    if (!contacts) {
        contacts = [[[NSUserDefaults standardUserDefaults] valueForKey:@"contacts"] retain];
    }
    return contacts;
}

- (void)setContacts:(NSMutableArray *)_contacts
{
    if (self.contacts != _contacts) {
        if (contacts) {
            [contacts release];
        }
        [[NSUserDefaults standardUserDefaults] setValue:_contacts forKey:@"contacts"];
        contacts = [_contacts retain];
    }
}



@end
