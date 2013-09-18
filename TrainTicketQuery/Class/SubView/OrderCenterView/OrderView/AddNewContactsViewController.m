//
//  AddNewContactsViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-20.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "AddNewContactsViewController.h"
#import "Model.h"

@interface AddNewContactsViewController ()

@end

@implementation AddNewContactsViewController

@synthesize delegate;
@synthesize passengerName;
@synthesize passenger;
@synthesize ticketManView;
@synthesize ticketChildrenView;

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
    self.delegate   =  nil;
    [passengerName      release];
    [passenger          release];
    [ticketManView      release];
    [ticketChildrenView release];
    [super              dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
    [self initView];
    [self setSubjoinViewFrame];
    [self showDetailViewWithTciketType:TicketMan];
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
    
    UILabel *titleLabel = [self getLabelWithFrame:CGRectMake(80, 0, 160, 40) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] title:@"新增乘客" font:nil];
    [self.view addSubview:titleLabel];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateSelected];
    [returnBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_press" ofType:@"png"]] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(pressReturnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
}

- (void)setSubjoinViewFrame
{
    UIImageView *baseImage1 = [self getImageViewWithFrame:CGRectMake(10, 20 + 40, selfViewFrame.size.width - 20, 60) image:imageNameAndType(@"infoframe_deep", @"png") highLightImage:nil backGroundColor:[UIColor clearColor]];
    UIImageView *baseImage2 = [self getImageViewWithFrame:CGRectMake(10, baseImage1.frame.origin.y + baseImage1.frame.size.height - 6, baseImage1.frame.size.width, baseImage1.frame.size.height) image:imageNameAndType(@"infoframe_light", @"png") highLightImage:nil backGroundColor:[UIColor clearColor]];
    
    [self.view addSubview:baseImage1];
    [self.view addSubview:baseImage2];
    
    
    UILabel *label1 = [self getLabelWithFrame:CGRectMake(baseImage1.frame.origin.x, baseImage1.frame.origin.y, 80, 60) textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] textColor:nil title:@"购买类型" font:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    UILabel *label2 = [self getLabelWithFrame:CGRectMake(baseImage2.frame.origin.x, baseImage2.frame.origin.y, label1.frame.size.width, label1.frame.size.height) textAlignment:label1.textAlignment backGroundColor:label1.backgroundColor textColor:nil title:@"乘客姓名" font:label1.font];
    
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    
    UIImageView *manImage = [self getImageViewWithFrame:CGRectMake(label1.frame.origin.x + label1.frame.size.width, label1.frame.origin.y, 30, 28) image:imageNameAndType(@"passengerselect_normal", @"png") highLightImage:imageNameAndType(@"passengerselect_press", @"png") backGroundColor:[UIColor clearColor]];
    manImage.center = CGPointMake(label1.frame.origin.x + label1.frame.size.width + manImage.frame.size.width/2 + 5, label1.frame.size.height/2 + label1.frame.origin.y);
    manImage.tag = 101;
    [self.view addSubview:manImage];
    UIButton *manButton = [self getButtonWithFrame:CGRectMake(label1.frame.origin.x + label1.frame.size.width, label1.frame.origin.y, (baseImage1.frame.size.width - label1.frame.origin.x - label1.frame.size.width)*2/5, label1.frame.size.height) title:@"成人" textColor:[UIColor blackColor] forState:UIControlStateNormal backGroundColor:[UIColor clearColor]];
    [manButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    manButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    manButton.tag = 201;
    [manButton addTarget:self action:@selector(checkTicketType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:manButton];
    
    UIImageView *childrenImage = [self getImageViewWithFrame:CGRectMake(manButton.frame.origin.x + manButton.frame.size.width, manImage.frame.origin.y, manImage.frame.size.width,  manImage.frame.size.height) image:imageNameAndType(@"passengerselect_normal", @"png") highLightImage:imageNameAndType(@"passengerselect_press", @"png") backGroundColor:[UIColor clearColor]];
    childrenImage.center = CGPointMake(manButton.frame.origin.x + manButton.frame.size.width + childrenImage.frame.size.width/2, manImage.center.y);
    childrenImage.tag = 102;
    [self.view addSubview:childrenImage];
    UIButton *childrenButton = [self getButtonWithFrame:CGRectMake(manButton.frame.origin.x + manButton.frame.size.width, manButton.frame.origin.y, (baseImage1.frame.size.width - label1.frame.origin.x - label1.frame.size.width)*3/5, manButton.frame.size.height) title:@"儿童(2-12岁)" textColor:[UIColor blackColor] forState:UIControlStateNormal backGroundColor:[UIColor clearColor]];
    [childrenButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    childrenButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    childrenButton.tag = 202;
    [childrenButton addTarget:self action:@selector(checkTicketType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:childrenButton];
    
    passengerName = [[UITextField alloc]initWithFrame:CGRectMake(label2.frame.origin.x + label2.frame.size.width + 10, label2.frame.origin.y, baseImage2.frame.size.width - label2.frame.size.width - 10, label2.frame.size.height)];
    passengerName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [passengerName setPlaceholder:@"请输入乘客姓名"];
    [passengerName setDelegate:self];
    passengerName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:passengerName];
    
    ticketManView = [[TicketManViewController alloc]init];
    ticketChildrenView = [[TicketChildrenViewController alloc]init];
    ticketManView.delegate = self;
    ticketChildrenView.delegate = self;
    [self.view addSubview:ticketChildrenView.view];
    [self.view addSubview:ticketManView.view];
    
    ticketManView.passenger.name = passengerName.text;
    ticketChildrenView.passenger.name = passengerName.text;
    
    [self showDetailViewWithTciketType:TicketMan];
}

- (void)checkTicketType:(UIButton*)sender
{
    if (sender.tag == 201) {
        [self showDetailViewWithTciketType:TicketMan];
    }else if (sender.tag == 202) {
        [self showDetailViewWithTciketType:TicketChildren];
    }
}

- (void)showDetailViewWithTciketType:(TrainTicketType)type
{
    UIButton *manButton = (UIButton*)[self.view viewWithTag:201];
    UIButton *childrenButton = (UIButton*)[self.view viewWithTag:202];
    
    UIImageView *image1 = (UIImageView*)[self.view viewWithTag:101];
    UIImageView *image2 = (UIImageView*)[self.view viewWithTag:102];
    
    if (type == TicketMan) {
        childrenButton.enabled = YES;
        manButton.enabled = NO;
        image1.highlighted = YES;
        image2.highlighted = NO;
        ticketManView.view.hidden = NO;
        ticketChildrenView.view.hidden = YES;
    }else if (type == TicketChildren){
        manButton.enabled = YES;
        childrenButton.enabled = NO;
        image1.highlighted = NO;
        image2.highlighted = YES;
        ticketManView.view.hidden = YES;
        ticketChildrenView.view.hidden = NO;
    }
}

- (PassengerInfo*)getSuperPassengerInfo
{
    return passenger;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == passengerName) {
        if (!passenger) {
            passenger = [[PassengerInfo alloc]init];
            passenger.name = passengerName.text;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([passengerName canResignFirstResponder]) {
        [passengerName resignFirstResponder];
    }if (ticketManView) {
        [ticketManView clearKeyboard];
    }if (ticketChildrenView) {
        [ticketChildrenView clearKeyboard];
    }
    return YES;
}

- (void)pressReturnButton:(UIButton*)sender
{
    BaseUIViewController *prevView = [[Model shareModel].viewControllers objectAtIndex:([[Model shareModel].viewControllers indexOfObject:self] - 1)];
    [self resetViewFrame:baseFrame withAnimationDurarion:0.0f];
    [[Model shareModel] pushView:prevView options:ViewTrasitionEffectMoveRight completion:^{
        [[Model shareModel].viewControllers removeObject:self];
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if ([passengerName canResignFirstResponder]) {
        [passengerName resignFirstResponder];
    }if (ticketManView) {
        [ticketManView clearKeyboard];
    }if (ticketChildrenView) {
        [ticketChildrenView clearKeyboard];
    }
}

- (void)reloadData
{
    BaseUIViewController *prevView = [[Model shareModel].viewControllers objectAtIndex:([[Model shareModel].viewControllers indexOfObject:self] - 1)];
    [self resetViewFrame:baseFrame withAnimationDurarion:0.0f];
    [[Model shareModel] pushView:prevView options:ViewTrasitionEffectMoveRight completion:^{
        [[Model shareModel].viewControllers removeObject:self];
        [self.delegate reloadData];
    }];
}

- (void)resetViewFrame:(CGRect)frame withAnimationDurarion:(NSTimeInterval)duration
{
    [UIView beginAnimations:@"resetViewFrame" context:nil];
    [UIView setAnimationDuration:duration];
    [self.view setFrame:frame];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
