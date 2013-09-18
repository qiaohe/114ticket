//
//  WapAlipayViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-9-12.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"

@interface WapAlipayViewController : BaseUIViewController<UIWebViewDelegate>

@property (retain, nonatomic) UIWebView         *webView;

- (void)createDirect;

@end
