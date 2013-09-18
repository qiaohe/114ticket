//
//  CustomButton.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-16.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

@synthesize indexPath;
@synthesize completionHandler;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [indexPath              release];
    if (completionHandler) {
        //[completionHandler  release];
    }
    
    [super                  dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
