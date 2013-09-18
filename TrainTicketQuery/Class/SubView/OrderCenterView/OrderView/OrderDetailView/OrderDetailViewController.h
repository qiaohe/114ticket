//
//  OrderDetailViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-22.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"
#import "OrderCenterViewController.h"

@class TotalAmount;

@interface OrderDetailViewController : BaseUIViewController

@property (retain, nonatomic) UILabel           *orderStatus;
@property (retain, nonatomic) UILabel           *orderNum;
@property (retain, nonatomic) UILabel           *trainCode;
@property (retain, nonatomic) UILabel           *route;
@property (retain, nonatomic) UILabel           *date;
@property (retain, nonatomic) UILabel           *seatType;
@property (retain, nonatomic) UILabel           *contacts;
@property (retain, nonatomic) UILabel           *birthDay;
@property (retain, nonatomic) UILabel           *contactsNum;
@property (retain, nonatomic) UILabel           *paymentAmount;
@property (retain, nonatomic) UILabel           *payDetail;
@property (retain, nonatomic) NSMutableArray    *dataSource;
@property (retain, nonatomic) NSString          *orderPriceDetail;
@property (retain, nonatomic) UIScrollView      *scrollView;
@property (retain, nonatomic) TrainOrder        *trainOrder;
@property (retain, nonatomic) TrainCodeAndPrice *codeAndPrice;
@property (assign, nonatomic) OrderDate         superDate;
@property (assign, nonatomic) OrderStatus       superStatus;

- (id)initWithOrder:(TrainOrder*)order;
- (void)getTrainOrderDetails;

@end
