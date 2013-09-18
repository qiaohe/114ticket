//
//  StationQueryViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-12.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "StationQueryViewController.h"
#import "QueryHistoryCell.h"
#import "QueryHistory.h"
#import "QueryDetailInfoViewController.h"
#import "Model.h"
#import "PlistProxy.h"
#import "CustomButton.h"
#import "Utils.h"

@interface StationQueryViewController ()

@end

@implementation StationQueryViewController

@synthesize backGroundImage;
@synthesize startCity;
@synthesize chooseStartCity;
@synthesize endCity;
@synthesize chooseEndCity;
@synthesize startDate;
@synthesize chooseStartDate;
@synthesize searchButton;
@synthesize theTableView;
@synthesize queryHistoryArray;
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
    [backGroundImage   release];
    [chooseStartCity   release];
    [startCity         release];
    [chooseEndCity     release];
    [endCity           release];
    [chooseStartDate   release];
    [startDate         release];
    [searchButton      release];
    [theTableView      release];
    [queryHistoryArray release];
    [super             dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.queryHistoryArray = [Model shareModel].allQueryHistory;
    
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
    //return [self.queryHistoryArray count];
    return [queryHistoryArray count];
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
    [cell.cityLabel setText:[NSString stringWithFormat:@"%@-%@",history.startCity,history.endCity]];
    [cell.dateLabel setText:[NSString stringWithFormat:@"%@出发",history.startDate]];
    cell.deleteButton.indexPath = indexPath;
    [cell.deleteButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteButton addTarget:self action:@selector(deleteQueryHistory:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QueryHistory *history = [queryHistoryArray objectAtIndex:indexPath.row];
    self.startCity.text = history.startCity;
    self.endCity.text   = history.endCity;
    //self.startDate.text = history.startDate;
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
    [[Model shareModel].allQueryHistory removeObjectAtIndex:sender.indexPath.row];
    [[PlistProxy sharePlistProxy] updateQueryHistory];
    [theTableView reloadData];
}

#pragma mark - button press method
- (void)pressChooseStartCity:(UIButton*)sender
{
    CityPickerViewController *cityPicker = [[[CityPickerViewController alloc]init]autorelease];
    cityPicker.delegate = self;
    cityPicker.pickType = PickStartCity;
    [[Model shareModel] pushView:cityPicker options:ViewTrasitionEffectMoveLeft completion:^{
        [[Model shareModel].viewControllers addObject:cityPicker];
    }];
}

- (void)pressChooseEndCity:(UIButton*)sender
{
    CityPickerViewController *cityPicker = [[[CityPickerViewController alloc]init]autorelease];
    cityPicker.delegate = self;
    cityPicker.pickType = PickEndCity;
    [[Model shareModel] pushView:cityPicker options:ViewTrasitionEffectMoveLeft completion:^{
        [[Model shareModel].viewControllers addObject:cityPicker];
    }];
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
    if ([startCity canResignFirstResponder]) {
        [startCity resignFirstResponder];
    }if([endCity canResignFirstResponder]){
        [endCity resignFirstResponder];
    }if([startDate canResignFirstResponder]){
        [startDate resignFirstResponder];
    }
}

- (void)setDataWithParams:(NSString*)params withPickType:(PickType)_pickType
{
    if (_pickType == PickStartCity) {
        [startCity setText:params];
    }else if (_pickType == PickEndCity){
        [endCity setText:params];
    }
}

#pragma mark - press search
- (void)pressSearchBtn:(UIButton*)sender
{
    if ([Utils textIsEmpty:self.startCity.text] || [Utils textIsEmpty:self.endCity.text] || [Utils textIsEmpty:self.startDate.text]) {
        [[Model shareModel] showPromptBoxWithText:@"搜索参数为空" modal:YES];
    }else{
        QueryHistory *history = [[[QueryHistory alloc]initWithStartCity:self.startCity.text endCity:self.endCity.text startDate:self.startDate.text trainCode:nil queryType:QueryAllTrainCodeAndPrice]autorelease];
        
        QueryHistory *e = [self dataSource:[Model shareModel].allQueryHistory ContainsObject:history];
        if (e) {
            [[Model shareModel].allQueryHistory removeObject:e];
        }
        //[self.queryHistoryArray addObject:history];
        [[Model shareModel].allQueryHistory addObject:history];
        [[PlistProxy sharePlistProxy]updateQueryHistory];
        [theTableView reloadData];
        
        QueryDetailInfoViewController *infoView = [[[QueryDetailInfoViewController alloc]initWithHistory:history]autorelease];
        /*
        infoView.trainOrder = [[TrainOrder alloc]init];
        
        infoView.trainOrder.startStation = history.startCity;
        infoView.trainOrder.endStation   = history.endCity;
        infoView.trainOrder.trainStartTime = history.startDate;*/
        
        [[Model shareModel] pushView:infoView options:ViewTrasitionEffectMoveLeft completion:^{
            [[Model shareModel].viewControllers addObject:infoView];
            [infoView requestTrainDataWithType:trainType];
        }];
    }
}

#pragma mark - view init
- (void)initView
{
    backGroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [backGroundImage setImage:imageNameAndType(@"backgroundimage", @"png")];
    [self.view addSubview:backGroundImage];
    
    [self setCityViewFrame];
    [self setDateViewFrame];
    
    [self setDataViewFrame];
}

- (void)setCityViewFrame
{
    UIImageView *cityImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(15, 20, self.view.frame.size.width - 30, 100)]autorelease];
    [cityImageView setImage:imageNameAndType(@"citylabel_btn", @"png")];
    [self.view addSubview:cityImageView];
    
    UITextField *start = [[[UITextField alloc]initWithFrame:CGRectMake(cityImageView.frame.origin.x + 40 + 10, cityImageView.frame.origin.y + 10 + 8, cityImageView.frame.size.width - 40 - 80 - 10, cityImageView.frame.size.height/2 - 20)]autorelease];
    start.enabled = NO;
    start.placeholder = @"出发城市";
    [self.view addSubview:start];
    
    startCity = [[UITextField alloc]initWithFrame:start.frame];
    startCity.enabled = NO;
    startCity.delegate = self;
    startCity.returnKeyType = UIReturnKeyDone;
    startCity.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:startCity];
    
    self.chooseStartCity = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseStartCity.frame = CGRectMake(start.frame.origin.x, cityImageView.frame.origin.y + 3.0f, cityImageView.frame.size.width - start.frame.origin.x, 50.0f - 3.0f);
    [chooseStartCity addTarget:self action:@selector(pressChooseStartCity:) forControlEvents:UIControlEventTouchUpInside];
    [chooseStartCity setBackgroundImage:imageNameAndType(@"queryarrow_normal", @"png") forState:UIControlStateNormal];
    //[chooseStartCity setBackgroundImage:imageNameAndType(@"arrow_press", @"png") forState:UIControlStateHighlighted];
    [self.view addSubview:chooseStartCity];
    
    UITextField *end = [[[UITextField alloc]initWithFrame:CGRectMake(startCity.frame.origin.x, cityImageView.frame.origin.y + 10 + 4 + 50, startCity.frame.size.width, startCity.frame.size.height)]autorelease];
    end.enabled = NO;
    end.placeholder = @"到达城市";
    [self.view addSubview:end];
    
    endCity = [[UITextField alloc]initWithFrame:end.frame];
    endCity.enabled = NO;
    endCity.delegate = self;
    endCity.returnKeyType = UIReturnKeyDone;
    endCity.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:endCity];
    
    self.chooseEndCity = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseEndCity.frame = CGRectMake(chooseStartCity.frame.origin.x, cityImageView.frame.origin.y + 50.0f + 3.0f, chooseStartCity.frame.size.width, chooseStartCity.frame.size.height);
    [chooseEndCity addTarget:self action:@selector(pressChooseEndCity:) forControlEvents:UIControlEventTouchUpInside];
    [chooseEndCity setBackgroundImage:imageNameAndType(@"queryarrow_normal", @"png") forState:UIControlStateNormal];
    //[chooseEndCity setBackgroundImage:imageNameAndType(@"arrow_press", @"png") forState:UIControlStateHighlighted];
    [self.view addSubview:chooseEndCity];
}

