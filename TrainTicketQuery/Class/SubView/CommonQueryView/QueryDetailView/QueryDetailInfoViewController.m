//
//  QueryDetailInfoViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-14.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "QueryDetailInfoViewController.h"
#import "TrainTicketInfoCell.h"
#import "Model.h"
#import "UserDefaults.h"
#import "TrainCodeAndPrice.h"
#import "QueryHistory.h"
#import "CustomButton.h"
#import "PassengerInfoViewController.h"
#import "RegisterAndLogInViewController.h"
#import "OrderFillInViewController.h"
#import "Utils.h"

@interface QueryDetailInfoViewController ()

@end

@implementation QueryDetailInfoViewController

@synthesize currentDate;
@synthesize theTableView;
@synthesize dataSource;
@synthesize history;
@synthesize queryType;
@synthesize dataString;
@synthesize trainOrder;
@synthesize changeDate;
@synthesize codeAndPrice;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [currentDate        release];
    [theTableView       release];
    [dataSource         release];
    [history            release];
    if (dataString) {
        [dataString     release];
    }
    [trainOrder         release];
    [changeDate         release];
    [codeAndPrice       release];
    [super              dealloc];
}

- (id)initWithHistory:(QueryHistory*)_history
{
    if (self = [super init]) {
        self.history    = _history;
        self.changeDate = _history.startDate;
        self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
        self.dataSource = [NSMutableArray array];
        
        [self initView];
        
        theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, appFrame.size.width, appFrame.size.height - 80)];
        theTableView.dataSource = self;
        theTableView.delegate   = self;
        theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:theTableView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //[theTableView reloadData];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - tableview delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrainCodeAndPrice *_codeAndPrice = [dataSource objectAtIndex:indexPath.row];
    if (_codeAndPrice.isUnfold) {
        if ([self checkTrainTypeWithParams:_codeAndPrice.trainCode] == trainTypeHeightSpeed) {
            return TrainTicketInfoCellHeight + 60;
        }else if([self checkTrainTypeWithParams:_codeAndPrice.trainCode] == trainTypeNormalSpeed){
            return TrainTicketInfoCellHeight + 120;
        }
    }
    return TrainTicketInfoCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierStr = @"cell";
    TrainTicketInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == nil) {
        cell = [[[TrainTicketInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr]autorelease];
    }
    [cell removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [cell addTarget:self action:@selector(cellResponder:) forControlEvents:UIControlEventTouchUpInside];
    cell.indexPath = indexPath;
    TrainCodeAndPrice *_codeAndPrice = [self.dataSource objectAtIndex:indexPath.row];
    cell.trainNum.text  = _codeAndPrice.trainCode;
    cell.trainType.text = _codeAndPrice.trainType;
    cell.startCity.text = _codeAndPrice.startCity;
    cell.endCity.text   = _codeAndPrice.endCity;
    cell.startDate.text = _codeAndPrice.startTime;
    cell.endDate.text   = _codeAndPrice.endTime;      //[NSString stringWithFormat:@"%d",codeAndPrice.rz2Yp];
    [cell setUnfoldFrameWithParams:_codeAndPrice];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrainCodeAndPrice *_codeAndPrice = [dataSource objectAtIndex:indexPath.row];
    _codeAndPrice.isUnfold = _codeAndPrice.isUnfold?NO:YES;
    /*
    TrainTicketInfoCell* cell = (TrainTicketInfoCell*)[theTableView cellForRowAtIndexPath:indexPath];
    cell.detailView.hidden = codeAndPrice.isUnfold;*/
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)cellResponder:(CustomButton*)sender
{
    self.codeAndPrice = [dataSource objectAtIndex:sender.indexPath.row];
    if (trainOrder) {
        [trainOrder release];
    }
    trainOrder = [[TrainOrder alloc]init];
    trainOrder.startStation   = history.startCity;
    trainOrder.endStation     = history.endCity;
    trainOrder.trainStartTime = history.startDate;
    trainOrder.trainCode      = codeAndPrice.trainCode;
    trainOrder.orderHeadCode  = @"I";
    trainOrder.seatType       = codeAndPrice.seatType;
    trainOrder.trainStartTime = [trainOrder.trainStartTime stringByAppendingFormat:@" %@",[Utils stringWithDate:[Utils dateWithString:codeAndPrice.startTime withFormat:@"HH:mm"] withFormat:@"HH:mm:ss"] ];

    switch (sender.tag) {
        case 201:
            if ([self checkTrainTypeWithParams:codeAndPrice.trainCode] == trainTypeHeightSpeed) {
                codeAndPrice.selectSeatType = SeatTypeRZ1;
                trainOrder.seatType          = @"一等座";
                trainOrder.selectTicketPrice = [codeAndPrice.rz1 floatValue];
            }else{
                codeAndPrice.selectSeatType  = SeatTypeYZ;
                trainOrder.seatType          = @"硬座";
                trainOrder.selectTicketPrice = [codeAndPrice.yz floatValue];
            }
            break;
        case 202:
            if ([self checkTrainTypeWithParams:codeAndPrice.trainCode] == trainTypeHeightSpeed) {
                codeAndPrice.selectSeatType  = SeatTypeRZ2;
                trainOrder.seatType          = @"二等座";
                trainOrder.selectTicketPrice = [codeAndPrice.rz2 floatValue];
            }else{
                codeAndPrice.selectSeatType  = SeatTypeRZ;
                trainOrder.seatType          = @"软座";
                trainOrder.selectTicketPrice = [codeAndPrice.rz floatValue];
            }
            break;
        case 203:
            codeAndPrice.selectSeatType  = SeatTypeYW;
            trainOrder.seatType          = @"硬卧下";
            trainOrder.selectTicketPrice = [codeAndPrice.ywx floatValue];
            break;
        case 204:
            codeAndPrice.selectSeatType  = SeatTypeRW;
            trainOrder.seatType          = @"软卧上";
            trainOrder.selectTicketPrice = [codeAndPrice.rwx floatValue];
            break;
        default:
            break;
    }
    
    NSString *urlString = nil;
    
    if([self checkTrainTypeWithParams:codeAndPrice.trainCode] == trainTypeHeightSpeed){
        urlString = [NSString stringWithFormat:@"%@/getGaotieTrainCodeAndPrice",TrainOrderServiceURL];
    }else if ([self checkTrainTypeWithParams:codeAndPrice.trainCode] == trainTypeNormalSpeed){
        urlString = [NSString stringWithFormat:@"%@/getTrainCodeAndPrice",TrainOrderServiceURL];
    }
    
    NSString *dateString = [Utils stringWithDate:[Utils dateWithString:trainOrder.trainStartTime withFormat:@"yyyy-MM-dd HH:mm:ss"] withFormat:@"yyyy-MM-dd"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [codeAndPrice.startCity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],             @"fromStation",
                            [codeAndPrice.endCity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],               @"toStation",
                            codeAndPrice.trainCode,             @"trainCode",
                            dateString,                         @"godate",
                            nil];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"checkTicketStatus",          @"requestType",
                              nil];
    
    
    [self sendRequestWithURL:urlString params:params requestMethod:RequestGet userInfo:userInfo];
    
    
    
}

