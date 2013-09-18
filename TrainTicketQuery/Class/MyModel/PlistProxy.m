//
//  PlistProxy.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-19.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "PlistProxy.h"
#import "QueryHistory.h"
#import "Model.h"

@implementation PlistProxy

static PlistProxy *sharePlistProxy;

@synthesize sandPath;
@synthesize allQueryHistoryPath;
@synthesize trainCodeQueryHistroyPath;

- (void)dealloc
{
    [sandPath                  release];
    [allQueryHistoryPath       release];
    [trainCodeQueryHistroyPath release];
    [super                     dealloc];
}

+ (PlistProxy*)sharePlistProxy
{
    @synchronized(self){
        if (sharePlistProxy == nil) {
            sharePlistProxy = [[PlistProxy alloc]init];
        }
    }
    return sharePlistProxy;
}

- (id)init
{
    if (self = [super init]) {
        self.sandPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        self.allQueryHistoryPath = [self.sandPath stringByAppendingPathComponent:@"AllQuertHistory.plist"];
        self.trainCodeQueryHistroyPath = [self.sandPath stringByAppendingPathComponent:@"TrainCodeQueryHistory.plist"];
    }
    return self;
}

- (NSMutableArray*)getAllQueryHistory
{
    return [NSMutableArray arrayWithContentsOfFile:[PlistProxy sharePlistProxy].allQueryHistoryPath];
}

- (NSMutableArray*)getTrainCodeQueryHistory
{
    return [NSMutableArray arrayWithContentsOfFile:[PlistProxy sharePlistProxy].trainCodeQueryHistroyPath];
}

- (void)updateQueryHistory
{
    NSMutableArray *array = [NSMutableArray array];
    for (QueryHistory *e in [Model shareModel].allQueryHistory) {
        [array addObject:[e getData]];
    }
    [array writeToFile:self.allQueryHistoryPath atomically:YES];
    
    [array removeAllObjects];
    for (QueryHistory *e in [Model shareModel].trainCodeQueryHistory) {
        [array addObject:[e getData]];
    }
    [array writeToFile:self.trainCodeQueryHistroyPath atomically:YES];
}

@end
