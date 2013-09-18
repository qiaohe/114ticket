//
//  PassengerInfoViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-19.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "PassengerInfoViewController.h"
#import "Model.h"
#import "PassengerInfoCell.h"
#import "CustomButton.h"
#import "PassengerInfo.h"
#import "OrderDetailViewController.h"
#import "Utils.h"

@interface PassengerInfoViewController ()

@end

@implementation PassengerInfoViewController

@synthesize delegate;
@synthesize theTableView;
@synthesize dataSource;
@synthesize selectPassengers;
@synthesize codeAndPrice;
@synthesize trainOrder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
        [self initView];
        self.dataSource = [NSMutableArray array];
        self.selectPassengers = [NSMutableArray array];
    }
    
    return self;
}

- (id)initWithCodeAndPrice:(TrainCodeAndPrice*)_codeAndPrice
{
    self = [super init];
    if (self) {
        self.codeAndPrice = _codeAndPrice;
        self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
        [self initView];
        self.dataSource = [NSMutableArray array];
        self.selectPassengers = [NSMutableArray array];
    }
    
    return self;
}

- (void)dealloc
{
    self.delegate       =       nil;
    [theTableView           release];
    [dataSource             release];
    [selectPassengers       release];
    [codeAndPrice           release];
    [trainOrder             release];
    [super                  dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)getPassengers
{
    if (![UserDefaults shareUserDefault].userId) {
        self.dataSource = [UserDefaults shareUserDefault].contacts;
        [theTableView reloadData];
        return;
    }
    [[Model shareModel] showActivityIndicator:YES frame:CGRectMake(0, 40 - 2.0, self.view.frame.size.width, self.view.frame.size.height - 40 + 2.0) belowView:nil enabled:NO];
    NSString *urlString = [NSString stringWithFormat:@"%@/getPassengers",UserServiceURL];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Utils NULLToEmpty:[UserDefaults shareUserDefault].userId],         @"userId",
                            [Utils nilToNumber:[NSNumber numberWithInteger:1]],                 @"pageNo",
                            [Utils nilToNumber:[NSNumber numberWithInteger:HUGE_VALF]],         @"pageSize",
                            nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"getPassengers",           @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params requestMethod:RequestPost userInfo:userInfo];
}

#pragma mark - request handle
- (void)requestDone:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
    /*
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:[request.responseString dataUsingEncoding:NSUTF8StringEncoding]];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser setDelegate:self];
    [parser parse];*/
    [self parserStringBegin:request];
}

- (void)parserStringFinished:(NSString *)_string request:(ASIHTTPRequest *)request
{
    NSString *requestType = [request.userInfo objectForKey:@"requestType"];
    if ([requestType isEqualToString:@"getPassengers"]) {
        if (!dataSource) {
            self.dataSource = [NSMutableArray array];
        }
        NSDictionary *dataDic = [_string JSONValue];
        NSArray      *performResult = [dataDic objectForKey:@"performResult"];
        if ([dataSource count]) {
            [dataSource removeAllObjects];
        }
        for (NSDictionary *dic in performResult) {
            PassengerInfo *passenger = [[PassengerInfo alloc]initWithJSONData:dic];;
            
            [dataSource addObject:passenger];
        }
        [theTableView reloadData];
    }else if ([requestType isEqualToString:@"deletePassenger"]){
        
    }
}

- (void)requestError:(ASIHTTPRequest *)request
{
    [[Model shareModel] showActivityIndicator:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];
}

