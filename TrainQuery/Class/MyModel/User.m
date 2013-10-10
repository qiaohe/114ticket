//
//  User.m
//  TrainTicketQuery
//
//  Created by M J on 13-9-4.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "User.h"
#import "Utils.h"

@implementation User

@synthesize userId;
@synthesize userName;
@synthesize mobile;
@synthesize password;
@synthesize email;
@synthesize realName;
@synthesize sex;

- (void)dealloc
{
    [userName            release];
    [mobile              release];
    [password            release];
    [email               release];
    [realName            release];
    [super               dealloc];
}

- (id)initWithData:(NSDictionary*)data
{
    self = [super init];
    if (self) {
        userName    = [[data objectForKey:@"userName"]retain];
        userId      = [[data objectForKey:@"userId"]integerValue];
        mobile      = [[data objectForKey:@"mobile"]retain];
        password    = [[data objectForKey:@"password"]retain];
        email       = [[data objectForKey:@"email"]retain];
        realName    = [[data objectForKey:@"realName"]retain];
        sex         = [[data objectForKey:@"sex"]integerValue];
    }
    return  self;
}

- (id) proxyForJson
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [Utils NULLToEmpty:userName],                                   @"userName",
            [Utils nilToNumber:[NSNumber numberWithInteger:userId]],        @"userId",
            [Utils NULLToEmpty:mobile],                                     @"mobile",
            [Utils NULLToEmpty:password],                                   @"password",
            [Utils NULLToEmpty:email],                                      @"email",
            [Utils NULLToEmpty:realName],                                   @"realName",
            [Utils nilToNumber:[NSNumber numberWithInteger:sex]],           @"sex",
            nil];
}

@end
