//
//  Utils.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-20.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(NSString*)nilToEmpty:(NSString*)value
{
    return value == nil?@"":value;
}

+(id)nilToNumber:(id)value
{
    return value == nil?[NSNumber numberWithFloat:0.0]:value;
}

+(NSString*)NULLToEmpty:(id)value
{
    return ([value isKindOfClass:[NSNull class]] || value == nil)?@"":value;
}

+(BOOL)textIsEmpty:(NSString*)value
{
    if ([value isEqualToString:@""] || value == nil) {
        return YES;
    }return NO;
}

+(NSString *)stringWithDate:(NSDate*)date withFormat:(NSString*)format
{
    NSDateFormatter *dateFormate = [[[NSDateFormatter alloc]init]autorelease];
    [dateFormate setDateFormat:format];
    NSString *dateString = [dateFormate stringFromDate:date];
    return dateString;
}

+(NSDate*)dateWithString:(NSString *)date withFormat:(NSString*)format
{
    NSDateFormatter *dateFormate = [[[NSDateFormatter alloc]init]autorelease];
    [dateFormate setDateFormat:format];
    NSDate *dateString = [dateFormate dateFromString:date];
    return dateString;
}

+(CGRect)frameWithRect:(CGRect)rect adaptWidthOrHeight:(adaptType)adapt
{
    CGFloat width;
    CGFloat height;
    if (adapt == adaptNone) {
        width = rect.size.width  * appFrame.size.width/ footScreenSize.width;
        height = rect.size.height * appFrame.size.height/ footScreenSize.height;
    }else if(adapt == adaptWidth){
        width = rect.size.width * appFrame.size.width/ footScreenSize.width ;
        height = width*rect.size.height/rect.size.width;
    }else {
        height = rect.size.height * appFrame.size.height/ footScreenSize.height ;
        width = height*rect.size.width/rect.size.height;
    }
    return CGRectMake((rect.origin.x  * appFrame.size.width/ footScreenSize.width), (rect.origin.y  * appFrame.size.height/footScreenSize.height), width, height);
}


+(BOOL)isValidatePhoneNum:(NSString *)phoneNum
{
    
    NSString *phoneNumRegex = @"(\\+\\d+)?1[3458]\\d{9}$";
    
    NSPredicate *phoneNumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneNumRegex];
    
    return [phoneNumTest evaluateWithObject:phoneNum];
}

+(BOOL)isValidatePassportNum:(NSString *)passportNum
{
    NSString *phoneNumRegex = @"P\\d{7}|G\\d{8}|\\d{8}D|S\\d{7}|S\\d{8}|D\\d{8}";
    
    NSPredicate *phoneNumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneNumRegex];
    
    return [phoneNumTest evaluateWithObject:passportNum];
}

+(BOOL)isValidateIdNum:(NSString *)idNum
{
    NSString *phoneNumRegex2 = @"^\\d{15}(\\d{2}[0-9xX])?$";
    
    NSPredicate *phoneNumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneNumRegex2];
    return [phoneNumTest evaluateWithObject:idNum];
}

@end
