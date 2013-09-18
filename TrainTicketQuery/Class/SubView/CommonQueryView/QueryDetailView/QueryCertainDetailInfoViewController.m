//
//  QueryCertainDetailInfoViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-17.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "QueryCertainDetailInfoViewController.h"
#import "Model.h"

@interface TrainStationTimetable ()

@end

@implementation TrainStationTimetable

@synthesize dzTime;
@synthesize fcTime;
@synthesize stayTime;
@synthesize trainStation;
@synthesize zhanci;

- (void)dealloc
{
    [dzTime          release];
    [fcTime          release];
    [stayTime        release];
    [trainStation    release];
    [super           dealloc];
}

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        dzTime       = [[data objectForKey:@"dzTime"] retain];
        fcTime       = [[data objectForKey:@"fcTime"] retain];
        stayTime     = [[data objectForKey:@"stayTime"] retain];
        trainStation = [[data objectForKey:@"trainStation"] retain];
        zhanci       = [[data objectForKey:@"zhanci"] integerValue];
    }
    return self;
}

+ (NSMutableArray*)getDataSourceWithData:(NSArray*)data
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in data) {
        TrainStationTimetable *timetable = [[[TrainStationTimetable alloc]initWithData:dic]autorelease];
        [array addObject:timetable];
    }
    return array;
}

- (NSComparisonResult)compare:(TrainStationTimetable*)params
{
    return [[NSNumber numberWithInteger:zhanci] compare:[NSNumber numberWithInteger:params.zhanci]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\ntrainStation = %@\ndzTime = %@\nfcTime = %@\nstatyTime = %@\nzhanci = %d",trainStation,dzTime,fcTime,stayTime,zhanci];
}

@end

@interface QueryCertainDetailInfoViewController ()

@end

@implementation QueryCertainDetailInfoViewController

@synthesize theTableView;
@synthesize dataSource;
@synthesize history;
@synthesize queryType;
@synthesize distanceLabel;
@synthesize costTimeLabel;
@synthesize startCityLabel;
@synthesize endCityLabel;
@synthesize startDateLabel;
@synthesize endDateLabel;
@synthesize trainCodeLabel;

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
    [theTableView  release];
    [dataSource    release];
    [history       release];
    [distanceLabel  release];
    [costTimeLabel  release];
    [startCityLabel release];
    [endCityLabel   release];
    [startDateLabel release];
    [endDateLabel   release];
    [trainCodeLabel release];
    [super        dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
        self.dataSource = [NSMutableArray array];
        [self initView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mrak - view init
- (void)initView
{
    [self setTopView];
    [self setDetailViewFrame];
    [self setTrainInfoFrame];
}

- (void)setTopView
{
    UIImageView *backImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
    [backImageView setImage:imageNameAndType(@"backgroundimage", @"png")];
    [self.view addSubview:backImageView];
    
    UIImageView *topImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, -1, self.view.frame.size.width, 40 + 1)]autorelease];
    [topImageView setImage:imageNameAndType(@"topbar_image", @"png")];
    [self.view addSubview:topImageView];
    
    UILabel *titleLabel = [self getLabelWithFrame:CGRectMake(80, 0, 160, 40) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] title:@"车次详情" font:nil];
    [self.view addSubview:titleLabel];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateSelected];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(pressReturnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
}

