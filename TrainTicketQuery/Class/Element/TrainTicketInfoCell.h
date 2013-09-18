//
//  TrainTicketInfoCell.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-15.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainTickUnfoldCell.h"
#import "BaseUIViewController.h"

@class TrainCodeAndPrice;

#define         TrainTicketInfoCellHeight         80.0f

@interface TrainTicketInfoCell : UITableViewCell

@property (retain, nonatomic) UIImageView *backGroundImage;
@property (retain, nonatomic) UILabel     *trainNum;
@property (retain, nonatomic) UILabel     *trainType;
@property (retain, nonatomic) UILabel     *startCity;
@property (retain, nonatomic) UILabel     *endCity;
@property (retain, nonatomic) UILabel     *startDate;
@property (retain, nonatomic) UILabel     *endDate;
@property (retain, nonatomic) UIButton    *unfoldButton;
@property (retain, nonatomic) UIImageView *unfoldImage;
@property (retain, nonatomic) TrainTickUnfoldCell *subCell;
@property (retain, nonatomic) UIView      *detailView;
@property (retain, nonatomic) TrainTickUnfoldCell *first_class;
@property (retain, nonatomic) TrainTickUnfoldCell *second_class;
@property (retain, nonatomic) TrainTickUnfoldCell *third_class;
@property (retain, nonatomic) TrainTickUnfoldCell *fourth_class;
@property (retain, nonatomic, setter = setIndexPathData:) NSIndexPath  *indexPath;

- (void)setUnfoldFrameWithParams:(TrainCodeAndPrice*)params;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

+ (TrainType)checkTrainTypeWithParams:(NSString*)_type;

@end
