//
//  PassengerInfoViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-19.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"
#import "AddNewContactsViewController.h"

@protocol PassengerInfoViewDelegate <NSObject>

@optional
- (void)addPassengers:(NSArray*)passengersArray;

@end

@interface PassengerInfoViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate,AddNewContactsDelegate>

@property (assign, nonatomic) id <PassengerInfoViewDelegate> delegate;
@property (retain, nonatomic) UITableView               *theTableView;
@property (retain, nonatomic) NSMutableArray            *dataSource;
@property (retain, nonatomic) NSMutableArray            *selectPassengers;
@property (retain, nonatomic) TrainCodeAndPrice         *codeAndPrice;
@property (retain, nonatomic) TrainOrder                *trainOrder;

- (void)getPassengers;

- (id)initWithCodeAndPrice:(TrainCodeAndPrice*)_codeAndPrice;

@end
