//
//  AddNewContactsViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-20.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"
#import "PassengerInfo.h"
#import "TicketManViewController.h"
#import "TicketChildrenViewController.h"

@protocol AddNewContactsDelegate <NSObject>

@optional
- (void)reloadData;

@end

@interface AddNewContactsViewController : BaseUIViewController<TicketManViewDelegate,TicketChildrenDelegate,UITextFieldDelegate>

@property (assign, nonatomic) id <AddNewContactsDelegate>  delegate;
@property (retain, nonatomic) UITextField  *passengerName;
@property (retain, nonatomic) PassengerInfo *passenger;
@property (retain, nonatomic) TicketManViewController *ticketManView;
@property (retain, nonatomic) TicketChildrenViewController *ticketChildrenView;

- (void)showDetailViewWithTciketType:(TrainTicketType)type;

@end
