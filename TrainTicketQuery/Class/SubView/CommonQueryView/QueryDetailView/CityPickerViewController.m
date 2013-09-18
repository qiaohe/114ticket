//
//  CityPickerViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-19.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "CityPickerViewController.h"
#import "Model.h"
#import "AppDelegate.h"

@interface CityPickerViewController ()

@end

@implementation CityPickerViewController

@synthesize delegate;
@synthesize pickType;
@synthesize cityName;
@synthesize theTableView;
@synthesize hotCities;

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
    self.delegate = nil;
    [cityName     release];
    [theTableView release];
    [hotCities    release];
    [super        dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
    self.hotCities = [NSMutableArray arrayWithObjects:@"上海",@"北京",@"广州",@"重庆",@"天津",@"成都",@"武汉",@"长沙",@"深圳",@"苏州",@"南京",@"杭州", nil];
    [self initView];
    [self setDetailViewFrame];
    // Do any additional setup after loading the view from its nib.
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
    
    UILabel *titleLabel = [self getLabelWithFrame:CGRectMake(80, 0, 160, 40) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] title:@"城市选择" font:nil];
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
    cityName = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 40)];
    //cityName.bounds = CGRectMake(0, 0, self.view.frame.size.width, 10);
    [cityName setPlaceholder:nil];
    //cityName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    for (UIView *e in cityName.subviews) {
        if ([e isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField*)e;
            textField.returnKeyType = UIReturnKeyDone;
        }
    }
    //cityName.returnKeyType = UIReturnKeyDone;
    cityName.delegate = self;
    [self.view addSubview:cityName];
    
    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(cityName.frame.origin.x, cityName.frame.origin.y + cityName.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - cityName.frame.origin.y - cityName.frame.size.height)];
    [theTableView setBackgroundColor:[UIColor clearColor]];
    theTableView.delegate   = self;
    theTableView.dataSource = self;
    [self.view addSubview:theTableView];
    
    [self.view bringSubviewToFront:cityName];
}

#pragma mark - delegate method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else
        return [hotCities count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
}*/

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:{
            return @"当前城市";
            break;
        }case 1:{
            return @"热门城市";
            break;
        }
        default:
            break;
    }return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierStr = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr]autorelease];
        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    }
    if (indexPath.section == 0) {
        [cell.textLabel setText:@"使用当前位置"];
    }else if (indexPath.section == 1)
        [cell.textLabel setText:[hotCities objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
    }else if (indexPath.section == 1)
        [self.delegate setDataWithParams:[hotCities objectAtIndex:indexPath.row] withPickType:pickType];
    BaseUIViewController *prevView = [[Model shareModel].viewControllers objectAtIndex:([[Model shareModel].viewControllers indexOfObject:self] - 1)];
    [[Model shareModel] pushView:prevView options:ViewTrasitionEffectMoveRight completion:^{
        [[Model shareModel].viewControllers removeObject:self];
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField canResignFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}
#pragma mark - searchbar delegate method
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar canResignFirstResponder]) {
        [searchBar resignFirstResponder];
    }
    [self.delegate setDataWithParams:cityName.text withPickType:pickType];
    BaseUIViewController *prevView = [[Model shareModel].viewControllers objectAtIndex:([[Model shareModel].viewControllers indexOfObject:self] - 1)];
    [[Model shareModel] pushView:prevView options:ViewTrasitionEffectMoveRight completion:^{
        [[Model shareModel].viewControllers removeObject:self];
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    if ([searchBar canResignFirstResponder]) {
        [searchBar resignFirstResponder];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [[Model shareModel] showCoverView:YES frame:CGRectMake(0, cityName.frame.origin.y + cityName.frame.size.height, selfViewFrame.size.width, selfViewFrame.size.height - cityName.frame.origin.y - cityName.frame.size.height) belowView:cityName enabled:YES];
    [[Model shareModel].activityIndicatorView removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [[Model shareModel].activityIndicatorView addTarget:self action:@selector(clearBoard:) forControlEvents:UIControlEventTouchUpInside];
    if (!searchBar.showsCancelButton) {
        searchBar.showsCancelButton = YES;
    }return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [[Model shareModel] showCoverView:NO frame:CGRectMake(0, 0, 0, 0) belowView:nil enabled:YES];

    if (searchBar.text && ![searchBar.text isEqualToString:@""]) {
        searchBar.showsCancelButton = YES;
    }else{
        searchBar.showsCancelButton = NO;
    }return YES;
}
#pragma mark - other method

- (void)pressReturnButton:(UIButton*)sender
{
    if ([cityName canResignFirstResponder]) {
        [cityName resignFirstResponder];
    }
    BaseUIViewController *prevView = [[Model shareModel].viewControllers objectAtIndex:([[Model shareModel].viewControllers indexOfObject:self] - 1)];
    [[Model shareModel] pushView:prevView options:ViewTrasitionEffectMoveRight completion:^{
        [[Model shareModel].viewControllers removeObject:self];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([cityName canResignFirstResponder]) {
        [cityName resignFirstResponder];
    }
}

#pragma mark - key board delegate method
- (void)keyBoardWillShow:(NSNotification *)notification
{
    [super keyBoardWillShow:notification];
    CGRect keyboardFrames = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self keyBoardShow:keyboardFrames animationDuration:animationDuration];
}

- (void)keyBoardWillHide:(NSNotification *)notification
{
    [super keyBoardWillHide:notification];
    CGRect keyboardFrames = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self keyBoardHide:keyboardFrames animationDuration:animationDuration];
    
}

- (void)keyBoardShow:(CGRect)frame animationDuration:(NSTimeInterval)duration
{
    
    
    [UIView animateWithDuration:duration
                     animations:^{
                         self.view.frame = CGRectMake(0, -40, appFrame.size.width, appFrame.size.height);
                         //[[Model shareModel] showCoverView:YES frame:CGRectMake(0, cityName.frame.size.height, selfViewFrame.size.width, selfViewFrame.size.height - cityName.frame.origin.y - cityName.frame.size.height) belowView:cityName enabled:YES];
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)keyBoardHide:(CGRect)frame animationDuration:(NSTimeInterval)duration
{
    
    [UIView animateWithDuration:duration
                     animations:^{
                         self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)clearBoard:(UIButton*)sender
{
    NSLog(@"touch");
    if ([cityName canResignFirstResponder]) {
        [cityName resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
