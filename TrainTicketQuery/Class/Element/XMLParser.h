//
//  XMLParser.h
//  TrainTicketQuery
//
//  Created by M J on 13-9-9.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASIHTTPRequest;

@interface XMLParser : NSXMLParser

@property (retain, nonatomic) NSDictionary *userInfo;
@property (retain, nonatomic) ASIHTTPRequest *request;

@end