#pragma mark - tableview delegate method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierStr = @"cell";
    PassengerInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == nil) {
        cell = [[[PassengerInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr]autorelease];
    }
    PassengerInfo *passenger = (PassengerInfo*)[dataSource objectAtIndex:indexPath.row];
    [cell.nameLabel setText:passenger.name];
    if (passenger.type == TicketMan) {
        [cell.ticketTypeLabel setText:@"成人票"];
    }else if (passenger.type == TicketChildren){
        [cell.ticketTypeLabel setText:@"儿童票"];
    }else{
        [cell.ticketTypeLabel setText:@"老人票"];
    }
    NSString *idCardType = nil;
    if (passenger.type != TicketChildren) {
        if ([passenger.certificateType isEqualToString:@"0"]) {
            idCardType = @"身份证";
        }else if ([passenger.certificateType isEqualToString:@"1"]) {
            idCardType = @"护照";
        }else{
            idCardType = @"港澳通行证";
        }
        [cell.idCardNumLabel setText:[NSString stringWithFormat:@"证件:%@(%@)",passenger.certificateNumber,idCardType]];
    }else{
        [cell.idCardNumLabel setText:[NSString stringWithFormat:@"出生日期:%@",passenger.birthDate]];
    }
    
    cell.selectImageView.highlighted = passenger.selected;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PassengerInfo *passenger = (PassengerInfo*)[dataSource objectAtIndex:indexPath.row];
    passenger.selected = passenger.selected?NO:YES;
    
    PassengerInfoCell *cell = (PassengerInfoCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.selectImageView.highlighted = passenger.selected;
    
    if (passenger.selected) {
        [selectPassengers addObject:passenger];
    }else{
        if ([selectPassengers containsObject:passenger]) {
            [selectPassengers removeObject:passenger];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除联系人";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PassengerInfo *passenger = [dataSource objectAtIndex:indexPath.row];
        [dataSource removeObjectAtIndex:indexPath.row];
        if ([selectPassengers containsObject:passenger]) {
            [selectPassengers removeObject:passenger];
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if (![UserDefaults shareUserDefault].userId) {
            [UserDefaults shareUserDefault].contacts = dataSource;
        }else{
            NSString *urlString = [NSString stringWithFormat:@"%@/deletePassenger",UserServiceURL];
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Utils nilToNumber:[NSNumber numberWithInteger:passenger.passengerId]],@"id",
                                    nil];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"deletePassenger",           @"requestType",
                                      nil];
            [self sendRequestWithURL:urlString params:params requestMethod:RequestGet userInfo:userInfo];
        }
    }
}

#pragma mark - other method
- (void)pressReturnButton:(UIButton*)sender
{
    BaseUIViewController *prevView = [[Model shareModel].viewControllers objectAtIndex:([[Model shareModel].viewControllers indexOfObject:self] - 1)];
    [[Model shareModel] pushView:prevView options:ViewTrasitionEffectMoveRight completion:^{
        [[Model shareModel].viewControllers removeObject:self];
    }];
}

- (void)pressRightButton:(UIButton*)sender
{
    AddNewContactsViewController *addNewContactsView = [[[AddNewContactsViewController alloc]init]autorelease];
    addNewContactsView.delegate = self;
    [[Model shareModel] pushView:addNewContactsView options:ViewTrasitionEffectMoveLeft completion:^{
        [[Model shareModel].viewControllers addObject:addNewContactsView];
        //[addNewContactsView showDetailViewWithTciketType:TicketMan];
    }];
}

- (void)pressSubmitButton:(UIButton*)sender
{
    BaseUIViewController *prevView = [[Model shareModel].viewControllers objectAtIndex:([[Model shareModel].viewControllers indexOfObject:self] - 1)];
    [[Model shareModel] pushView:prevView options:ViewTrasitionEffectMoveRight completion:^{
        [[Model shareModel].viewControllers removeObject:self];
        if (delegate) {
            [self.delegate addPassengers:selectPassengers];
        }
    }];
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
    
    UILabel *titleLabel = [self getLabelWithFrame:CGRectMake(80, 0, 160, 40) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] title:@"乘客信息" font:nil];
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
    [rightBtn setTitle:@"新增乘客" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    [rightBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"addpassenger_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"addpassenger_press" ofType:@"png"]] forState:UIControlStateSelected];
    [rightBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"addpassenger_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(pressRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    if (codeAndPrice) {
        theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, selfViewFrame.size.width, selfViewFrame.size.height - 40 - 70)];
        theTableView.dataSource = self;
        theTableView.delegate   = self;
        theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        theTableView.backgroundColor = [UIColor clearColor];
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
    }else{
        theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, selfViewFrame.size.width, selfViewFrame.size.height - 40)];
        theTableView.dataSource = self;
        theTableView.delegate   = self;
        theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        theTableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:theTableView];
    }
    
}

- (void)reloadData
{
    [self getPassengers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
