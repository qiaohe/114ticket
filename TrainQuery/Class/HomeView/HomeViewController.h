//
//  HomeViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-11.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"
#import "RegisterAndLogInViewController.h"

@interface HomeViewController : BaseUIViewController<UIScrollViewDelegate,RegisterAndLogInViewDelegate>

@property (retain, nonatomic) UIScrollView *topShowView;
@property (retain, nonatomic) UIButton     *trainQuery;
@property (retain, nonatomic) UIButton     *bulletTrainQuery;
@property (retain, nonatomic) UIButton     *about;
@property (retain, nonatomic) UIButton     *orderCenter;

@end
