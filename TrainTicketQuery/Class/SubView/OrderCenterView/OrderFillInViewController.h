//
//  OrderFillInViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-9-2.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "SubjoinServiceViewController.h"
#import "PassengerInfoViewController.h"

@class TotalAmount;

@interface OrderFillInViewController : BaseUIViewController<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,SubjoinServiceViewDelegate,PassengerInfoViewDelegate,SubjoinServiceViewDelegate>

@property (retain, nonatomic) TrainCodeAndPrice *codeAndPrice;
@property (retain, nonatomic) TrainOrder        *trainOrder;
@property (retain, nonatomic) TotalAmount       *amount;
@property (retain, nonatomic) UILabel           *startTime;
@property (retain, nonatomic) UILabel           *trainCode;
@property (retain, nonatomic) UILabel           *seatTypeAndPrice;
@property (retain, nonatomic) NSMutableArray    *passengerNames;
@property (retain, nonatomic) UILabel           *passengers;
@property (retain, nonatomic) UITextField       *contactName;
@property (retain, nonatomic) UITextField       *contactNum;
@property (retain, nonatomic) InSure            *selectedInsure;

- (id)initWithTrainOrder:(TrainOrder*)order;

@end
