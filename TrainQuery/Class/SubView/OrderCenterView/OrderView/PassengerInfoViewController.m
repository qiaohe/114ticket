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
#import "CustomLongPressGestureRecognizer.h"
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)getPassengers
{
    if (![UserDefaults shareUserDefault].userId) {
        self.dataSource = [UserDefaults shareUserDefault].contacts;
//        for (PassengerInfo *info in dataSource) {
//            if (info.selected) {
//                [selectPassengers addObject:info];
//            }
//        }
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
            PassengerInfo *passenger = [[[PassengerInfo alloc]initWithJSONData:dic]autorelease];
            if ([selectPassengers count]) {
                if ([self passengers:selectPassengers containObject:passenger] != nil) {
                    passenger.selected = YES;
                    [selectPassengers replaceObjectAtIndex:[selectPassengers indexOfObject:[self passengers:selectPassengers containObject:passenger]] withObject:passenger];
                }
            }
            [dataSource addObject:passenger];
        }
        if ([dataSource count] == 0) {
            [[Model shareModel] showPromptBoxWithText:@"您还没有常用联系人" modal:NO];
        }
        [theTableView reloadData];
    }else if ([requestType isEqualToString:@"deletePassenger"]){
        NSDictionary *dataDic = [_string JSONValue];
        if ([[dataDic objectForKey:@"performStatus"] isEqualToString:@"success"]) {
            [[Model shareModel] showPromptBoxWithText:[dataDic objectForKey:@"performResult"] modal:YES];
        }
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
        cell.longPressGesture = [[[CustomLongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)]autorelease];
        cell.longPressGesture.minimumPressDuration = 1.0f;
        cell.longPressGesture.delegate = self;
        [cell addGestureRecognizer:cell.longPressGesture];
    }
    cell.longPressGesture.indexPath = indexPath;
    PassengerInfo *passenger = (PassengerInfo*)[dataSource objectAtIndex:indexPath.row];
    NSString *ticketType = nil;
    if (passenger.type == TicketMan) {
        ticketType = @"成人";
    }else if (passenger.type == TicketChildren){
        ticketType = @"儿童";
    }else{
        ticketType = @"老人";
    }
    [cell.nameLabel setText:[NSString stringWithFormat:@"%@ : %@",ticketType,passenger.name]];
    NSString *idCardType = nil;
    if (passenger.type != TicketChildren) {
        idCardType = [self checkIdCardTypeWithValue:[passenger.certificateType integerValue]];
        [cell.idCardNumLabel setText:[NSString stringWithFormat:@"%@:%@",idCardType,passenger.certificateNumber]];
    }else{
        [cell.idCardNumLabel setText:[NSString stringWithFormat:@"出生日期:%@",passenger.birthDate]];
    }
    
    cell.selectImageView.highlighted = passenger.selected;
    return cell;
}


- (void)removeGestureRecognizer:(PassengerInfoCell*)cell withClass:(Class)_class
{
    for (UIGestureRecognizer *gestureRecognizer in cell.gestureRecognizers) {
        if ([gestureRecognizer isMemberOfClass:_class]) {
            [cell removeGestureRecognizer:gestureRecognizer];
        }
    }
}

- (CustomLongPressGestureRecognizer*)gestureRecognizer:(PassengerInfoCell*)cell withTag:(NSInteger)_tag
{
    for (CustomLongPressGestureRecognizer *gestureRecognizer in cell.gestureRecognizers) {
        if (gestureRecognizer.tag == _tag) {
            return [[gestureRecognizer retain]autorelease];
        }
    }
    return nil;
}

- (void)cellLongPress:(UILongPressGestureRecognizer*)_longPressGesture
{
    if (_longPressGesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long press");
        CustomLongPressGestureRecognizer *longPressGesture = (CustomLongPressGestureRecognizer*)_longPressGesture;
        PassengerInfo *_passenger = (PassengerInfo*)[dataSource objectAtIndex:longPressGesture.indexPath.row];
        
        AddNewContactsViewController *updateContactView = [[AddNewContactsViewController alloc]initWithPassenger:_passenger];
        updateContactView.delegate = self;
        updateContactView.initType = PassengerUpdate;
        [self pushViewController:updateContactView completion:nil];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([selectPassengers count] == 5) {
        [[Model shareModel] showPromptBoxWithText:@"每次最多购5张票" modal:NO];
        return;
    }
    PassengerInfo *passenger = [dataSource objectAtIndex:indexPath.row];

    passenger.selected = passenger.selected?NO:YES;
    
    PassengerInfoCell *cell = (PassengerInfoCell*)[theTableView cellForRowAtIndexPath:indexPath];
    
    cell.selectImageView.highlighted = passenger.selected;
    
    if (passenger.selected) {
        if (![UserDefaults shareUserDefault].userId) {
            if (![selectPassengers containsObject:passenger]) {
                [selectPassengers addObject:passenger];
            }
        }else{
            if (![self passengers:selectPassengers containObject:passenger]) {
                [selectPassengers addObject:passenger];
            }
        }
    }else{
        if (![UserDefaults shareUserDefault].userId) {
            if ([selectPassengers containsObject:passenger]) {
                [selectPassengers removeObject:passenger];
            }
        }else{
            if ([self passengers:selectPassengers containObject:passenger]) {
                [selectPassengers removeObject:[self passengers:selectPassengers containObject:passenger]];
            }
        }
    }
}   

- (void)selectPassenger:(CustomButton*)sender
{
    PassengerInfo *_passenger = (PassengerInfo*)[dataSource objectAtIndex:sender.indexPath.row];

    AddNewContactsViewController *updateContactView = [[AddNewContactsViewController alloc]initWithPassenger:_passenger];
    updateContactView.delegate = self;
    updateContactView.initType = PassengerUpdate;
    [self pushViewController:updateContactView completion:nil];
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
        
        NSInteger passengerId = 0;
        if ([UserDefaults shareUserDefault].userId) {
            passengerId = passenger.passengerId;
        }
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
                                    [Utils nilToNumber:[NSNumber numberWithInteger:passengerId]],@"id",
                                    nil];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"deletePassenger",           @"requestType",
                                      //indexPath,                    @"indexPath",
                                      nil];
            [self sendRequestWithURL:urlString params:params requestMethod:RequestGet userInfo:userInfo];
        }
    }
}

#pragma mark - other method
- (void)pressReturnButton:(UIButton*)sender
{
    [self popViewControllerCompletion:nil];
}

- (void)pressRightButton:(UIButton*)sender
{
    AddNewContactsViewController *addNewContactsView = [[[AddNewContactsViewController alloc]init]autorelease];
    addNewContactsView.delegate = self;
    addNewContactsView.initType = PassengerAdd;
    [self pushViewController:addNewContactsView completion:nil];
}

- (void)pressSubmitButton:(UIButton*)sender
{
    [self popViewControllerCompletion:^{
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

- (PassengerInfo *)passengers:(NSArray*)array containObject:(PassengerInfo*)_passenger
{
    for (PassengerInfo *info in array) {
        if (info.passengerId == _passenger.passengerId) {
            return [[info retain] autorelease];
        }
    }
    return nil;
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
