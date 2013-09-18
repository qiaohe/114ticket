//
//  PaymentTypeViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-22.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "PaymentTypeViewController.h"
#import "Model.h"

@interface PaymentTypeViewController ()

@end

@implementation PaymentTypeViewController

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
    [theTableView        release];
    [dataSource          release];
    [super               dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
    [self initView];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - tableview delegate method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
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
    
}

- (UITableViewCell*)createTableViewCellWithStyle:(UITableViewCellStyle)cellStyle reuseIdentifier:identifier
{
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:cellStyle reuseIdentifier:identifier]autorelease];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *backImage = [[[UIImageView alloc]initWithFrame:CGRectMake(15.0f, 5.0f, selfViewFrame.size.width - 30.0f, 60.0f)]autorelease];
    [backImage setImage:imageNameAndType(@"subjoinviewbox", @"png")];
    [cell.contentView addSubview:backImage];
    
    UILabel *paymentType = [self getLabelWithFrame:CGRectMake(backImage.frame.origin.x + 10, backImage.frame.origin.y, backImage.frame.size.width*2/3, 30) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:@"跟我走吧~~~" font:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    paymentType.tag = 101;
    [cell.contentView addSubview:paymentType];
    
    UILabel *prompt      = [self getLabelWithFrame:CGRectMake(paymentType.frame.origin.x, paymentType.frame.origin.y + paymentType.frame.size.height, paymentType.frame.size.width, 30) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:[UIColor darkGrayColor] title:@"我今年有23场演唱会" font:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    prompt.tag = 102;
    [cell.contentView addSubview:prompt];
    
    UIButton *rightButton = [self getButtonWithFrame:CGRectMake(paymentType.frame.origin.x + paymentType.frame.size.width - 5, backImage.frame.origin.y + 2, backImage.frame.size.width - paymentType.frame.size.width, backImage.frame.size.height - 2) title:nil textColor:nil forState:UIControlStateNormal backGroundColor:[UIColor clearColor]];
    [rightButton setBackgroundImage:imageNameAndType(@"arrow_normal", @"png") forState:UIControlStateNormal];
    [rightButton setBackgroundImage:imageNameAndType(@"arrow_press", @"png") forState:UIControlStateHighlighted];
    rightButton.tag = 103;
    [cell.contentView addSubview:rightButton];
    
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
    
    CGFloat tableViewHeight = 60*10//[dataSource count]
    <selfViewFrame.size.height - 40 - 10?60*10//[dataSource count]
    :selfViewFrame.size.height - 40 - 10;
    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40 + 10, selfViewFrame.size.width, tableViewHeight)];
    theTableView.backgroundColor = [UIColor clearColor];
    theTableView.dataSource = self;
    theTableView.delegate   = self;
    theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:theTableView];
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
