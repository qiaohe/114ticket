//
//  BaseUIViewController.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-9.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"
#import "QueryHistory.h"
#import "Utils.h"

@implementation NSString (OAURLEncodingAdditions)
- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}

- (NSString *)URLDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding
                      (kCFAllocatorDefault,                                                 
                       (CFStringRef)self, CFSTR(""),                                       
                       kCFStringEncodingUTF8));
    result = [result stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    
    return result;
    /*
    NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
    [result autorelease];
    return result;*/
} 
@end
@interface BaseUIViewController ()

@end

@implementation BaseUIViewController
@synthesize dataString;

- (void)setUp
{
    
}

- (void)saveViewData
{
    
}

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
        [self.view setFrame:appFrame];
        _contentView = [[BaseContentView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _contentView.superResponder = self;
        _contentView.hidden = YES;
        [self.view addSubview:_contentView];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    if (dataString)  [dataString      release];
    [super                            dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - date format transform
- (NSString *)stringWithDate:(NSDate*)date
{
    NSDateFormatter *dateFormate = [[[NSDateFormatter alloc]init]autorelease];
    [dateFormate setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormate stringFromDate:date];
    return dateString;
}

- (NSDate*)dateWithString:(NSString *)date
{
    NSDateFormatter *dateFormate = [[[NSDateFormatter alloc]init]autorelease];
    [dateFormate setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateString = [dateFormate dateFromString:date];
    return dateString;
}

- (TrainType)checkTrainTypeWithParams:(NSString*)_type
{
    if ([_type characterAtIndex:0] == 'G' || [_type characterAtIndex:0] == 'D') {
        //NSLog(@"equal");
        return trainTypeHeightSpeed;
    }else{
        //NSLog(@"normal");
        return trainTypeNormalSpeed;
    }
}

- (NSString*)checkIdCardTypeWithValue:(NSInteger)_type
{
    switch (_type) {
        case 0:{
            return @"身份证";
            break;
        }case 1:{
            return @"护照";
            break;
        }case 2:{
            return @"港澳通行证";
            break;
        }
        default:
            return @"";
            break;
    }
}

- (NSString*)checkIdCardTypeWithString:(NSString*)_type
{
    if ([_type isEqualToString:@"身份证"]) {
        return @"0";
    }else if ([_type isEqualToString:@"护照"]){
        return @"1";
    }else {
        return @"2";
    }
}

- (UIColor *)getColor:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (NSString*)getTrainTypeWithParams:(NSString*)_string
{
    if ([_string characterAtIndex:0] == 'G') {
        return [[@"高速" retain]autorelease];
    }else if ([_string characterAtIndex:0] == 'D') {
        return [[@"动车" retain]autorelease];
    }else if ([_string characterAtIndex:0] == 'T') {
        return [[@"特快" retain]autorelease];
    }else if ([_string characterAtIndex:0] == 'Z') {
        return [[@"直达" retain]autorelease];
    }else if ([_string characterAtIndex:0] == 'K') {
        return [[@"空调快车" retain]autorelease];
    }else if ([_string characterAtIndex:0] == 'C') {
        return [[@"城际列车" retain]autorelease];
    }else if ([_string characterAtIndex:0] == 'L') {
        return [[@"临客" retain]autorelease];
    }else {
        return [[@"其他" retain]autorelease];
    }
}


- (NSString*) getStatusWithTrainOrder:(TrainOrder*)order
{
    NSString *status = nil;
    switch (order.orderStatus) {
        case 1://未付款
            status = @"未付款";
            break;
        case 2://已付款
            status = @"已付款";
            break;
        case 4://票款不足
            status = @"票款不足";
            break;
        case 5://网上待付
            status = @"网上待付";
            break;
        case 6://无票
            status = @"无票";
            break;
        case 7://已补款
            status = @"已补款";
            break;
        case 10://出票成功
            status = @"出票成功";
            break;
        case 11://申请退票
            status = @"申请退票";
            break;
        case 12://退票完成
            status = @"退票完成";
            break;
        case -1:
            status = @"支付超时";
            break;
        default:
            status = nil;
            break;
    }
    return status;
}


#pragma mark - reload data
- (void)reloadTableView:(UITableView*)tableView scrollToTop:(BOOL)scroll
{
    [tableView reloadData];
    if (scroll) {
        [tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

#pragma mark - custom method
- (UILabel*)getLabelWithFrame:(CGRect)frame
                textAlignment:(NSTextAlignment)alignment
              backGroundColor:(UIColor*)backColor
                    textColor:(UIColor*)textColor
                        title:(NSString*)title
                         font:(UIFont*)font
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    if (alignment) {
        label.textAlignment = alignment;
    }if (backColor) {
        label.backgroundColor = backColor;
    }if (textColor){
        label.textColor = textColor;
    }if (title) {
        label.text = title;
    }if (font) {
        [label setFont:font];
    }return [label autorelease];
}

- (UIImageView*)getImageViewWithFrame:(CGRect)frame
                                image:(UIImage*)image
                     highLightImage:(UIImage*)highLightImage
                      backGroundColor:(UIColor*)backColor
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    if (image) {
        [imageView setImage:image];
    }if (highLightImage) {
        [imageView setHighlightedImage:highLightImage];
    }if (backColor) {
        [imageView setBackgroundColor:backColor];
    }return [imageView autorelease];
}

- (UIButton*)getButtonWithFrame:(CGRect)frame
                          title:(NSString*)title
                      textColor:(UIColor*)textColor
                       forState:(UIControlState)state
                backGroundColor:(UIColor*)backColor
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    if (title) {
        [button setTitle:title forState:state];
    }if (textColor) {
        [button setTitleColor:textColor forState:state];
    }if (backColor) {
        [button setBackgroundColor:backColor];
    }
    
    return [[button retain]autorelease];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)dataSource:(NSArray*)dataSource ContainsObject:(QueryHistory*)object
{
    for (QueryHistory *e in dataSource) {
        if (([e.startCity isEqualToString:object.startCity] && [e.endCity isEqualToString:object.endCity]) || [e.trainCode isEqualToString:object.trainCode]) {
            return e;
        }
    }return nil;
}

#pragma mark - request data

- (void)getAllTrainCodeAndPriceWithParams:(QueryHistory*)_history withUserInfo:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@?getAllTrainCodeAndPrice",TrainOrderServiceURL];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _history.startCity,     @"fromStation",
                            _history.endCity,       @"toStation",
                            _history.startDate,     @"godate",
                            //@"application/json",    @"response",
                            nil];
    [self sendRequestWithURL:urlString params:params requestMethod:RequestPost userInfo:userInfo];
}

- (void)getTrainCodeAndPriceWithParams:(QueryHistory*)_history withUserInfo:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@?getTrainInfo",TrainOrderServiceURL];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _history.trainCode,     @"trainCode",
                            nil];
    [self sendRequestWithURL:urlString params:params requestMethod:RequestPost userInfo:userInfo];
}

