//
//  OrderDetailCell.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-19.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <UIKit/UIKit.h>

#define         OrderDetailCellHeight       40.0f

@class CustomButton;
@class TrainOrder;

@interface OrderDetailCell : UITableViewCell

@property (retain, nonatomic) UIImageView   *detailView;
@property (retain, nonatomic) UILabel       *orderCode;
@property (retain, nonatomic) UILabel       *routeLabel;
@property (retain, nonatomic) UILabel       *scheduleLabel;
@property (retain, nonatomic) UILabel       *totalPrice;
@property (retain, nonatomic) UILabel       *reserveDate;
@property (retain, nonatomic) CustomButton  *waitForPay;
@property (retain, nonatomic) UIImageView   *waitForPayImage;
@property (assign, nonatomic) BOOL          isUnfold;

- (void)resetViewFrameWithUnfold:(BOOL)unfold;
- (void) setButtonStatusWithInfo:(TrainOrder*)order;

@end
