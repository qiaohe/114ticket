//
//  CustomLongPressGestureRecognizer.m
//  369会网
//
//  Created by M J on 13-8-13.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import "CustomLongPressGestureRecognizer.h"

@implementation CustomLongPressGestureRecognizer

@synthesize tag;
@synthesize indexPath;

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    if (indexPath) {
        [indexPath release];
    }
    [super     dealloc];
}

@end