- (void)getAllGaotieTrainCodeAndPriceWithParams:(QueryHistory*)_history withUserInfo:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@?getAllGaotieTrainCodeAndPrice",TrainOrderServiceURL];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _history.startCity,     @"fromStation",
                            _history.endCity,       @"toStation",
                            _history.startDate,     @"godate",
                            //@"application/json",    @"response",
                            nil];
    [self sendRequestWithURL:urlString params:params requestMethod:RequestPost userInfo:userInfo];
}

- (void)getGaotieTrainCodeAndPriceWithParams:(QueryHistory*)_history withUserInfo:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@?getTrainInfo",TrainOrderServiceURL];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _history.trainCode,     @"trainCode",
                            nil];
    [self sendRequestWithURL:urlString params:params requestMethod:RequestPost userInfo:userInfo];
}

- (void)sendRequestWithURL:(NSString*)URLString params:(NSDictionary*)params requestMethod:(RequestType)requestType userInfo:(NSDictionary*)userInfo
{
    if (requestType == RequestGet) {
        NSMutableDictionary *cookie = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [UserDefaults shareUserDefault].cookie,  @"Cookie",
                                       nil];
        NSString *urlParams = @"";
        if (params != nil) {
            NSArray *keys = [params allKeys];
            for (NSString *key in keys) {
                urlParams = [urlParams stringByAppendingFormat:@"%@=%@",key,[params objectForKey:key]];
                if (key != [keys lastObject]) {
                    urlParams = [urlParams stringByAppendingString:@"&"];
                }
            }
            if (urlParams) {
                URLString = [URLString stringByAppendingFormat:@"?%@",urlParams];
            }
        }
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:URLString]];
        [request setUserInfo:userInfo];
        [request setTimeOutSeconds:10];
        [request setRequestHeaders:cookie];
        [request setUseCookiePersistence:NO];
        [request setDelegate:self];
        [request startAsynchronous];
        [request release];
    }else if (requestType == RequestPost || requestType == RequestLogIn){

        ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:URLString]];
        [request setUserInfo:userInfo];
        NSArray *keys = [params allKeys];
        for (NSString *key in keys) {
            [request setPostValue:[params objectForKey:key] forKey:key];
        }
        [request setDelegate:self];
        if (requestType != RequestLogIn) {
            NSMutableDictionary *cookie = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           [Utils NULLToEmpty:[UserDefaults shareUserDefault].cookie],  @"Cookie",
                                           nil];
            [request setRequestHeaders:cookie];
        }
        [request setTimeOutSeconds:10];
        [request setUseCookiePersistence:NO];
        [request startAsynchronous];
        [request release];
    }else if (requestType == RequestLogOut){
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URLString]];
        request.requestHeaders = [NSMutableDictionary dictionaryWithDictionary:params];
        [request setUserInfo:userInfo];
        [request setUseCookiePersistence:NO];
        [request setTimeOutSeconds:10];
        request.delegate = self;
        [request startAsynchronous];
    }
    self.view.userInteractionEnabled = NO;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    self.view.userInteractionEnabled = YES;
    [self requestDone:request];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    self.view.userInteractionEnabled = YES;
    [self requestError:request];
}

