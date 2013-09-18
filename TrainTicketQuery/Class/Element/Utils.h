//
//  Utils.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-20.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <Foundation/Foundation.h>

#define         appFrame                    [[UIScreen mainScreen] applicationFrame]
#define         footScreenSize              CGSizeMake(320,460)

typedef NS_OPTIONS(NSInteger, adaptType){
    adaptNone,
    adaptWidth,
    adaptHeight
};

@interface Utils : NSObject

+(NSString*)nilToEmpty:(NSString*)value;
+(NSString*)NULLToEmpty:(id)value;
+(id)nilToNumber:(id)value;
+(BOOL)textIsEmpty:(NSString*)value;
+(BOOL)isValidatePhoneNum:(NSString *)phoneNum;
+(BOOL)isValidateIdNum:(NSString *)idNum;
+(BOOL)isValidatePassportNum:(NSString *)passportNum;
+(NSString *)stringWithDate:(NSDate*)date withFormat:(NSString*)format;
+(NSDate*)dateWithString:(NSString *)date withFormat:(NSString*)format;
+(CGRect)frameWithRect:(CGRect)rect adaptWidthOrHeight:(adaptType)adapt;

@end
