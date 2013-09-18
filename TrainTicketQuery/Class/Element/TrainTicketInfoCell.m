//
//  TrainTicketInfoCell.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-15.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "TrainTicketInfoCell.h"
#import "Model.h"
#import "CustomButton.h"

@implementation TrainTicketInfoCell

@synthesize backGroundImage;
@synthesize trainNum;
@synthesize trainType;
@synthesize startCity;
@synthesize endCity;
@synthesize startDate;
@synthesize endDate;
@synthesize unfoldButton;
@synthesize subCell;
@synthesize detailView;
@synthesize unfoldImage;
@synthesize first_class;
@synthesize second_class;
@synthesize third_class;
@synthesize fourth_class;
@synthesize indexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initView];
        
        //detailView = [[UIView alloc]init];
    }
    return self;
}

- (void)dealloc
{
    [trainNum     release];
    [trainType    release];
    [startCity    release];
    [endCity      release];
    [startDate    release];
    [endDate      release];
    [unfoldButton release];
    [unfoldImage  release];
    if (subCell) {
        [subCell  release];
    }
    [detailView   release];
    [first_class  release];
    [second_class release];
    [third_class  release];
    [fourth_class release];
    [indexPath    release];
    [super        dealloc];
}

#pragma mark - view init
- (void)initView
{
    [self setBackgroundColor:[UIColor clearColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    backGroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 80)];
    backGroundImage.bounds = CGRectMake(5, 10, 310, 60);
    [backGroundImage setImage:imageNameAndType(@"queryinfocell_normal", @"png")];
    [backGroundImage setHighlightedImage:imageNameAndType(@"queryinfocell_select", @"png")];
    [self addSubview:backGroundImage];
    
    trainNum = [[UILabel alloc]initWithFrame:CGRectMake(15, 17, 60, 25)];
    [trainNum setTextColor:[[Model shareModel] getColor:@"0271b8"]];
    [trainNum setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [trainNum setBackgroundColor:[UIColor clearColor]];
    [self addSubview:trainNum];
    
    trainType = [[UILabel alloc]initWithFrame:CGRectMake(15, 45, 60, 15)];
    [trainType setTextColor:[[Model shareModel] getColor:@"0271b8"]];
    [trainType setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [trainType setBackgroundColor:[UIColor clearColor]];
    [self addSubview:trainType];
    
    [self setTicketInfoViewFrame];
    /*
    if (self.detailView) {
        [self.detailView release];
    }*/
    
    detailView = [[UIView alloc]init];
    detailView.frame = CGRectMake(0, 70, 320, 120);
    
    first_class = [[TrainTickUnfoldCell alloc]initWithFrame:CGRectMake(0, 0, 310, 30)];
    first_class.tag = 101;
    first_class.handleButton.tag = 201;
    second_class = [[TrainTickUnfoldCell alloc]initWithFrame:CGRectMake(0, 30, 310, 30)];
    second_class.tag = 102;
    second_class.handleButton.tag = 202;
    third_class = [[TrainTickUnfoldCell alloc]initWithFrame:CGRectMake(0, 60, 310, 30)];
    third_class.tag = 103;
    third_class.handleButton.tag = 203;
    fourth_class = [[TrainTickUnfoldCell alloc]initWithFrame:CGRectMake(0, 90, 310, 30)];
    fourth_class.tag = 104;
    fourth_class.handleButton.tag = 204;
    
    [detailView addSubview:first_class];
    [detailView addSubview:second_class];
    [detailView addSubview:third_class];
    [detailView addSubview:fourth_class];
    
    [self addSubview:detailView];
}

- (void)setTicketInfoViewFrame
{
    startCity = [[UILabel alloc]initWithFrame:CGRectMake(75, 10, 60, 30)];
    [startCity setTextColor:[UIColor darkGrayColor]];
    [startCity setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [startCity setTextAlignment:NSTextAlignmentCenter];
    [startCity setBackgroundColor:[UIColor clearColor]];
    [self addSubview:startCity];
    
    endCity = [[UILabel alloc]initWithFrame:CGRectMake(205, 10, 60, 30)];
    [endCity setTextColor:[UIColor darkGrayColor]];
    [endCity setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [endCity setTextAlignment:NSTextAlignmentCenter];
    [endCity setBackgroundColor:[UIColor clearColor]];
    [self addSubview:endCity];
    
    UIImageView *destination = [[[UIImageView alloc]initWithFrame:CGRectMake(145, 18, 50, 15)]autorelease];
    [destination setImage:imageNameAndType(@"destinationarrow", @"png")];
    [destination setBackgroundColor:[UIColor clearColor]];
    [self addSubview:destination];
    
    UIImageView *startImage = [[[UIImageView alloc]initWithFrame:CGRectMake(75, 45, 15, 15)]autorelease];
    [startImage setImage:imageNameAndType(@"start", @"png")];
    [self addSubview:startImage];
    
    startDate = [[UILabel alloc]initWithFrame:CGRectMake(100, 42, 45, 20)];
    [startDate setTextColor:[UIColor darkGrayColor]];
    [startDate setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [startDate setBackgroundColor:[UIColor clearColor]];
    [self addSubview:startDate];
    
    UIImageView *endImage = [[[UIImageView alloc]initWithFrame:CGRectMake(205, 45, 15, 15)]autorelease];
    [endImage setImage:imageNameAndType(@"end", @"png")];
    [self addSubview:endImage];
    
    endDate = [[UILabel alloc]initWithFrame:CGRectMake(230, 42, 45, 20)];
    [endDate setTextColor:[UIColor darkGrayColor]];
    [endDate setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [endDate setBackgroundColor:[UIColor clearColor]];
    [self addSubview:endDate];
    
    self.unfoldButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [unfoldButton setBackgroundColor:[UIColor clearColor]];
    unfoldButton.frame = CGRectMake(275, 10, 45, 60);
    unfoldButton.bounds = CGRectMake(0, 15, 25, 35);
    unfoldButton.hidden = YES;
    unfoldButton.enabled = NO;
    [unfoldButton setImage:imageNameAndType(@"arrow_down", @"png") forState:UIControlStateNormal];
    [unfoldButton setImage:imageNameAndType(@"arrow_down", @"png") forState:UIControlStateHighlighted];
    [unfoldButton setImage:imageNameAndType(@"arrow_down", @"png") forState:UIControlStateDisabled];
    [self addSubview:unfoldButton];
    
    unfoldImage = [[UIImageView alloc]initWithFrame:unfoldButton.frame];
    unfoldImage.bounds = CGRectMake(0, 15, 25, 35);
    [unfoldImage setImage:imageNameAndType(@"arrow_down", @"png")];
    [unfoldImage setHighlightedImage:imageNameAndType(@"arrow_up", @"png")];
    [unfoldImage setBackgroundColor:[UIColor clearColor]];
    [self addSubview:unfoldImage];
}

#pragma mark - set unfold view frame
- (void)setUnfoldFrameWithParams:(TrainCodeAndPrice*)params
{
    if (params.isUnfold) {
        detailView.hidden = NO;
        [self setSelectState:YES];
        if ([TrainTicketInfoCell checkTrainTypeWithParams:params.trainCode] == trainTypeHeightSpeed) {
            [self setHeightSpeedUnfoldViewWithParams:params];
        }else if([TrainTicketInfoCell checkTrainTypeWithParams:params.trainCode] == trainTypeNormalSpeed){
            [self setNormalSpeedUnfoldViewWithParams:params];
        }
        [self setDetailviewDataWithParams:params];
    }else{
        detailView.hidden = YES;
        [self setSelectState:NO];
    }
}

+ (TrainType)checkTrainTypeWithParams:(NSString*)_type
{
    if ([_type characterAtIndex:0] == 'G' || [_type characterAtIndex:0] == 'D') {
        //NSLog(@"equal");
        return trainTypeHeightSpeed;
    }else{
        //NSLog(@"normal");
        return trainTypeNormalSpeed;
    }
}

- (void)setHeightSpeedUnfoldViewWithParams:(TrainCodeAndPrice*)params
{
    first_class.hidden = NO;
    second_class.hidden = NO;
    third_class.hidden = YES;
    fourth_class.hidden = YES;
}

- (void)setNormalSpeedUnfoldViewWithParams:(TrainCodeAndPrice*)params
{
    first_class.hidden = NO;
    second_class.hidden = NO;
    third_class.hidden = NO;
    fourth_class.hidden = NO;
}

- (void)setDetailviewDataWithParams:(TrainCodeAndPrice*)_codeAndPrice
{
    if ([TrainTicketInfoCell checkTrainTypeWithParams:_codeAndPrice.trainCode] == trainTypeHeightSpeed) {
        first_class.seatType.text  = @"一等座";
        second_class.seatType.text = @"二等座";
        
        first_class.surplusTicketNum.text = [NSString stringWithFormat:@"余票: %d",_codeAndPrice.rz1Yp];
        second_class.surplusTicketNum.text = [NSString stringWithFormat:@"余票: %d",_codeAndPrice.rz2Yp];
        
        first_class.ticketPrice.text  = [NSString stringWithFormat:@"￥ %@",_codeAndPrice.rz1];
        second_class.ticketPrice.text = [NSString stringWithFormat:@"￥ %@",_codeAndPrice.rz2];
        
        
        [self sethandleButtonState:first_class params:_codeAndPrice seatType:SeatTypeRZ1];
        [self sethandleButtonState:second_class params:_codeAndPrice seatType:SeatTypeRZ2];
    }else if([TrainTicketInfoCell checkTrainTypeWithParams:_codeAndPrice.trainCode] == trainTypeNormalSpeed){
        first_class.seatType.text = @"硬座";
        second_class.seatType.text = @"软座";
        third_class.seatType.text = @"硬卧";
        fourth_class.seatType.text = @"软卧";
        
        first_class.surplusTicketNum.text = [NSString stringWithFormat:@"余票: %d",_codeAndPrice.yzYp];
        second_class.surplusTicketNum.text = [NSString stringWithFormat:@"余票: %d",_codeAndPrice.rzYp];
        third_class.surplusTicketNum.text = [NSString stringWithFormat:@"余票: %d",_codeAndPrice.ywYp];
        fourth_class.surplusTicketNum.text = [NSString stringWithFormat:@"余票: %d",_codeAndPrice.rwYp];
        
        first_class.ticketPrice.text  = [NSString stringWithFormat:@"￥ %@",_codeAndPrice.yz];
        second_class.ticketPrice.text = [NSString stringWithFormat:@"￥ %@",_codeAndPrice.rz];
        third_class.ticketPrice.text  = [NSString stringWithFormat:@"￥ %@",_codeAndPrice.ywx];
        fourth_class.ticketPrice.text = [NSString stringWithFormat:@"￥ %@",_codeAndPrice.rwx];
        
        [self sethandleButtonState:first_class params:_codeAndPrice seatType:SeatTypeYZ];
        [self sethandleButtonState:second_class params:_codeAndPrice seatType:SeatTypeRZ];
        [self sethandleButtonState:third_class params:_codeAndPrice seatType:SeatTypeYW];
        [self sethandleButtonState:fourth_class params:_codeAndPrice seatType:SeatTypeRW];
    }
}

- (void)sethandleButtonState:(TrainTickUnfoldCell*)_seat params:(TrainCodeAndPrice*)_params seatType:(SeatType)_type
{
    _seat.handleButton.enabled = NO;
    if (_params.isOk == 0) {
        switch (_type) {
            case SeatTypeYZ:{
                if (_params.yzOk == 0) {
                    [_seat.handleButton setBackgroundImage:imageNameAndType(@"yuding", @"png") forState:UIControlStateNormal];
                    [_seat.handleButton setTitle:@"预定" forState:UIControlStateNormal];
                    _seat.handleButton.enabled = YES;
                }else{
                    [_seat.handleButton setBackgroundImage:imageNameAndType(@"wupiao", @"png") forState:UIControlStateNormal];
                    [_seat.handleButton setTitle:@"无票" forState:UIControlStateNormal];
                }
                break;
            }case SeatTypeRZ:{
                if (_params.rzOk == 0) {
                    [_seat.handleButton setBackgroundImage:imageNameAndType(@"yuding", @"png") forState:UIControlStateNormal];
                    [_seat.handleButton setTitle:@"预定" forState:UIControlStateNormal];
                    _seat.handleButton.enabled = YES;
                }else{
                    [_seat.handleButton setBackgroundImage:imageNameAndType(@"wupiao", @"png") forState:UIControlStateNormal];
                    [_seat.handleButton setTitle:@"无票" forState:UIControlStateNormal];
                }
                break;
            }case SeatTypeYW:{
                if (_params.ywsOk == 0 || _params.ywzOk == 0 || _params.ywxOk == 0) {
                    [_seat.handleButton setBackgroundImage:imageNameAndType(@"yuding", @"png") forState:UIControlStateNormal];
                    [_seat.handleButton setTitle:@"预定" forState:UIControlStateNormal];
                    _seat.handleButton.enabled = YES;
                }else{
                    [_seat.handleButton setBackgroundImage:imageNameAndType(@"wupiao", @"png") forState:UIControlStateNormal];
                    [_seat.handleButton setTitle:@"无票" forState:UIControlStateNormal];
                }
                break;
            }case SeatTypeRW:{
                if (_params.rwsOk == 0 || _params.rwxOk == 0) {
                    [_seat.handleButton setBackgroundImage:imageNameAndType(@"yuding", @"png") forState:UIControlStateNormal];
                    [_seat.handleButton setTitle:@"预定" forState:UIControlStateNormal];
                    _seat.handleButton.enabled = YES;
                }else{
                    [_seat.handleButton setBackgroundImage:imageNameAndType(@"wupiao", @"png") forState:UIControlStateNormal];
                    [_seat.handleButton setTitle:@"无票" forState:UIControlStateNormal];
                }
                break;
            }case SeatTypeRZ1:{
                if (_params.rz1Ok == 0) {
                    [_seat.handleButton setBackgroundImage:imageNameAndType(@"yuding", @"png") forState:UIControlStateNormal];
                    [_seat.handleButton setTitle:@"预定" forState:UIControlStateNormal];
                    _seat.handleButton.enabled = YES;
                }else{
                    [_seat.handleButton setBackgroundImage:imageNameAndType(@"wupiao", @"png") forState:UIControlStateNormal];
                    [_seat.handleButton setTitle:@"无票" forState:UIControlStateNormal];
                }
                break;
            }case SeatTypeRZ2:{
                if (_params.rz2Ok == 0) {
                    [_seat.handleButton setBackgroundImage:imageNameAndType(@"yuding", @"png") forState:UIControlStateNormal];
                    [_seat.handleButton setTitle:@"预定" forState:UIControlStateNormal];
                    _seat.handleButton.enabled = YES;
                }else{
                    [_seat.handleButton setBackgroundImage:imageNameAndType(@"wupiao", @"png") forState:UIControlStateNormal];
                    [_seat.handleButton setTitle:@"无票" forState:UIControlStateNormal];
                }
                break;
            }
            default:
                break;
        }
    }else{
        [_seat.handleButton setBackgroundImage:imageNameAndType(@"wupiao", @"png") forState:UIControlStateNormal];
        [_seat.handleButton setTitle:@"无票" forState:UIControlStateNormal];
    }
}

- (void)predetermineWithParams:(TrainCodeAndPrice*)codeAndPrice seatType:(SeatType)_type
{
    NSLog(@"预定");
}

- (void)setIndexPathData:(NSIndexPath*)params
{
    if (![indexPath isEqual:params]) {
        if (indexPath) {
            [indexPath release];
        }
        indexPath = [params retain];
        self.first_class.handleButton.indexPath = params;
        self.second_class.handleButton.indexPath = params;
        self.third_class.handleButton.indexPath = params;
        self.fourth_class.handleButton.indexPath = params;
    }
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.first_class.handleButton addTarget:target action:action forControlEvents:controlEvents];
    [self.second_class.handleButton addTarget:target action:action forControlEvents:controlEvents];
    [self.third_class.handleButton addTarget:target action:action forControlEvents:controlEvents];
    [self.fourth_class.handleButton addTarget:target action:action forControlEvents:controlEvents];
    
}

- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.first_class.handleButton removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.second_class.handleButton removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.third_class.handleButton removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.fourth_class.handleButton removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelectState:(BOOL)state
{
    //backGroundImage.highlighted = state;
    unfoldImage.highlighted = state;

    [first_class setSelectState:state];
    [second_class setSelectState:state];
    [third_class setSelectState:state];
    [fourth_class setSelectState:state];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    //backGroundImage.highlighted = selected;
    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    //backGroundImage.highlighted = highlighted;
}

@end