- (void)requestDone:(ASIHTTPRequest*)request
{
    //subview inherit this method to do request finished handle
}
- (void)requestError:(ASIHTTPRequest*)request
{
    //subview inherit this method to do request finished handle
}

- (void)parserStringBegin:(ASIHTTPRequest*)request
{
    XMLParser *parser = [[XMLParser alloc]initWithData:[request.responseString dataUsingEncoding:NSUTF8StringEncoding]];
    if (request.userInfo) {
        [parser setUserInfo:request.userInfo];
    }
    [parser setRequest:request];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser setDelegate:self];
    [parser parse];
    [parser release];
}

- (void)parserStringFinished:(NSString*)_string request:(ASIHTTPRequest*)request
{
    //subview inherit
}

#pragma mark - XML  Parser
//该方法将在开始parse之前调用，用处是可以在其中对相应的对象进行分配和初始化;
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    
}

//该方法将在parse期间碰到元素开始标志"<xxx"时调用，用于元素属性获取，其中elementName为元素名，attributeDict为相应的属性集合;
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if ([elementName isEqualToString:@"ns:return"]) {
        if (dataString) {
            [dataString release];
        }dataString = [[NSMutableString alloc]init];
    }
}

//该方法是在遇到元素结束标志"</xxx>"调用;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"ns:return"]) {
        XMLParser *_parser = (XMLParser*)parser;
        [self parserStringFinished:dataString request:_parser.request];
    }
}

//该方法是遇到元素值时调用，通过它可以获取元素内容;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)_string
{
    [dataString appendString:_string];
}

//该方法将在parse结束后调用，用处是进行相应的资源释放和处理;
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
}

#pragma mark - keyboard handle
- (void)keyBoardWillShow:(NSNotification *)notification
{
    //subview rewrite
}

- (void)keyBoardWillHide:(NSNotification *)notification
{
    //subview rewrite
}

- (void)keyBoardChangeFrame:(NSNotification *)notification
{
    //subview rewrite
}

- (void)tableViewReload:(UITableView*)tableView dataSource:(NSArray*)dataSource
{
    [tableView reloadData];
    if (![dataSource count]) {
        tableView.hidden = YES;
    }else{
        tableView.hidden = NO;
    }
}

