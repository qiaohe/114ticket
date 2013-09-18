//
//  OrderDetailCell.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-19.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "OrderDetailCell.h"
#import "BaseUIViewController.h"
#import "CustomButton.h"

@implementation OrderDetailCell

@synthesize detailView;
@synthesize orderCode;
@synthesize routeLabel;
@synthesize scheduleLabel;
@synthesize totalPrice;
@synthesize reserveDate;
@synthesize waitForPay;
@synthesize waitForPayImage;
@synthesize isUnfold;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.isUnfold = NO;
        [self initView];
    }
    return self;
}

- (void)dealloc
{
    [detailView      release];
    [orderCode       release];
    [routeLabel      release];
    [scheduleLabel   release];
    [totalPrice      release];
    [reserveDate     release];
    [waitForPay      release];
    [waitForPayImage release];
    [super           dealloc];
}

#pragma mark - view init
- (void)initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *backImage = [[[UIImageView alloc]initWithFrame:CGRectMake(15, 0, appFrame.size.width - 30, 39)]autorelease];
    [backImage setImage:imageNameAndType(@"ordertitle_backimage", @"png")];
    [self.contentView addSubview:backImage];
    
    detailView = [[[UIImageView alloc]initWithFrame:CGRectMake(backImage.frame.origin.x, backImage.frame.origin.y + backImage.frame.size.height - 4, backImage.frame.size.width, 120 + 4)]autorelease];
    [detailView setImage:imageNameAndType(@"queryinfocell_normal", @"png")];
    [detailView setImage:imageNameAndType(@"queryinfocell_normal", @"png")];
    [detailView setBackgroundColor:[UIColor clearColor]];
    
    waitForPayImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, detailView.frame.size.width, detailView.frame.size.height)];
    [waitForPayImage setImage:imageNameAndType(@"orderarrow", @"png")];
    [waitForPayImage setHighlightedImage:imageNameAndType(@"orderarrow", @"png")];
    [self.detailView addSubview:waitForPayImage];
    
    orderCode = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, appFrame.size.width - 30, 40)];
    orderCode.bounds = CGRectMake(15, 0, orderCode.frame.size.width - 15, orderCode.frame.size.height);
    [orderCode setBackgroundColor:[UIColor clearColor]];
    [orderCode setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    //[orderCode setText:@"订单号：321654987654312645987"];
    [orderCode setTextColor:[UIColor blackColor]];
    [self.contentView addSubview:orderCode];
    
    routeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, orderCode.frame.origin.y, (backImage.frame.size.width - 10)*2/3, 30)];
    //[routeLabel setText:@"行程：上海虹桥-北京南\tG102"];
    routeLabel.bounds = CGRectMake(10, 0, routeLabel.frame.size.width, routeLabel.frame.size.height);
    [routeLabel setBackgroundColor:[UIColor clearColor]];
    [routeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [routeLabel setTextColor:[UIColor darkGrayColor]];
    [self.detailView addSubview:routeLabel];
    
    scheduleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, routeLabel.frame.origin.y + 30, routeLabel.frame.size.width, routeLabel.frame.size.height)];
    scheduleLabel.bounds = routeLabel.bounds;
    //[scheduleLabel setText:@"日期：2013-08-22"];
    [scheduleLabel setBackgroundColor:[UIColor clearColor]];
    [scheduleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [scheduleLabel setTextColor:[UIColor darkGrayColor]];
    [self.detailView addSubview:scheduleLabel];
    
    totalPrice = [[UILabel alloc]initWithFrame:CGRectMake(20, scheduleLabel.frame.origin.y + 30, routeLabel.frame.size.width, routeLabel.frame.size.height)];
    totalPrice.bounds = routeLabel.bounds;
    //[totalPrice setText:@"总价：333.3元"];
    [totalPrice setBackgroundColor:[UIColor clearColor]];
    [totalPrice setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [totalPrice setTextColor:[UIColor darkGrayColor]];
    [self.detailView addSubview:totalPrice];
    
    reserveDate = [[UILabel alloc]initWithFrame:CGRectMake(20, totalPrice.frame.origin.y + 30, routeLabel.frame.size.width, routeLabel.frame.size.height)];
    reserveDate.bounds = routeLabel.bounds;
    //[reserveDate setText:@"下单时间：2013-08-20\t15:30"];
    [reserveDate setBackgroundColor:[UIColor clearColor]];
    [reserveDate setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [reserveDate setTextColor:[UIColor darkGrayColor]];
    [self.detailView addSubview:reserveDate];
    
    [self.contentView addSubview:detailView];

    
    
    self.waitForPay = [CustomButton buttonWithType:UIButtonTypeCustom];
    waitForPay.frame = CGRectMake(0, 0, detailView.frame.size.width/3, detailView.frame.size.height);
    waitForPay.center = CGPointMake(waitForPay.frame.size.width/2 + routeLabel.frame.origin.x + routeLabel.frame.size.width, detailView.frame.size.height/2 + backImage.frame.origin.y + backImage.frame.size.height);
    //[waitForPay setTitle:@"等待支付" forState:UIControlStateNormal];
    waitForPay.contentEdgeInsets = UIEdgeInsetsMake( 0, 0, 18, 10);
    [waitForPay.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [waitForPay setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
   

    self.detailView.hidden = YES;
}

- (void)resetViewFrameWithUnfold:(BOOL)unfold
{
    self.detailView.hidden = !unfold;
    detailView.highlighted = !unfold;
    
    if (unfold) {
        if (waitForPay.superview) {
            [waitForPay removeFromSuperview];
        }
        [self.contentView addSubview:waitForPay];
    }else if(!unfold){
        if (waitForPay.superview) {
            [waitForPay removeFromSuperview];
        }
    }
}

- (void) setButtonStatusWithInfo:(TrainOrder*)order
{
    switch (order.orderStatus) {
        case 1://未付款
            [waitForPay setTitle:@"前往支付" forState:UIControlStateNormal];
            break;
        case 2://已付款
            [waitForPay setTitle:@"查看订单" forState:UIControlStateNormal];
            break;
        case 4://票款不足
            [waitForPay setTitle:@"前往支付" forState:UIControlStateNormal];
            break;
        case 5://网上待付
            [waitForPay setTitle:@"前往支付" forState:UIControlStateNormal];
            break;
        case 6://无票
            [waitForPay setTitle:@"查看订单" forState:UIControlStateNormal];
            break;
        case 7://已补款
            [waitForPay setTitle:@"查看订单" forState:UIControlStateNormal];
            break;
        case 10://出票成功
            [waitForPay setTitle:@"退票" forState:UIControlStateNormal];
            break;
        case 11://申请退票
            [waitForPay setTitle:@"查看订单" forState:UIControlStateNormal];
            break;
        case 12://退票完成
            [waitForPay setTitle:@"查看订单" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
