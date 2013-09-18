//
//  PassengerInfoCell.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-19.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CustomButton;

@interface PassengerInfoCell : UITableViewCell

@property (retain, nonatomic) UIImageView  *selectImageView;
@property (retain, nonatomic) CustomButton *selectButton;
@property (retain, nonatomic) UILabel      *nameLabel;
@property (retain, nonatomic) UILabel      *ticketTypeLabel;
@property (retain, nonatomic) UILabel      *idCardNumLabel;

@end
