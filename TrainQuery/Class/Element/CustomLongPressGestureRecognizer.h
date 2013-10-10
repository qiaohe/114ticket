//
//  CustomLongPressGestureRecognizer.h
//  369会网
//
//  Created by M J on 13-8-13.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLongPressGestureRecognizer : UILongPressGestureRecognizer

@property (assign, nonatomic) NSInteger   tag;
@property (retain, nonatomic) NSIndexPath *indexPath;

@end