- (void)setDateViewFrame
{
    UIImageView *dateImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(15, 100 + 20 + 20, self.view.frame.size.width - 30, 50)]autorelease];
    [dateImageView setImage:imageNameAndType(@"date_btn", @"png")];
    [self.view addSubview:dateImageView];
    
    UITextField *date = [[[UITextField alloc]initWithFrame:CGRectMake(endCity.frame.origin.x, dateImageView.frame.origin.y + 10 + 5, startCity.frame.size.width, startCity.frame.size.height)]autorelease];
    date.enabled = NO;
    date.placeholder = @"出发日期";
    [self.view addSubview:date];
    
    startDate = [[UITextField alloc]initWithFrame:CGRectMake(date.frame.origin.x + date.frame.size.width - 60, dateImageView.frame.origin.y, dateImageView.frame.origin.x + dateImageView.frame.size.width - endCity.frame.origin.x - endCity.frame.size.width, dateImageView.frame.size.height)];
    startDate.enabled = NO;
    startDate.delegate = self;
    startDate.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    startDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [startDate setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    startDate.text = [self stringWithDate:[[NSDate date] dateByAddingTimeInterval:60*60*24]];
    startDate.textAlignment = NSTextAlignmentLeft;
    startDate.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:startDate];
    
    self.chooseStartDate = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseStartDate.frame = CGRectMake(chooseEndCity.frame.origin.x, dateImageView.frame.origin.y + 1.50f, chooseStartCity.frame.size.width, chooseStartCity.frame.size.height);
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
    
    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, searchBtn.frame.origin.y + searchBtn.frame.size.height + 20, self.view.frame.size.width, self.view.frame.size.height - (searchBtn.frame.origin.y + searchBtn.frame.size.height + 20))];
    //theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
