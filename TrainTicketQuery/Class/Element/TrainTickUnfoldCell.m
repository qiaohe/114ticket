//
//  TrainTickUnfoldCell.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-15.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "TrainTickUnfoldCell.h"
#import "Model.h"
#import "CustomButton.h"

@implementation TrainTickUnfoldCell

@synthesize seatType;
@synthesize surplusTicketNum;
@synthesize ticketPrice;
@synthesize handleButton;
@synthesize backImageView;

- (void)dealloc
{
    [seatType         release];
    [surplusTicketNum release];
    [ticketPrice      release];
    [handleButton     release];
    [backImageView    release];
    [super            dealloc];
}

//- (id)initWithFrame:(CGRect)frame

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

#pragma mark - view init
- (void)initView
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 310, TrainTickUnfoldCellHeight)];
    [backImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"queryinfocell_normal" ofType:@"png"]]];
    [backImageView setHighlightedImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"queryinfocell_select" ofType:@"png"]]];
    [self addSubview:backImageView];
    
    seatType = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 70, 20)];
    //[seatType setText:@"二等座"];
    [seatType setBackgroundColor:[UIColor clearColor]];
    [seatType setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [self addSubview:seatType];
    
    surplusTicketNum = [[UILabel alloc]initWithFrame:CGRectMake(85, 5, 100, 20)];
    //[surplusTicketNum setText:@"余票：168"];
    [surplusTicketNum setBackgroundColor:[UIColor clearColor]];
    [surplusTicketNum setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [self addSubview:surplusTicketNum];
    
    ticketPrice = [[UILabel alloc]initWithFrame:CGRectMake(185, 5, 60, 20)];
    [ticketPrice setTextColor:[[Model shareModel] getColor:@"ff6c00"]];
    //[ticketPrice setText:@"555"];
    [ticketPrice setBackgroundColor:[UIColor clearColor]];
    [ticketPrice setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [self addSubview:ticketPrice];
    
    self.handleButton = [CustomButton buttonWithType:UIButtonTypeCustom];
    self.handleButton.frame = CGRectMake(250, 0, 70, 30);
    handleButton.bounds = CGRectMake(25, 5, 45, 20);
    [handleButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [handleButton setBackgroundColor:[UIColor clearColor]];
    [self addSubview:handleButton];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //cut off touch handle
}

- (void)setSelectState:(BOOL)state
{
    backImageView.highlighted = state;
}

@end
