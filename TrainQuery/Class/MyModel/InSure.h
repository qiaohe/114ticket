//
//  InSure.h
//  TrainTicketQuery
//
//  Created by M J on 13-9-11.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InSure : NSObject

@property (retain, nonatomic) NSString          *inSureType;
@property (retain, nonatomic) NSString          *inSureDetail;
@property (assign, nonatomic) BOOL              selected;

+ (NSArray*)getInSureTypeListWithData:(NSDictionary*)data;

@end
