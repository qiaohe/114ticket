//
//  UpdatePasswordViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-9-10.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"

@interface UpdatePasswordViewController : BaseUIViewController<UITextFieldDelegate>

@property (retain, nonatomic) UITextField           *password;
@property (retain, nonatomic) UITextField           *newsPassword;
@property (retain, nonatomic) UITextField           *againPassword;

@end
