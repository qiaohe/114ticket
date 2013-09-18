//
//  SubjoinServiceViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-22.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"

@class InSure;

@interface SubjoinServiceCell : UITableViewCell

@property (retain, nonatomic) UIImageView       *selectImageView;
@property (retain, nonatomic) UILabel           *label;

@end


@protocol SubjoinServiceViewDelegate <NSObject>

@optional
- (void)addSubjoinService:(InSure*)insure;

@end

@interface SubjoinServiceViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) id <SubjoinServiceViewDelegate> delegate;
@property (retain, nonatomic) UITableView       *theTableView;
@property (retain, nonatomic) NSMutableArray    *dataSource;

- (void)getInsureType;

@end
