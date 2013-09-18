//
//  QueryHistoryCell.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-13.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "QueryHistoryCell.h"
#import "CustomButton.h"

@implementation QueryHistoryCell

@synthesize cityLabel;
@synthesize dateLabel;
@synthesize deleteButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initSubView];
    }
    return self;
}

- (void)dealloc
{
    [cityLabel    release];
    [dateLabel    release];
    [deleteButton release];
    [super        dealloc];
}

- (void)initSubView
{
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, 30)];
    cityLabel.backgroundColor = [UIColor clearColor];
    [cityLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [self.contentView addSubview:cityLabel];
    
    dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 0, 120, 30)];
    dateLabel.backgroundColor = [UIColor clearColor];
    [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [self.contentView addSubview:dateLabel];
    
    self.deleteButton = [CustomButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(270, 3, 38, 25);
    [deleteButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"delete_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [deleteButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"delete_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [self.contentView addSubview:deleteButton];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
