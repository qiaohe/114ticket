//
//  FreeRegisterViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-21.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"

#define         baseYValue      40.0f

@interface FreeRegisterViewController : BaseUIViewController

@property (retain, nonatomic) UITextField *userName;
@property (retain, nonatomic) UITextField *passWord;
@property (retain, nonatomic) UITextField *againPassWord;
@property (retain, nonatomic) UITextView  *textView;
@property (retain, nonatomic) NSMutableString *performResult;

@end
