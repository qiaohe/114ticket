//
//  XMLParser.m
//  TrainTicketQuery
//
//  Created by M J on 13-9-9.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser

@synthesize userInfo;
@synthesize request;

- (void)dealloc
{
    [userInfo        release];
    [request         release];
    [super           dealloc];
}

@end
