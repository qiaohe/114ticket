//
//  BaseUIViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-9.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJSON.h"
#import "TrainCodeAndPrice.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "User.h"
#import "UserDefaults.h"
#import "XMLParser.h"

@class QueryHistory;


#define         appFrame                    [[UIScreen mainScreen] applicationFrame]
#define         appBounds                   [[UIScreen mainScreen] bounds]
#define         imageNameAndType(a,b)       [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:a ofType:b]]
#define         subViewFrame                CGRectMake(0, 80, appFrame.size.width, appFrame.size.height - 80)
#define         selfViewFrame               self.view.frame
#define         baseFrame                   CGRectMake(0, 0, appFrame.size.width, appFrame.size.height)

typedef NS_OPTIONS(NSUInteger, ViewTrasitionEffect) {
    ViewTrasitionEffectNone                 = 1 << 0,
    ViewTrasitionEffectFadeIn               = 1 << 1,
    ViewTrasitionEffectMoveLeft             = 1 << 2,
    ViewTrasitionEffectMoveRight            = 1 << 3,
    ViewTrasitionEffectFlip                 = 1 << 4,
};

typedef enum{
    SeatTypeYZ,
    SeatTypeRZ,
    SeatTypeYW,
    SeatTypeRW,
    SeatTypeRZ1,
    SeatTypeRZ2
}SeatType;

typedef enum{
    trainTypeHeightSpeed,
    trainTypeNormalSpeed
}TrainType;

typedef enum{
    QueryAllTrainCodeAndPrice               = 1,
    QueryTrainCodeAndPrice
}QueryTrainType;

typedef NS_OPTIONS(NSInteger, RequestType){
    RequestGet,
    RequestPost,
    RequestLogIn,
    RequestLogOut
};

@interface NSXMLParser (NSXMLParserInfo)

//@property (retain, nonatomic) NSDictionary *userInfo;

@end

@interface BaseUIViewController : UIViewController<NSXMLParserDelegate,ASIHTTPRequestDelegate>

@property (retain, nonatomic) NSMutableString *dataString;

- (void)parserStringBegin:(ASIHTTPRequest*)request;
- (void)parserStringFinished:(NSString*)_string request:(ASIHTTPRequest*)request;

- (NSString *)stringWithDate:(NSDate*)date;
- (NSDate*)dateWithString:(NSString *)date;
- (UIColor *)getColor:(NSString *)stringToConvert;
- (NSString*)getTrainTypeWithParams:(NSString*)_string;

- (void)getAllTrainCodeAndPriceWithParams:(QueryHistory*)_history withUserInfo:(NSDictionary*)userInfo;
- (void)getTrainCodeAndPriceWithParams:(QueryHistory*)_history withUserInfo:(NSDictionary*)userInfo;
- (void)getAllGaotieTrainCodeAndPriceWithParams:(QueryHistory*)_history withUserInfo:(NSDictionary*)userInfo;
- (void)getGaotieTrainCodeAndPriceWithParams:(QueryHistory*)_history withUserInfo:(NSDictionary*)userInfo;
- (TrainType)checkTrainTypeWithParams:(NSString*)_type;

- (NSString*) getStatusWithTrainOrder:(TrainOrder*)order;

- (void)requestDone:(ASIHTTPRequest*)request;
- (void)requestError:(ASIHTTPRequest*)request;
- (void)reloadTableView:(UITableView*)tableView scrollToTop:(BOOL)scroll;

- (UILabel*)getLabelWithFrame:(CGRect)frame
                textAlignment:(NSTextAlignment)alignment
              backGroundColor:(UIColor*)backColor
                    textColor:(UIColor*)textColor
                        title:(NSString*)title
                         font:(UIFont*)font;
- (UIImageView*)getImageViewWithFrame:(CGRect)frame
                                image:(UIImage*)image
                       highLightImage:(UIImage*)highLightImage
                      backGroundColor:(UIColor*)backColor;
- (UIButton*)getButtonWithFrame:(CGRect)frame
                          title:(NSString*)title
                      textColor:(UIColor*)textColor
                       forState:(UIControlState)state
                backGroundColor:(UIColor*)backColor;

- (void)keyBoardWillShow:(NSNotification*)notification;
- (void)keyBoardWillHide:(NSNotification*)notification;
- (void)keyBoardChangeFrame:(NSNotification*)notification;

- (id)dataSource:(NSArray*)dataSource ContainsObject:(QueryHistory*)object;
- (void)sendRequestWithURL:(NSString*)URLString params:(NSDictionary*)params requestMethod:(RequestType)requestType userInfo:(NSDictionary*)userInfo;

@end