- (void)ticketReserve
{
    
}

#pragma mark - request handle
- (void)requestTrainDataWithType:(TrainQueryType)_type
{
    self.queryType = _type;
    NSLog(@"type = %d",_type);
    switch (_type) {
        case TrainQueryCommon:{
            [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 40, selfViewFrame.size.width, selfViewFrame.size.height - 40) belowView:nil enabled:NO];
            [self getAllTrainCodeAndPriceWithParams:history withUserInfo:nil];
            break;
        }case TrainQueryHighSpeed:{
            [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 40, selfViewFrame.size.width, selfViewFrame.size.height - 40) belowView:nil enabled:NO];
            [self getAllGaotieTrainCodeAndPriceWithParams:history withUserInfo:nil];
            break;
        }
        default:
            break;
    }
}

- (void)requestDone:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 40, selfViewFrame.size.width, selfViewFrame.size.height - 40) belowView:nil enabled:YES];
    history.startDate = self.changeDate;
    [self.currentDate setTitle:history.startDate forState:UIControlStateNormal];

    [self parserStringBegin:request];
}

- (void)parserStringFinished:(NSString *)_string request:(ASIHTTPRequest *)request
{
    NSDictionary *resultData = [_string JSONValue];
    NSLog(@"resultData = %@",resultData);
    
    if ([[resultData objectForKey:@"performStatus"] isEqualToString:@"success"]) {
        NSString *requestType = [request.userInfo objectForKey:@"requestType"];
        
        if ([requestType isEqualToString:@"checkTicketStatus"]) {
            NSDictionary *dicArray = [resultData objectForKey:@"performResult"];
            TrainCodeAndPrice *_codeAndPrice = [[[TrainCodeAndPrice alloc]init]autorelease];
            for (NSString *key in [dicArray allKeys]) {
                [_codeAndPrice setValue:[dicArray objectForKey:key] forKey:key];
            }
            
            BOOL hasTicket = NO;
            
            if (codeAndPrice.isOk == 0) {
                switch (codeAndPrice.selectSeatType) {
                    case SeatTypeYZ:
                        if (_codeAndPrice.yzOk == 0) {
                            hasTicket = YES;
                        }
                        break;
                    case SeatTypeRZ:
                        if (_codeAndPrice.yzOk == 0) {
                            hasTicket = YES;
                        }
                        break;
                    case SeatTypeYW:
                        if (_codeAndPrice.ywsOk == 0 || _codeAndPrice.ywzOk == 0 || _codeAndPrice.ywxOk == 0) {
                            hasTicket = YES;
                        }
                        break;
                    case SeatTypeRW:
                        if (_codeAndPrice.rwsOk == 0 || _codeAndPrice.rwxOk == 0) {
                            hasTicket = YES;
                        }
                        break;
                    case SeatTypeRZ1:
                        if (_codeAndPrice.rz1Ok == 0) {
                            hasTicket = YES;
                        }
                        break;
                    case SeatTypeRZ2:
                        if (_codeAndPrice.rz2Ok == 0) {
                            hasTicket = YES;
                        }
                        break;
                    default:
                        break;
                }
            }
            if (hasTicket) {
                if (![UserDefaults shareUserDefault].userId) {
                    RegisterAndLogInViewController *registerAndLog = [[[RegisterAndLogInViewController alloc]init]autorelease];
                    registerAndLog.codeAndPrice = codeAndPrice;
                    registerAndLog.trainOrder = self.trainOrder;
                    [registerAndLog.trainOrder setUserId:[[UserDefaults shareUserDefault].userId integerValue]];
                    
                    [[Model shareModel] pushView:registerAndLog options:ViewTrasitionEffectMoveLeft completion:^{
                        [[Model shareModel].viewControllers addObject:registerAndLog];
                        [[Model shareModel] showPromptBoxWithText:@"您还没有登录,请先登录" modal:YES];
                    }];
                }else{
                    OrderFillInViewController *fillInView = [[OrderFillInViewController alloc]initWithTrainOrder:trainOrder];
                    fillInView.codeAndPrice = codeAndPrice;
                    //fillInView.trainOrder = self.trainOrder;
                    fillInView.trainOrder.userId = [[UserDefaults shareUserDefault].userId integerValue];
                    [[Model shareModel] pushView:fillInView options:ViewTrasitionEffectMoveLeft completion:^{
                        [[Model shareModel].viewControllers addObject:fillInView];
                    }];
                }
            }else
                [[Model shareModel] showPromptBoxWithText:@"此票种已售完" modal:NO];
        }else{
            [self analysisResponseString:_string];
        }
    }
}