- (void)setDetailViewFrame
{
    self.distanceLabel = [self getLabelWithFrame:CGRectMake(15, 40, 120, 30) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [self.view addSubview:distanceLabel];
    
    CGRect costTimeFrame = CGRectMake(distanceLabel.frame.origin.x + distanceLabel.frame.size.width, distanceLabel.frame.origin.y, distanceLabel.frame.size.width, distanceLabel.frame.size.height);
    self.costTimeLabel = [self getLabelWithFrame:costTimeFrame textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [self.view addSubview:costTimeLabel];
}

- (void)setTrainInfoFrame
{
    UIImageView *trainInfoImage = [[[UIImageView alloc]initWithFrame:CGRectMake(15, 40 + 30, selfViewFrame.size.width - 30, 115)]autorelease];
    [trainInfoImage setImage:imageNameAndType(@"detailbackimage", @"png")];
    [self.view addSubview:trainInfoImage];
    
    UIImageView *imageView1 = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 35, 35)]autorelease];
    imageView1.bounds = CGRectMake(7, 5, 20, 20);
    [imageView1 setImage:imageNameAndType(@"cityimage", @"png")];
    [trainInfoImage addSubview:imageView1];
    
    UILabel *start = [self getLabelWithFrame:CGRectMake(imageView1.frame.origin.x + imageView1.frame.size.width + 10, imageView1.frame.origin.y, trainInfoImage.frame.size.width/2 - (imageView1.frame.origin.x + imageView1.frame.size.width) - 10, imageView1.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:[UIColor grayColor] title:@"出发城市" font:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    [trainInfoImage addSubview:start];
    
    UIImageView *imageView2 = [[[UIImageView alloc]initWithFrame:CGRectMake(trainInfoImage.frame.size.width - start.frame.origin.x - start.frame.size.width + 20, imageView1.frame.origin.y, imageView1.frame.size.width, imageView1.frame.size.height)]autorelease];
    imageView2.bounds = CGRectMake(7, 5, 20, 20);
    [imageView2 setImage:imageNameAndType(@"cityimage", @"png")];
    [trainInfoImage addSubview:imageView2];
    
    UILabel *end = [self getLabelWithFrame:CGRectMake(imageView2.frame.origin.x + imageView2.frame.size.width + 10, start.frame.origin.y, start.frame.size.width, start.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:[UIColor grayColor] title:@"到达城市" font:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    [trainInfoImage addSubview:end];
    
    self.startCityLabel = [self getLabelWithFrame:CGRectMake(0, start.frame.origin.y + start.frame.size.height, 105, 55) textAlignment:NSTextAlignmentRight backGroundColor:[UIColor clearColor] textColor:nil title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [trainInfoImage addSubview:startCityLabel];
    
    self.endCityLabel = [self getLabelWithFrame:CGRectMake(trainInfoImage.frame.size.width - startCityLabel.frame.origin.x - startCityLabel.frame.size.width, startCityLabel.frame.origin.y, startCityLabel.frame.size.width, startCityLabel.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [trainInfoImage addSubview:endCityLabel];
    
    UIImageView *arrowImage = [self getImageViewWithFrame:CGRectMake(startCityLabel.frame.origin.x + startCityLabel.frame.size.width + 5, startCityLabel.frame.size.height/2 + startCityLabel.frame.origin.y - 7, 70, 15) image:imageNameAndType(@"destinationarrow", @"png") highLightImage:nil backGroundColor:[UIColor clearColor]];
    [trainInfoImage addSubview:arrowImage];
    
    self.trainCodeLabel = [self getLabelWithFrame:CGRectMake(arrowImage.frame.origin.x, arrowImage.frame.origin.y - arrowImage.frame.size.height/2 - 5, arrowImage.frame.size.width, arrowImage.frame.size.height) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:[self getColor:@"ff6c00"] title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [trainInfoImage addSubview:trainCodeLabel];
    
    UIImageView *startImage = [self getImageViewWithFrame:CGRectMake(startCityLabel.frame.origin.x + 10, startCityLabel.frame.origin.y + startCityLabel.frame.size.height, 15, 15) image:imageNameAndType(@"start", @"png") highLightImage:nil backGroundColor:[UIColor clearColor]];
    [trainInfoImage addSubview:startImage];
    
    self.startDateLabel = [self getLabelWithFrame:CGRectMake(startImage.frame.origin.x + startImage.frame.size.width, startImage.frame.origin.y, startCityLabel.frame.size.width - startImage.frame.size.width - 10, startImage.frame.size.height) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:nil title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [trainInfoImage addSubview:startDateLabel];
    
    UIImageView *endImage = [self getImageViewWithFrame:CGRectMake(endCityLabel.frame.origin.x, endCityLabel.frame.origin.y + endCityLabel.frame.size.height, startImage.frame.size.width, startImage.frame.size.height) image:imageNameAndType(@"end", @"png") highLightImage:nil backGroundColor:[UIColor clearColor]];
    [trainInfoImage addSubview:endImage];
    
    self.endDateLabel = [self getLabelWithFrame:CGRectMake(endImage.frame.origin.x + endImage.frame.size.width, endImage.frame.origin.y, startCityLabel.frame.size.width - endImage.frame.size.width, endImage.frame.size.height) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:nil title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [trainInfoImage addSubview:endDateLabel];
    
    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, trainInfoImage.frame.origin.y + trainInfoImage.frame.size.height + 10, selfViewFrame.size.width, (selfViewFrame.size.height - trainInfoImage.frame.origin.y - trainInfoImage.frame.size.height - 10)*2/3)];
    theTableView.dataSource = self;
    theTableView.delegate   = self;
    [theTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:theTableView];
}

#pragma mark - tableview delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self createHeaderView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierStr = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == nil) {
        cell = [self createTableViewCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr];
    }
    
    UILabel *trainStation = (UILabel*)[cell.contentView viewWithTag:101];
    UILabel *dzTime       = (UILabel*)[cell.contentView viewWithTag:102];
    UILabel *fcTime       = (UILabel*)[cell.contentView viewWithTag:103];
    UILabel *stayTime     = (UILabel*)[cell.contentView viewWithTag:104];
    
    
    TrainStationTimetable *timetable = [dataSource objectAtIndex:indexPath.row];
    
    [trainStation setText:timetable.trainStation];
    [dzTime       setText:timetable.dzTime];
    [fcTime       setText:timetable.fcTime];
    [stayTime     setText:[NSString stringWithFormat:@"%@",timetable.stayTime]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UIView*)createHeaderView
{
    UIImageView *imageView = [self getImageViewWithFrame:CGRectMake(0, 0, selfViewFrame.size.width, 40) image:imageNameAndType(@"tableheaderimage", @"png") highLightImage:nil backGroundColor:[UIColor clearColor]];
    UILabel *startStation = [self getLabelWithFrame:CGRectMake(10, 0, (selfViewFrame.size.width - 20)*3/(5*2), imageView.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] title:@"站次/站名" font:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [imageView addSubview:startStation];
    
    UILabel *endStation = [self getLabelWithFrame:CGRectMake((selfViewFrame.size.width - 20)*3/(5*2), startStation.frame.origin.y, startStation.frame.size.width, startStation.frame.size.height) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] title:@"到达" font:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [imageView addSubview:endStation];
    
    UILabel *startTime = [self getLabelWithFrame:CGRectMake(endStation.frame.origin.x + endStation.frame.size.width, endStation.frame.origin.y, (selfViewFrame.size.width - 20)*2/(5*2), endStation.frame.size.height) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] title:@"发车" font:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [imageView addSubview:startTime];
    
    UILabel *stayTime = [self getLabelWithFrame:CGRectMake(startTime.frame.origin.x + startTime.frame.size.width, startTime.frame.origin.y, startTime.frame.size.width, startTime.frame.size.height) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] title:@"停留" font:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [imageView addSubview:stayTime];
    
    return imageView;
}

- (UITableViewCell*)createTableViewCellWithStyle:(UITableViewCellStyle)cellStyle reuseIdentifier:(NSString*)string
{
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:cellStyle reuseIdentifier:string]autorelease];
    
    UIImageView *cellBackImage = [self getImageViewWithFrame:CGRectMake(0, 0, selfViewFrame.size.width, 35.0f) image:imageNameAndType(@"whitebackimage", @"png") highLightImage:nil backGroundColor:[UIColor clearColor]];//[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, selfViewFrame.size.width, 35.0f)];
    [cell.contentView addSubview:cellBackImage];
    
    UILabel *startStation = [self getLabelWithFrame:CGRectMake(10, 0, (selfViewFrame.size.width - 20)*3/(5*2), 35) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    startStation.tag = 101;
    [cell.contentView addSubview:startStation];
    
    UILabel *endStation = [self getLabelWithFrame:CGRectMake((selfViewFrame.size.width - 20)*3/(5*2), startStation.frame.origin.y, startStation.frame.size.width, startStation.frame.size.height) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    endStation.tag = 102;
    [cell.contentView addSubview:endStation];
    
    UILabel *startTime = [self getLabelWithFrame:CGRectMake(endStation.frame.origin.x + endStation.frame.size.width, endStation.frame.origin.y, (selfViewFrame.size.width - 20)*2/(5*2), endStation.frame.size.height) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    startTime.tag = 103;
    [cell.contentView addSubview:startTime];
    
    UILabel *stayTime = [self getLabelWithFrame:CGRectMake(startTime.frame.origin.x + startTime.frame.size.width, startTime.frame.origin.y, startTime.frame.size.width, startTime.frame.size.height) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:[self getColor:@"ff6c00"] title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    stayTime.tag = 104;
    [cell.contentView addSubview:stayTime];
    
    return cell;
}

#pragma mark - request handle
- (void)requestTrainDataWithType:(TrainQueryType)_type
{
    switch (_type) {
        case TrainQueryCommon:{
            [self getTrainCodeAndPriceWithParams:history withUserInfo:nil];
            break;
        }case TrainQueryHighSpeed:{
            [self getGaotieTrainCodeAndPriceWithParams:history withUserInfo:nil];
            break;
        }
        default:
            break;
    }
}

- (void)getTrainCodeAndPrice
{
    
    [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 40 - 2.0f, selfViewFrame.size.width, selfViewFrame.size.height - 40 + 2.0f) belowView:nil enabled:NO];
     [self getTrainCodeAndPriceWithParams:history withUserInfo:nil];
}

- (void)requestDone:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 40, selfViewFrame.size.width, selfViewFrame.size.height - 40) belowView:nil enabled:YES];
    [self parserStringBegin:request];
}

- (void)parserStringFinished:(NSString *)_string request:(ASIHTTPRequest *)request
{
    if (!dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    NSDictionary *dicData = [_string JSONValue];
    if ([[dicData objectForKey:@"performStatus"] isEqualToString:@"success"]) {
        [dataSource removeAllObjects];
        NSDictionary *result = [dicData objectForKey:@"performResult"];
        [startCityLabel setText:[result objectForKey:@"beginStation"]];
        [endCityLabel setText:[result objectForKey:@"endStation"]];
        [startDateLabel setText:[result objectForKey:@"beginTime"]];
        [endDateLabel setText:[result objectForKey:@"endStation"]];
        [trainCodeLabel setText:[result objectForKey:@"trainCode"]];
        [distanceLabel setText:[NSString stringWithFormat:@"行程:%@公里",[result objectForKey:@"mile"]]];
        [costTimeLabel setText:[NSString stringWithFormat:@"花费时间:%@",[result objectForKey:@"elapsedTime"]]];
        self.dataSource = [TrainStationTimetable getDataSourceWithData:[result objectForKey:@"trainInfoDetails"]];
        [self.dataSource sortUsingSelector:@selector(compare:)];
        if ([self.dataSource count]) {
            [theTableView reloadData];
        }
    }
}

- (void)requestError:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 40, selfViewFrame.size.width, selfViewFrame.size.height - 40) belowView:nil enabled:YES];
}

- (void)pressReturnButton:(UIButton*)sender
{
    BaseUIViewController *prevView = [[Model shareModel].viewControllers objectAtIndex:([[Model shareModel].viewControllers indexOfObject:self] - 1)];
    [[Model shareModel] pushView:prevView options:ViewTrasitionEffectMoveRight completion:^{
        [[Model shareModel].viewControllers removeObject:self];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
