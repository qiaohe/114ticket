//
//  QueryHistoryCell.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-13.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomButton;

@interface QueryHistoryCell : UITableViewCell

@property (retain, nonatomic) UILabel      *cityLabel;
@property (retain, nonatomic) UILabel      *dateLabel;
@property (retain, nonatomic) CustomButton *deleteButton;

@end
