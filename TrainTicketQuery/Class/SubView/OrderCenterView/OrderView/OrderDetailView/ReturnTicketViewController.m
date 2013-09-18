//
//  ReturnTicketViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-22.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "ReturnTicketViewController.h"
#import "Model.h"

@interface ReturnTicketViewController ()

@end

@implementation ReturnTicketViewController

@synthesize orderCode;
@synthesize totalPrice;
@synthesize trainCodeAndRoute;
@synthesize startDate;
@synthesize theTableView;
@synthesize dataSource;

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
    [orderCode               release];
    [totalPrice              release];
    [trainCodeAndRoute       release];
    [startDate               release];
    [theTableView            release];
    [dataSource              release];
    [super                   dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
    [self initView];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - table view delegate method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;//[dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierStr = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == nil) {
        cell = [self createTableViewCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:101];
    imageView.highlighted = imageView.highlighted?NO:YES;
}

- (UITableViewCell*)createTableViewCellWithStyle:(UITableViewCellStyle)cellStyle reuseIdentifier:identifier
{
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:cellStyle reuseIdentifier:identifier]autorelease];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *backImage = [[[UIImageView alloc]initWithFrame:CGRectMake(15, -4, selfViewFrame.size.width - 30, 60 + 4)]autorelease];
    [backImage setImage:imageNameAndType(@"subjoinviewbox", @"png")];
    [cell.contentView addSubview:backImage];
    
    UIImageView *selectImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 28)]autorelease];
    selectImageView.center = CGPointMake(selectImageView.frame.size.width + 5, 30);
    selectImageView.tag = 101;
    [selectImageView setImage:imageNameAndType(@"passengerselect_normal", @"png")];
    [selectImageView setHighlightedImage:imageNameAndType(@"passengerselect_press", @"png")];
    [selectImageView setBackgroundColor:[UIColor clearColor]];
    [cell.contentView addSubview:selectImageView];
    
    UILabel *ticketType = [self getLabelWithFrame:CGRectMake(selectImageView.frame.origin.x + selectImageView.frame.size.width + 10, backImage.frame.origin.y + 4, (backImage.frame.size.width - selectImageView.frame.origin.x - selectImageView.frame.size.width - 10)*2/3, 30) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:@"成人票:某某某" font:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    ticketType.tag = 102;
    [cell.contentView addSubview:ticketType];
    
    UILabel *papersTypeAndNum = [self getLabelWithFrame:CGRectMake(ticketType.frame.origin.x, ticketType.frame.origin.y + ticketType.frame.size.height, ticketType.frame.size.width, ticketType.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:@"身份证:12345678987654321" font:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    papersTypeAndNum.tag = 103;
    [cell.contentView addSubview:papersTypeAndNum];
    
    UIButton *statusButton = [self getButtonWithFrame:CGRectMake(ticketType.frame.origin.x + ticketType.frame.size.width, ticketType.frame.origin.y, backImage.frame.size.width - ticketType.frame.origin.x - ticketType.frame.size.width + 10, backImage.frame.size.height) title:@"订票成功" textColor:[self getColor:@"ff6c00"] forState:UIControlStateNormal backGroundColor:[UIColor clearColor]];
    [statusButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [cell.contentView addSubview:statusButton];
    
    return cell;
}

#pragma mark - view init
- (void)initView
{
    UIImageView *backImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
    [backImageView setImage:imageNameAndType(@"backgroundimage", @"png")];
    [self.view addSubview:backImageView];
    
    UIImageView *topImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, -1, self.view.frame.size.width, 40 + 1)]autorelease];
    [topImageView setImage:imageNameAndType(@"topbar_image", @"png")];
    [self.view addSubview:topImageView];
    
    UILabel *titleLabel = [self getLabelWithFrame:CGRectMake(80, 0, 160, 40) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] title:@"附加服务" font:nil];
    [self.view addSubview:titleLabel];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateSelected];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(pressReturnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    
    UIImageView *backImage = [self getImageViewWithFrame:CGRectMake(15, 40 + 20, selfViewFrame.size.width - 30, 160) image:imageNameAndType(@"queryinfocell_normal", @"png") highLightImage:nil backGroundColor:[UIColor clearColor]];
    [self.view addSubview:backImage];
    
    self.orderCode = [self getLabelWithFrame:CGRectMake(backImage.frame.origin.x + 10, backImage.frame.origin.y, backImage.frame.size.width - 20, 40) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [self.view addSubview:orderCode];
    
    self.totalPrice = [self getLabelWithFrame:CGRectMake(orderCode.frame.origin.x, orderCode.frame.origin.y + orderCode.frame.size.height, orderCode.frame.size.width, orderCode.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:[self getColor:@"ff6c00"] title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [self.view addSubview:totalPrice];
    
    self.trainCodeAndRoute = [self getLabelWithFrame:CGRectMake(totalPrice.frame.origin.x, totalPrice.frame.origin.y + totalPrice.frame.size.height, totalPrice.frame.size.width, totalPrice.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [self.view addSubview:trainCodeAndRoute];
    
    self.startDate = [self getLabelWithFrame:CGRectMake(trainCodeAndRoute.frame.origin.x, trainCodeAndRoute.frame.origin.y + trainCodeAndRoute.frame.size.height, trainCodeAndRoute.frame.size.width, trainCodeAndRoute.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [self.view addSubview:startDate];
    
    CGFloat tableViewHeight = 60*[dataSource count]<selfViewFrame.size.height - startDate.frame.origin.y - startDate.frame.size.height - 90?60*[dataSource count]:selfViewFrame.size.height - startDate.frame.origin.y - startDate.frame.size.height - 100;
    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, startDate.frame.origin.y + startDate.frame.size.height - 3, selfViewFrame.size.width, tableViewHeight + 3)];
    theTableView.backgroundColor = [UIColor clearColor];
    theTableView.dataSource = self;
    theTableView.delegate   = self;
    theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:theTableView];
    
    UIButton *returnTicket = [UIButton buttonWithType:UIButtonTypeCustom];
    returnTicket.frame = CGRectMake(0, 0, selfViewFrame.size.width*2/3, 50);
    returnTicket.center = CGPointMake(selfViewFrame.size.width/2, selfViewFrame.size.height - 30 - returnTicket.frame.size.height/2);
    [returnTicket setTitle:@"申请退票" forState:UIControlStateNormal];
    [returnTicket setBackgroundImage:imageNameAndType(@"search_normal", @"png") forState:UIControlStateNormal];
    [returnTicket setBackgroundImage:imageNameAndType(@"search_press", @"png") forState:UIControlStateSelected];
    [returnTicket setBackgroundImage:imageNameAndType(@"search_press", @"png") forState:UIControlStateHighlighted];
    [self.view addSubview:returnTicket];
}

#pragma mark - button press
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
