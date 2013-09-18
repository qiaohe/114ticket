//
//  CustomButton.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-16.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton

@property (retain, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic) void (^completionHandler) (void);

@end
