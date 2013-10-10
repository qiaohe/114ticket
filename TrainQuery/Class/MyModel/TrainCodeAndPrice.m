//
//  TrainCodeAndPrice.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-9.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "TrainCodeAndPrice.h"
#import "SBJSON.h"

@implementation TrainCodeAndPrice

@synthesize yzOk;
@synthesize startTime;
@synthesize ywYp;
@synthesize gwYp;
@synthesize ywxOk;
@synthesize seatType;
@synthesize gwx;
@synthesize rwx;
@synthesize endCity;
@synthesize gwxOk;
@synthesize rwxOk;
@synthesize rz1Ok;
@synthesize isZd;
@synthesize hasYpInfo;
@synthesize yws;
@synthesize typeId;
@synthesize fdPriceId;
@synthesize sfz;
@synthesize rz1Yp;
@synthesize endStationPy;
@synthesize zdz;
@synthesize wzYp;
@synthesize ywsOk;
@synthesize rzYp;
@synthesize trainType;
@synthesize distance;
@synthesize wz;
@synthesize gwsOk;
@synthesize rwsOk;
@synthesize tdz;
@synthesize beginCityPy;
@synthesize rz2Ok;
@synthesize yzYp;
@synthesize ywx;
@synthesize tdzOk;
@synthesize rz2Yp;
@synthesize wzOk;
@synthesize yz;
@synthesize isSf;
@synthesize tdzYp;
@synthesize rzOk;
@synthesize ywzOk;
@synthesize endTime;
@synthesize rz1;
@synthesize startCity;
@synthesize isOk;
@synthesize gws;
@synthesize beginStationPy;
@synthesize costTime;
@synthesize rwYp;
@synthesize trainCode;
@synthesize rws;
@synthesize rz2;
@synthesize dzDay;
@synthesize ywz;
@synthesize rz;
@synthesize isUnfold;
@synthesize firstLoad;
@synthesize selectSeatType;

- (id)init
{
    if (self = [super init]) {
        //[self addObserver:self forKeyPath:@"trainType" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        self.isUnfold  = NO;
        self.firstLoad = YES;
    }
    return self;
}

- (void)dealloc
{
    //[self.yzOk           release];
    [startTime      release];
    //[self.ywYp           release];
    //[self.gwYp           release];
    //[self.ywxOk          release];
    //[self.seatType       release];
    [gwx            release];
    [rwx            release];
    [endCity        release];
    //[self.gwxOk          release];
    //[self.rwxOk          release];
    //[self.rz1Ok          release];
    //[self.isZd           release];
    //[self.hasYpInfo      release];
    [yws            release];
    //[self.typeId         release];
    //[self.fdPriceId      release];
    [sfz            release];
    //[self.rz1Yp          release];
    [endStationPy   release];
    [zdz            release];
    //[self.wzYp           release];
    //[self.ywsOk          release];
    //[self.rzYp           release];
    [trainType      release];
    //[self.distance       release];
    [wz             release];
    //[self.gwsOk          release];
    //[self.rwsOk          release];
    [tdz            release];
    [beginCityPy    release];
    //[self.rz2Ok          release];
    //[self.yzYp           release];
    [ywx            release];
    //[self.tdzOk          release];
    //[self.rz2Yp          release];
    //[self.wzOk           release];
    [yz             release];
    //[self.isSf           release];
    //[self.tdzYp          release];
    //[self.rzOk           release];
    //[self.ywzOk          release];
    [endTime        release];
    [rz1            release];
    [startCity      release];
    //[self.isOk           release];
    [gws            release];
    [beginStationPy release];
    [costTime       release];
    //[self.rwYp           release];
    [trainCode      release];
    [rws            release];
    [rz2            release];
    //[self.dzDay          release];
    [ywz            release];
    [rz             release];
    
    [super               dealloc];
}

- (NSComparisonResult)compare:(TrainCodeAndPrice *)params
{
    return [self.startTime compare:params.startTime];
}
@end
