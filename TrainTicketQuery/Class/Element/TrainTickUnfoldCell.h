//
//  TrainTickUnfoldCell.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-15.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomButton;

#define         TrainTickUnfoldCellHeight         30.0f

@interface TrainTickUnfoldCell : UIView

@property (retain, nonatomic) UILabel  *seatType;
@property (retain, nonatomic) UILabel  *surplusTicketNum;
@property (retain, nonatomic) UILabel  *ticketPrice;
@property (retain, nonatomic) CustomButton *handleButton;
@property (retain, nonatomic) UIImageView *backImageView;

- (void)setSelectState:(BOOL)state;

@end
