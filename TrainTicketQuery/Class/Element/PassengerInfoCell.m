//
//  PassengerInfoCell.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-19.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "PassengerInfoCell.h"
#import "BaseUIViewController.h"
#import "CustomButton.h"

@implementation PassengerInfoCell

@synthesize selectImageView;
@synthesize selectButton;
@synthesize nameLabel;
@synthesize ticketTypeLabel;
@synthesize idCardNumLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

- (void)dealloc
{
    [selectImageView release];
    [selectButton    release];
    [nameLabel       release];
    [ticketTypeLabel release];
    [idCardNumLabel  release];
    [super           dealloc];
}

- (void)initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for(id view in self.contentView.subviews)
    {
        if([view isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton*)view;
            if ([button.titleLabel.text isEqualToString: @"Delete"]) {
                [button.titleLabel setText:@"删除"];
                button.bounds = CGRectMake(-10, 0, button.frame.size.width*3/4, button.frame.size.height*3/4);
            }
        }
    }
    
    UIImageView *backImage = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, 50)]autorelease];
    [backImage setImage:imageNameAndType(@"passengerinfoimage", @"png")];
    [backImage setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:backImage];
    
    selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + 5, 20 + 2, 30, 28)];
    [selectImageView setImage:imageNameAndType(@"passengerselect_normal", @"png")];
    [selectImageView setHighlightedImage:imageNameAndType(@"passengerselect_press", @"png")];
    [selectImageView setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:selectImageView];
        
    self.selectButton = [CustomButton buttonWithType:UIButtonTypeCustom];
    selectButton.frame = CGRectMake(backImage.frame.origin.x, backImage.frame.origin.y, 40, backImage.frame.size.height);
    selectButton.adjustsImageWhenHighlighted = NO;
    selectButton.backgroundColor = [UIColor clearColor];
    
        
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(selectButton.frame.origin.x + selectButton.frame.size.width + 10, backImage.frame.origin.y, (backImage.frame.size.width - (selectButton.frame.origin.x + selectButton.frame.size.width + 10))/2, backImage.frame.size.height/2)];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [nameLabel setTextColor:[UIColor darkGrayColor]];
    [self.contentView addSubview:nameLabel];
    
    ticketTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width, nameLabel.frame.origin.y, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    [ticketTypeLabel setBackgroundColor:[UIColor clearColor]];
    [ticketTypeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [ticketTypeLabel setTextColor:[UIColor darkGrayColor]];
    [self.contentView addSubview:ticketTypeLabel];
    
    idCardNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y + nameLabel.frame.size.height, backImage.frame.size.width - nameLabel.frame.origin.x, nameLabel.frame.size.height)];
    [idCardNumLabel setBackgroundColor:[UIColor clearColor]];
    [idCardNumLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:10]];
    [idCardNumLabel setTextColor:[UIColor darkGrayColor]];
    [self.contentView addSubview:idCardNumLabel];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setFrame:CGRectMake(0, 0, 35, 60)];
    [deleteButton setCenter:CGPointMake(self.frame.size.width - deleteButton.frame.size.width/2 - 20, self.frame.size.height/2)];
    [deleteButton setBackgroundColor:[UIColor darkGrayColor]];
    
    //self.accessoryView = deleteButton;
}

- (void)pressSelectButton:(CustomButton*)sender
{
    self.selectImageView.highlighted = self.selectImageView.highlighted?NO:YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
}

@end
