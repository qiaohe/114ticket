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
#import "Model.h"

@implementation OrderDetailCell

@synthesize detailView;
@synthesize orderCode;
@synthesize orderStatus;
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
    [orderStatus     release];
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
    
    UIImageView *backImage = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, appFrame.size.width - 30, 39)]autorelease];
    [backImage setImage:imageNameAndType(@"ordertitle_backimage", @"png")];
    [self.contentView addSubview:backImage];
    
    detailView = [[UIImageView alloc]initWithFrame:CGRectMake(backImage.frame.origin.x, backImage.frame.origin.y + backImage.frame.size.height - 4, backImage.frame.size.width, 110)];
    [detailView setImage:imageNameAndType(@"queryinfocell_normal", @"png")];
    [detailView setImage:imageNameAndType(@"queryinfocell_normal", @"png")];
    [detailView setBackgroundColor:[UIColor clearColor]];
    
    waitForPayImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 - 2.50f, detailView.frame.size.width, detailView.frame.size.height)];
    [waitForPayImage setImage:imageNameAndType(@"orderarrow", @"png")];
    [waitForPayImage setHighlightedImage:imageNameAndType(@"orderarrow", @"png")];
    [self.detailView addSubview:waitForPayImage];
    
    orderCode = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, appFrame.size.width - 40 - 90, 40)];
    orderCode.bounds = CGRectMake(10, 0, orderCode.frame.size.width - 15, orderCode.frame.size.height);
    [orderCode setBackgroundColor:[UIColor clearColor]];
    [orderCode setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    orderCode.adjustsFontSizeToFitWidth = YES;
    orderCode.adjustsLetterSpacingToFitWidth = YES;
    orderCode.baselineAdjustment = UIBaselineAdjustmentNone;
    orderCode.minimumScaleFactor = 0.5;
    //[orderCode setText:@"订单号：321654987654312645987"];
    [orderCode setTextColor:[UIColor blackColor]];
    [self.contentView addSubview:orderCode];
    
    orderStatus = [[UILabel alloc]initWithFrame:CGRectMake(orderCode.frame.origin.x + orderCode.frame.size.width + 5, orderCode.frame.origin.y, backImage.frame.size.width - orderCode.frame.origin.x - orderCode.frame.size.width - 5 - 20 - 5, orderCode.frame.size.height)];
    [orderStatus setBackgroundColor:[UIColor clearColor]];
    [orderStatus setTextAlignment:NSTextAlignmentRight];
    orderStatus.adjustsFontSizeToFitWidth = YES;
    orderStatus.adjustsLetterSpacingToFitWidth = YES;
    orderStatus.baselineAdjustment = UIBaselineAdjustmentNone;
    orderStatus.minimumScaleFactor = 0.75;
    [orderStatus setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [orderStatus setTextColor:[[Model shareModel] getColor:@"ff6c00"]];
    [self.contentView addSubview:orderStatus];
    
    routeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0 + 5, (backImage.frame.size.width - 10)*2/3, 25)];
    //[routeLabel setText:@"行程：上海虹桥-北京南\tG102"];
    routeLabel.bounds = CGRectMake(10, 0, routeLabel.frame.size.width, routeLabel.frame.size.height);
    [routeLabel setBackgroundColor:[UIColor clearColor]];
    [routeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [routeLabel setTextColor:[UIColor darkGrayColor]];
    [self.detailView addSubview:routeLabel];
    
    scheduleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, routeLabel.frame.origin.y + routeLabel.frame.size.height, routeLabel.frame.size.width, routeLabel.frame.size.height)];
    scheduleLabel.bounds = routeLabel.bounds;
    //[scheduleLabel setText:@"日期：2013-08-22"];
    [scheduleLabel setBackgroundColor:[UIColor clearColor]];
    [scheduleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [scheduleLabel setTextColor:[UIColor darkGrayColor]];
    [self.detailView addSubview:scheduleLabel];
    
    totalPrice = [[UILabel alloc]initWithFrame:CGRectMake(20, scheduleLabel.frame.origin.y + routeLabel.frame.size.height, routeLabel.frame.size.width, routeLabel.frame.size.height)];
    totalPrice.bounds = routeLabel.bounds;
    //[totalPrice setText:@"总价：333.3元"];
    [totalPrice setBackgroundColor:[UIColor clearColor]];
    [totalPrice setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [totalPrice setTextColor:[UIColor darkGrayColor]];
    [self.detailView addSubview:totalPrice];
    
    reserveDate = [[UILabel alloc]initWithFrame:CGRectMake(20, totalPrice.frame.origin.y + routeLabel.frame.size.height, routeLabel.frame.size.width, routeLabel.frame.size.height)];
    reserveDate.bounds = routeLabel.bounds;
    //[reserveDate setText:@"下单时间：2013-08-20\t15:30"];
    [reserveDate setBackgroundColor:[UIColor clearColor]];
    [reserveDate setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [reserveDate setTextColor:[UIColor darkGrayColor]];
    [self.detailView addSubview:reserveDate];
    
    [self.contentView addSubview:detailView];

    
    
    self.waitForPay = [CustomButton buttonWithType:UIButtonTypeCustom];
    waitForPay.frame = CGRectMake(0, 0, detailView.frame.size.width/3, detailView.frame.size.height);
    waitForPay.center = CGPointMake(waitForPay.frame.size.width/2 + routeLabel.frame.origin.x + routeLabel.frame.size.width - 5.0f, detailView.frame.size.height/2 + backImage.frame.origin.y + backImage.frame.size.height);
    //[waitForPay setTitle:@"等待支付" forState:UIControlStateNormal];
    waitForPay.contentEdgeInsets = UIEdgeInsetsMake( 0, 0, 18, 10);
    [waitForPay.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [waitForPay.titleLabel setTextAlignment:NSTextAlignmentLeft];
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
    NSString *titleStatus = nil;
    switch (order.orderStatus) {
        case 1://未付款
            titleStatus = @"未付款";
            break;
        case 2://已付款
            titleStatus = @"已付款";
            break;
        case 4://票款不足
            titleStatus = @"票款不足";
            break;
        case 5://网上待付
            titleStatus = @"网上待付";
            break;
        case 6://无票
            titleStatus = @"无票";
            break;
        case 7://已补款
            titleStatus = @"已补款";
            break;
        case 10://出票成功
            titleStatus = @"出票成功";
            break;
        case 11://申请退票
            titleStatus = @"申请退票";
            break;
        case 12://退票完成
            titleStatus = @"退票完成";
            break;
            
        default:
            titleStatus = @"";
            break;
    }
    [waitForPay setTitle:titleStatus forState:UIControlStateNormal];
    [orderStatus setText:titleStatus];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
