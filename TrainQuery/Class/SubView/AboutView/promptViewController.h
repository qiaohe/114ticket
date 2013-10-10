//
//  promptViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-9-11.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"

typedef NS_OPTIONS(NSInteger, promptType){
    ShowUserProtocol,
    ShowCommonQuestion
};

@interface promptViewController : BaseUIViewController<UIWebViewDelegate>

- (id)initWithPromptType:(promptType)_type;

@property (retain, nonatomic) UIWebView         *webView;
@property (retain, nonatomic) UILabel           *titleLabel;
@property (assign, nonatomic) promptType        type;

- (void)getPrompt;

@end
