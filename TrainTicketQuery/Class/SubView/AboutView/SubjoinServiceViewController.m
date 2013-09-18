//
//  SubjoinServiceViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-22.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "SubjoinServiceViewController.h"
#import "Model.h"
#import "InSure.h"

@implementation SubjoinServiceCell

@synthesize selectImageView;
@synthesize label;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)dealloc
{
    [selectImageView         release];
    [label                   release];
    [super                   dealloc];
}

#pragma mark - view init
- (void)initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *backImage = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, appFrame.size.width - 20, 40)]autorelease];
    [backImage setImage:imageNameAndType(@"subjoinviewbox", @"png")];
    [self.contentView addSubview:backImage];
    
    selectImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(backImage.frame.origin.x + 5, backImage.frame.origin.y + 5, 30, 28)]autorelease];
    selectImageView.tag = 101;
    [selectImageView setImage:imageNameAndType(@"passengerselect_normal", @"png")];
    [selectImageView setHighlightedImage:imageNameAndType(@"passengerselect_press", @"png")];
    [selectImageView setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:selectImageView];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(selectImageView.frame.origin.x + selectImageView.frame.size.width + 10, backImage.frame.origin.y, backImage.frame.size.width - selectImageView.frame.origin.x - selectImageView.frame.size.width - 10, backImage.frame.size.height)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    label.tag = 102;
    [self.contentView addSubview:label];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    //selectImageView.highlighted = selected;
    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    //selectImageView.highlighted = highlighted;
}

@end

@interface SubjoinServiceViewController ()

@end

@implementation SubjoinServiceViewController

@synthesize delegate;
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
    [self    setDelegate:nil];
    [theTableView    release];
    [dataSource      release];
    [super           dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
        [self initView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)getInsureType
{
    [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 40.0f - 1.5f, selfViewFrame.size.width, selfViewFrame.size.height + 1.5f) belowView:nil enabled:NO];
    NSString *urlString = nil;
    urlString = [NSString stringWithFormat:@"%@/getInsureType",TrainOrderServiceURL];
    [self sendRequestWithURL:urlString params:nil requestMethod:RequestGet userInfo:nil];
}

#pragma mark - request handle
- (void)requestDone:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
    [self parserStringBegin:request];
}

- (void)parserStringFinished:(NSString *)_string request:(ASIHTTPRequest *)request
{
    self.dataSource = [NSMutableArray arrayWithArray:[InSure getInSureTypeListWithData:[_string JSONValue]]];
    [theTableView reloadData];
}

- (void)requestError:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
}


- (void)pressSubmitButton:(UIButton*)sender
{
    BaseUIViewController *prevView = [[Model shareModel].viewControllers objectAtIndex:([[Model shareModel].viewControllers indexOfObject:self] - 1)];
    
    InSure *selectionInsure = nil;
    for (InSure *sure in dataSource) {
        if (sure.selected) {
            selectionInsure = sure;
            break;
        }
    }
    
    [[Model shareModel] pushView:prevView options:ViewTrasitionEffectMoveRight completion:^{
        if ([[Model shareModel].viewControllers containsObject:self]) {
            [[Model shareModel].viewControllers removeObject:self];
            [self.delegate addSubjoinService:selectionInsure];
        }
    }];
}

#pragma mark - tableview delegate method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierStr = @"cell";
    SubjoinServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == nil) {
        cell = [[[SubjoinServiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr]autorelease];
    }
    InSure *inSure = [dataSource objectAtIndex:indexPath.row];
    [cell.label setText:inSure.inSureDetail];
    cell.selectImageView.highlighted = inSure.selected;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InSure *insure = [dataSource objectAtIndex:indexPath.row];
    for ( InSure *sure in dataSource) {
        sure.selected = NO;
    }
    insure.selected = YES;
    [theTableView reloadData];
}

- (UITableViewCell*)createTableViewCellWithStyle:(UITableViewCellStyle)cellStyle reuseIdentifier:(NSString *)identifier
{
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:cellStyle reuseIdentifier:identifier]autorelease];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *backImage = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, selfViewFrame.size.width - 20, 40)]autorelease];
    [backImage setImage:imageNameAndType(@"subjoinviewbox", @"png")];
    [cell.contentView addSubview:backImage];
    
    UIImageView *selectImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(backImage.frame.origin.x + 5, backImage.frame.origin.y + 5, 30, 28)]autorelease];
    selectImageView.tag = 101;
    [selectImageView setImage:imageNameAndType(@"passengerselect_normal", @"png")];
    [selectImageView setHighlightedImage:imageNameAndType(@"passengerselect_press", @"png")];
    [selectImageView setBackgroundColor:[UIColor clearColor]];
    [cell.contentView addSubview:selectImageView];
    
    UILabel *label = [self getLabelWithFrame:CGRectMake(selectImageView.frame.origin.x + selectImageView.frame.size.width + 10, backImage.frame.origin.y, backImage.frame.size.width - selectImageView.frame.origin.x - selectImageView.frame.size.width - 10, backImage.frame.size.height) textAlignment:NSTextAlignmentLeft backGroundColor:[UIColor clearColor] textColor:nil title:nil font:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    label.tag = 102;
    [cell.contentView addSubview:label];
    
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
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(selfViewFrame.size.width - returnBtn.frame.size.width*3/2 - 10, returnBtn.frame.origin.y, returnBtn.frame.size.width*3/2, returnBtn.frame.size.height);
    [rightBtn setTitle:@"保险说明" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    [rightBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"addpassenger_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"addpassenger_press" ofType:@"png"]] forState:UIControlStateSelected];
    [rightBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"addpassenger_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(pressRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40 + 10, selfViewFrame.size.width, selfViewFrame.size.height - 40 - 70)];
    theTableView.backgroundColor = [UIColor clearColor];
    theTableView.dataSource = self;
    theTableView.delegate   = self;
    theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:theTableView];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, 0, selfViewFrame.size.width*2/3, 50);
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(pressSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.center = CGPointMake(selfViewFrame.size.width/2, (selfViewFrame.size.height + theTableView.frame.origin.y + theTableView.frame.size.height)/2);
    [submitButton setBackgroundImage:imageNameAndType(@"search_normal", @"png") forState:UIControlStateNormal];
    [submitButton setBackgroundImage:imageNameAndType(@"search_press", @"png") forState:UIControlStateSelected];
    [submitButton setBackgroundImage:imageNameAndType(@"search_press", @"png") forState:UIControlStateHighlighted];
    [self.view addSubview:submitButton];
}

#pragma mark - button press
- (void)pressReturnButton:(UIButton*)sender
{
    BaseUIViewController *prevView = [[Model shareModel].viewControllers objectAtIndex:([[Model shareModel].viewControllers indexOfObject:self] - 1)];
    
    [[Model shareModel] pushView:prevView options:ViewTrasitionEffectMoveRight completion:^{
        if ([[Model shareModel].viewControllers containsObject:self]) {
            [[Model shareModel].viewControllers removeObject:self];
        }
    }];
}

- (void)pressRightButton:(UIButton*)sender
{
    [[Model shareModel] showPromptBoxWithText:@"保险说明" modal:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