- (void)pushViewController:(BaseUIViewController*)_viewController completion:(void (^) (void))_completionhandler
{
    [self.navigationController pushViewController:_viewController animated:YES];
    [self performBlock:_completionhandler afterDelay:0.35f];
}
- (void)popViewControllerCompletion:(void (^) (void))_completionhandler
{
    [self.navigationController popViewControllerAnimated:YES];
    [self performBlock:_completionhandler afterDelay:0.35f];
}
- (void)performBlock:(void (^)(void))block
          afterDelay:(NSTimeInterval)delay
{
    block = [[block copy] autorelease];
    [self performSelector:@selector(fireBlockAfterDelay:)
               withObject:block
               afterDelay:delay];
}

- (void)fireBlockAfterDelay:(void (^)(void))block {
    if (block) {
        block();
    }
}


- (void)pushToViewController:(BaseUIViewController*)viewController completion:(void (^) (void))completionhandler
{
    [self pushViewController:viewController completion:completionhandler];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

@end

#pragma mark - base content view
@implementation BaseContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _baseRect = frame;
    }
    return self;
}

- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
    UIView *largeHeight = _largeHeight;
    UIView *largeWidth  = _largeWidth;
    if (!_largeHeight ) {
        largeHeight = self;
    }if (!_largeWidth) {
        largeWidth = self;
    }
    if (controlXLength(largeWidth) < controlXLength(view)) {
        [self setXSize];
    }if (controlYLength(largeHeight) < controlYLength(view)) {
        [self setYSize];
    }
}

- (void)removeSubview:(UIView*)subview
{
    [subview removeFromSuperview];
    [self resetContentSize];
}

- (void)removeAllSubview
{
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    [self resetContentSize];
}

- (void)resetContentSize
{
    [self setXSize];
    [self setYSize];
}

- (void)setXSize
{
    if ([self.subviews count] != 0) {
        NSComparator cmptr = ^(UIView *obj1, UIView *obj2){
            if (controlXLength(obj1) >= controlXLength(obj2)) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if (controlXLength(obj1) < controlXLength(obj2)) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        NSArray *array = [self.subviews sortedArrayUsingComparator:cmptr];
        
        self.largeWidth = [array lastObject];
        
        CGFloat contentWidth = controlXLength(_largeWidth) > self.frame.size.width?controlXLength(_largeWidth) + 10:self.frame.size.width;
        
        [self setContentSize:CGSizeMake(contentWidth,self.contentSize.height)];
    }else{
        [self setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
    }
}

- (void)setYSize
{
    if ([self.subviews count] != 0) {
        NSComparator cmptr = ^(UIView *obj1, UIView *obj2){
            if (controlYLength(obj1) >= controlYLength(obj2)) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if (controlYLength(obj1) < controlYLength(obj2)) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        NSArray *array = [self.subviews sortedArrayUsingComparator:cmptr];
        
        _largeHeight = [array lastObject];
        
        CGFloat contentHeight = controlYLength(_largeHeight) > self.frame.size.width?controlYLength(_largeHeight) + 15:self.frame.size.width;
        
        [self setContentSize:CGSizeMake(self.contentSize.width, contentHeight)];
    }else{
        [self setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
    }
}

- (NSInteger)getXPageNum:(UIView*)view
{
    CGFloat pageNum = controlXLength(view)/self.frame.size.width;
    NSInteger integerNum = [[NSString stringWithFormat:@"%.0f",pageNum] integerValue];
    integerNum = pageNum > integerNum ? integerNum + 1 : integerNum;
    
    return integerNum > 0?integerNum:1;
}

- (NSInteger)getYPageNum:(UIView*)view
{
    CGFloat pageNum = controlYLength(view)/self.frame.size.width;
    NSInteger integerNum = [[NSString stringWithFormat:@"%.0f",pageNum] integerValue];
    integerNum = pageNum > integerNum ? integerNum + 1 : integerNum;
    
    return integerNum > 0?integerNum:1;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.superResponder touchesEnded:touches withEvent:event];
}

- (void)dealloc
{
    self.superResponder     = nil;
    [_largeWidth            release];
    [_largeHeight           release];
    [super                  dealloc];
}

@end

