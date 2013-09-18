//
//  TrainOrder.h
//  TrainTicketQuery
//
//  Created by M J on 13-9-4.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TotalAmount.h"

@class TrainCodeAndPrice;

@interface TrainOrder : NSObject

@property (retain, nonatomic) NSString          *orderHeadCode;                     //订单编号开头识别码(号百以H开头,北京以C开头)
@property (assign, nonatomic) NSInteger         orderId;
@property (assign, nonatomic) NSInteger         orderStatus;                        //火车票触控数据库的订单状态
@property (assign, nonatomic) NSInteger         payType;                            //火车票交易系统的支付状态
@property (retain, nonatomic) NSString          *payDateTime;                       //订单支付时间
@property (assign, nonatomic) NSInteger         totalTickets;                       //此订单总张数
@property (assign, nonatomic) double            totalAmount;                        //票价中金额:票价*张数(元)
@property (assign, nonatomic) NSInteger         refundTickets;                      //退票总张数
@property (assign, nonatomic) double            refundAmount;                       //退款总金额
@property (assign, nonatomic) NSInteger         postType;                           //火车票送票方式,1:快递,2:自取(默认)
@property (retain, nonatomic) NSString          *postAddress;                       //火车票邮寄地址
@property (assign, nonatomic) NSInteger         agentOrderId;                       //触控订单在合作方数据库对应的合作方的订单编号
@property (assign, nonatomic) NSInteger         agentId;                            //火车票代理商ID,目前只有票务114一家,所以系统默认次ID为1
@property (retain, nonatomic) NSString          *trainCode;                         //订单车次
@property (retain, nonatomic) NSString          *trainStartTime;                    //火车票开始出发时间
@property (retain, nonatomic) NSString          *startStation;                      //车次对应的起点站
@property (retain, nonatomic) NSString          *endStation;                        //车次对应的终点站
@property (retain, nonatomic) NSString          *seatType;                          //购票作为类型
@property (retain, nonatomic) NSString          *userMobile;                        //用户手机号:用户邮寄联系方式
@property (retain, nonatomic) NSString          *payAccount;                        //支付账号:如实网银支付的,此处记录银行卡号:如果是支付宝支付,此处记录支付宝账号
@property (retain, nonatomic) NSString          *openBank;                          //网银开户行:一般用户网银支付的用户,在退款的时候用
@property (assign, nonatomic) NSInteger         finaStatus;                         //结算状态
@property (retain, nonatomic) NSString          *userName;                          //用户姓名:用于快递邮寄的收件人
@property (retain, nonatomic) NSString          *orderProvince;                     //邮寄的省份
@property (retain, nonatomic) NSString          *orderCity;                         //邮寄的城市
@property (retain, nonatomic) NSString          *ordercounty;                       //邮寄的区县
@property (retain, nonatomic) NSString          *orderStreet;                       //邮寄的具体街道地址
@property (retain, nonatomic) NSMutableArray    *trainOrderDetails;                 //主订单包含的子订单:最多5张,最少1张
@property (assign, nonatomic) NSInteger         expPrice;                           //快递费用
@property (retain, nonatomic) NSString          *aliTradeNo;                        //支付宝交易流水号
@property (assign, nonatomic) double            transactionFee;                     //支付交易费,网银或支付宝的手续费
@property (retain, nonatomic) NSString          *userEmail;                         //用户邮箱
@property (retain, nonatomic) NSString          *orderTime;                         //下单时间
@property (retain, nonatomic) NSString          *orderNum;                          //订单编号
@property (assign, nonatomic) NSInteger         userId;                             //用户Id

@property (assign, nonatomic) CGFloat           selectTicketPrice;                  //选择的票单价
@property (assign, nonatomic) BOOL              isUnfold;
@property (retain, nonatomic) TotalAmount       *amount;                            //票价信息

- (id)initWithPData:(NSDictionary*)data;
- (id)initWithTrainCodeAndPrice:(TrainCodeAndPrice*)codeAndPrice;

- (NSString *)getOrderStatus;

@end