- (void)requestError:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 40, selfViewFrame.size.width, selfViewFrame.size.height - 40) belowView:nil enabled:YES];
    [[Model shareModel] showPromptBoxWithText:@"请求失败" modal:NO];
}

- (void)analysisResponseString:(NSString*)string
{
    NSDictionary *jsonDic = [string JSONValue];
    [dataSource removeAllObjects];
    NSArray *dicArray = [jsonDic objectForKey:@"performResult"];
    for (NSDictionary *object in dicArray) {
        TrainCodeAndPrice *_codeAndPrice = [[TrainCodeAndPrice alloc]init];
        for (NSString *key in [object allKeys]) {
            [_codeAndPrice setValue:[object objectForKey:key] forKey:key];
        }
        [dataSource addObject:_codeAndPrice];
        [_codeAndPrice release];
    }
    [dataSource sortedArrayUsingSelector:@selector(compare:)];
    [self reloadTableView:theTableView scrollToTop:YES];
}

#pragma mark - method achieve
- (void)pressReturnBtn:(UIButton*)sender
{
    BaseUIViewController *prevView = [[Model shareModel].viewControllers objectAtIndex:([[Model shareModel].viewControllers indexOfObject:self] - 1)];
    [[Model shareModel] pushView:prevView options:ViewTrasitionEffectMoveRight completion:^{
        [[Model shareModel].viewControllers removeObject:self];
    }];
}

