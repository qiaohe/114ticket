//
//  TrainNumQueryViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-13.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "TrainNumQueryViewController.h"
#import "QueryHistoryCell.h"
#import "QueryCertainDetailInfoViewController.h"
#import "Model.h"
#import "QueryHistory.h"
#import "PlistProxy.h"
#import "CustomButton.h"
#import "Utils.h"

@interface TrainNumQueryViewController ()

@end

@implementation TrainNumQueryViewController

@synthesize trainCode;
@synthesize startDate;
@synthesize chooseStartDate;
@synthesize searchButton;
@synthesize queryHistoryArray;
@synthesize theTableView;
@synthesize trainType;

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
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)dealloc
{
    [trainCode         release];
    [startDate         release];
    [chooseStartDate   release];
    [searchButton      release];
    [queryHistoryArray release];
    [theTableView      release];
    [super             dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.queryHistoryArray = [Model shareModel].trainCodeQueryHistory;
    
    self.view.frame = subViewFrame;
    [self initView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didSelectDate:(NSString*)date
{
    [startDate setText:date];
}

#pragma mark - tableview delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.queryHistoryArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self viewForHeader];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierStr = @"cell";
    QueryHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == nil) {
        cell = [[[QueryHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr]autorelease];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }
    QueryHistory *history = [queryHistoryArray objectAtIndex:indexPath.row];
    [cell.cityLabel setText:[NSString stringWithFormat:@"车次：%@",history.trainCode]];
    [cell.dateLabel setText:[NSString stringWithFormat:@"%@出发",history.startDate]];
    cell.deleteButton.indexPath = indexPath;
    [cell.deleteButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteButton addTarget:self action:@selector(deleteQueryHistory:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QueryHistory *history = [queryHistoryArray objectAtIndex:indexPath.row];
    self.trainCode.text = history.trainCode;
    self.startDate.text   = history.startDate;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (UIView*)viewForHeader
{
    UIView *headerView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.theTableView.frame.size.width, 20)]autorelease];
    headerView.backgroundColor = [UIColor grayColor];
    UILabel *label = [[[UILabel alloc]initWithFrame:CGRectMake(80, 0, 160, 20)]autorelease];
    label.backgroundColor = [UIColor clearColor];
    [label setText:@"查询历史"];
    [label setFont:[UIFont systemFontOfSize:13.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [headerView addSubview:label];
    return headerView;
}

- (void)deleteQueryHistory:(CustomButton*)sender
{
    [[Model shareModel].trainCodeQueryHistory removeObjectAtIndex:sender.indexPath.row];
    [[PlistProxy sharePlistProxy] updateQueryHistory];
    [theTableView reloadData];
}

#pragma mark - other delegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField canResignFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if([trainCode canResignFirstResponder]){
        [trainCode resignFirstResponder];
    }if([startDate canResignFirstResponder]){
        [startDate resignFirstResponder];
    }
}

- (void)pressChooseStartDate:(UIButton*)sender
{
    DatePickerViewController *datePicker = [[[DatePickerViewController alloc]init]autorelease];
    //[self.view addSubview:datePicker.view];
    datePicker.delegate = self;
    
    [[Model shareModel] pushView:datePicker options:ViewTrasitionEffectMoveLeft completion:^{
        [[Model shareModel].viewControllers addObject:datePicker];
    }];
}

#pragma mark - press search
- (void)pressSearchBtn:(UIButton*)sender
{
    if ([Utils textIsEmpty:self.trainCode.text] || [Utils textIsEmpty:self.startDate.text]) {
        [[Model shareModel] showPromptBoxWithText:@"搜索参数为空" modal:YES];
    }else {
        QueryHistory *history = [[[QueryHistory alloc]initWithStartCity:nil endCity:nil startDate:self.startDate.text trainCode:self.trainCode.text queryType:QueryAllTrainCodeAndPrice]autorelease];
        
        QueryHistory *e = [self dataSource:[Model shareModel].trainCodeQueryHistory ContainsObject:history];
        if (e != nil) {
            [[Model shareModel].trainCodeQueryHistory removeObject:e];
        }
        [[Model shareModel].trainCodeQueryHistory addObject:history];
        [[PlistProxy sharePlistProxy]updateQueryHistory];
        
        //[self.queryHistoryArray addObject:history];
        [theTableView reloadData];
        
        QueryCertainDetailInfoViewController *infoView = [[[QueryCertainDetailInfoViewController alloc]init]autorelease];
        infoView.history    = history;
        infoView.queryType  = history.type;
        [[Model shareModel] pushView:infoView options:ViewTrasitionEffectMoveLeft completion:^{
            [[Model shareModel].viewControllers addObject:infoView];
            [infoView getTrainCodeAndPrice];
        }];
    }
}


#pragma mark - view init
- (void)initView
{
    UIImageView *backGroundImage = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
    [backGroundImage setImage:imageNameAndType(@"backgroundimage", @"png")];
    [self.view addSubview:backGroundImage];
    
    [self setTrainCodeViewFrame];
    [self setStartDateViewFrame];
    [self setDataViewFrame];
}

- (void)setTrainCodeViewFrame
{
    UIImageView *imageView = [[[UIImageView alloc]initWithFrame:CGRectMake(18, 20, self.view.frame.size.width - 36, 50)]autorelease];
    [imageView setImage:imageNameAndType(@"trainnum_label", @"png")];
    [self.view addSubview:imageView];
    
    trainCode = [[UITextField alloc]initWithFrame:CGRectMake(imageView.frame.origin.x + 40 + 10, imageView.frame.origin.y + 10 + 4, imageView.frame.size.width - 40 - 80 - 10, imageView.frame.size.height - 10)];
    trainCode.delegate = self;
    trainCode.keyboardType = UIKeyboardTypeEmailAddress;
    trainCode.returnKeyType = UIReturnKeyDone;
    trainCode.placeholder = @"输入车次";
    [self.view addSubview:trainCode];
    /*
    self.chooseStartDate = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseStartDate.frame = CGRectMake(trainCode.frame.origin.x + trainCode.frame.size.width, imageView.frame.origin.y + 1.0f, 70.0f, 50.0f - 1.0f);
    [chooseStartDate addTarget:self action:@selector(pressChooseStartDate:) forControlEvents:UIControlEventTouchUpInside];
    [chooseStartDate setBackgroundImage:imageNameAndType(@"arrow_normal", @"png") forState:UIControlStateNormal];
    [chooseStartDate setBackgroundImage:imageNameAndType(@"arrow_press", @"png") forState:UIControlStateHighlighted];
    [self.view addSubview:chooseStartDate];*/
}

- (void)setStartDateViewFrame
{
    UIImageView *imageView = [[[UIImageView alloc]initWithFrame:CGRectMake(15, 20 + 50 + 25, self.view.frame.size.width - 30, 50)]autorelease];
    [imageView setImage:imageNameAndType(@"date_btn", @"png")];
    [self.view addSubview:imageView];
    
    startDate = [[UITextField alloc]initWithFrame:CGRectMake(imageView.frame.origin.x + 40 + 10, imageView.frame.origin.y + 10 + 4, imageView.frame.size.width - 40 - 80 - 10, imageView.frame.size.height - 10)];
    startDate.enabled = NO;
    startDate.delegate = self;
    [startDate setText:[self stringWithDate:[NSDate date]]];
    startDate.returnKeyType = UIReturnKeyDone;
    startDate.placeholder = @"出发日期";
    [self.view addSubview:startDate];
    
    self.chooseStartDate = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseStartDate.frame = CGRectMake(startDate.frame.origin.x, imageView.frame.origin.y + 2.0f, imageView.frame.origin.x + imageView.frame.size.width - startDate.frame.origin.x - 20, 50.0f - 2.0f);
    [chooseStartDate addTarget:self action:@selector(pressChooseStartDate:) forControlEvents:UIControlEventTouchUpInside];
    [chooseStartDate setBackgroundImage:imageNameAndType(@"queryarrow_normal", @"png") forState:UIControlStateNormal];
    //[chooseStartDate setBackgroundImage:imageNameAndType(@"arrow_press", @"png") forState:UIControlStateHighlighted];
    [self.view addSubview:chooseStartDate];
}

- (void)setDataViewFrame
{
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(60, 220, 200, 45);
    [searchBtn setBackgroundImage:imageNameAndType(@"search_normal", @"png") forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:imageNameAndType(@"search_press", @"png") forState:UIControlStateHighlighted];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(pressSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.view addSubview:searchBtn];
    
    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, searchBtn.frame.origin.y + 45 + 20, self.view.frame.size.width, self.view.frame.size.height - (searchBtn.frame.origin.y + searchBtn.frame.size.height + 20))];
    theTableView.delegate   = self;
    theTableView.dataSource = self;
    [theTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.theTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
