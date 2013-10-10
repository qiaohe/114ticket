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
@synthesize longPressGesture;


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
    [selectImageView     release];
    if (selectButton) {
        [selectButton        release];
    }
    [nameLabel           release];
    [ticketTypeLabel     release];
    [idCardNumLabel      release];
    [longPressGesture    release];
    [super               dealloc];
}

- (void)initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    UIImageView *backImage = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, 50)]autorelease];
    [backImage setImage:imageNameAndType(@"passengerinfoimage", @"png")];
    [backImage setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:backImage];
    
    selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + 5, 20 + 2, 30, 28)];
    [selectImageView setImage:imageNameAndType(@"passengerselect_normal", @"png")];
    [selectImageView setHighlightedImage:imageNameAndType(@"passengerselect_press", @"png")];
    [selectImageView setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:selectImageView];
    /*
    self.selectButton = [CustomButton buttonWithType:UIButtonTypeCustom];
    selectButton.frame = CGRectMake(backImage.frame.origin.x + 5, backImage.frame.origin.y, 40, backImage.frame.size.height);
    selectButton.adjustsImageWhenHighlighted = NO;
    selectButton.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:selectButton];*/
        
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(selectImageView.frame.origin.x + selectImageView.frame.size.width + 10, backImage.frame.origin.y, (backImage.frame.size.width - (selectImageView.frame.origin.x + selectImageView.frame.size.width + 10))/2, backImage.frame.size.height/2)];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [nameLabel setTextColor:[UIColor darkGrayColor]];
    [self.contentView addSubview:nameLabel];
    /*
    ticketTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width, nameLabel.frame.origin.y, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    [ticketTypeLabel setBackgroundColor:[UIColor clearColor]];
    [ticketTypeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [ticketTypeLabel setTextColor:[UIColor darkGrayColor]];
    [self.contentView addSubview:ticketTypeLabel];*/
    
    idCardNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y + nameLabel.frame.size.height, backImage.frame.size.width - nameLabel.frame.origin.x, nameLabel.frame.size.height)];
    [idCardNumLabel setBackgroundColor:[UIColor clearColor]];
    [idCardNumLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:10]];
    [idCardNumLabel setTextColor:[UIColor darkGrayColor]];
    [self.contentView addSubview:idCardNumLabel];
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