- (void)pressPrevDayBtn:(UIButton*)sender
{
    NSDate *date = [self dateWithString:history.startDate];
    date = [date dateByAddingTimeInterval:-24*60*60];
    self.changeDate = [self stringWithDate:date];
    [self requestTrainDataWithType:queryType];
}

- (void)pressNextDayBtn:(UIButton*)sender
{
    NSDate *date = [self dateWithString:history.startDate];
    date = [date dateByAddingTimeInterval:24*60*60];
    self.changeDate = [self stringWithDate:date];
    [self requestTrainDataWithType:queryType];
}

#pragma mark - view init
- (void)initView
{
    UIImageView *backGroundImage = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
    [backGroundImage setImage:imageNameAndType(@"backgroundimage", @"png")];
    [self.view addSubview:backGroundImage];
    
    UIImageView *topBackGroundImage = [[[UIImageView alloc]initWithFrame:CGRectMake(0, -1, self.view.frame.size.width, 40 + 3)]autorelease];
    [topBackGroundImage setImage:imageNameAndType(@"topbar_image", @"png")];
    [self.view addSubview:topBackGroundImage];
    
    UIImageView *subjoinBackGroundImage = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 42)]autorelease];
    [subjoinBackGroundImage setImage:imageNameAndType(@"subjoinimage", @"png")];
    [self.view addSubview:subjoinBackGroundImage];
    
    [self setTopViewFrame];
    [self setSubjoinViewFrame];
}

- (void)setTopViewFrame
{
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateSelected];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(pressReturnBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    
    UILabel *titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(80, 0, 160, 40)]autorelease];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor       = [UIColor whiteColor];
    titleLabel.textAlignment   = NSTextAlignmentCenter;
    [titleLabel setText:[NSString stringWithFormat:@"%@-%@",history.startCity,history.endCity]];
    [self.view addSubview:titleLabel];
}

- (void)setSubjoinViewFrame
{
    UIButton *prevDayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    prevDayBtn.frame = CGRectMake(0, 40, 85, 40);
    prevDayBtn.bounds = CGRectMake(5, 5, 75, 35);
    [prevDayBtn addTarget:self action:@selector(pressPrevDayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [prevDayBtn setImage:imageNameAndType(@"prevday_normal", @"png") forState:UIControlStateNormal];
    [prevDayBtn setImage:imageNameAndType(@"prevday_press", @"png") forState:UIControlStateHighlighted];
    [self.view addSubview:prevDayBtn];
    
    UIButton *nextDayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextDayBtn.frame = CGRectMake(235, 40, 85, 40);
    nextDayBtn.bounds = CGRectMake(5, 5, 75, 35);
    [nextDayBtn addTarget:self action:@selector(pressNextDayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [nextDayBtn setImage:imageNameAndType(@"nextday_normal", @"png") forState:UIControlStateNormal];
    [nextDayBtn setImage:imageNameAndType(@"nextday_press", @"png") forState:UIControlStateHighlighted];
    [self.view addSubview:nextDayBtn];
    
    self.currentDate = [UIButton buttonWithType:UIButtonTypeCustom];
    currentDate.frame = CGRectMake(110, 40, 100, 40);
    currentDate.bounds = CGRectMake(10, 5, 80, 30);
    [currentDate setTitleColor:[self getColor:@"0271b8"] forState:UIControlStateNormal];
    [currentDate.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [currentDate setTitle:history.startDate forState:UIControlStateNormal];
    currentDate.backgroundColor = [UIColor clearColor];
    [self.view addSubview:currentDate];
    
    UIImageView *selectLine = [[[UIImageView alloc]initWithFrame:CGRectMake(110, 78, 100, 2)]autorelease];
    //[selectLine setImage:imageNameAndType(@"selectline", @"png")];
    [selectLine setBackgroundColor:[self getColor:@"0271b8"]];
    [self.view addSubview:selectLine];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
