//
//  UserInfoViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-9-10.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"

@interface UserInfoViewController : BaseUIViewController<UIAlertViewDelegate>

- (id)initWithUserId:(NSInteger)userId;

@property (retain, nonatomic) UITextField       *userName;
@property (retain, nonatomic) UITextField       *cardNum;
@property (retain, nonatomic) UITextField       *sex;
@property (retain, nonatomic) UITextField       *mailAddress;
@property (retain, nonatomic) UIButton          *updatePassword;

- (void)getUserInfo:(NSInteger)userId;

@end
