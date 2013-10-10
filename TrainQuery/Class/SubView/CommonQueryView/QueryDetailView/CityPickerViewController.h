//
//  CityPickerViewController.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-19.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "BaseUIViewController.h"

typedef NS_OPTIONS(NSInteger, PickType){
    PickStartCity,
    PickEndCity
};

@protocol CityPickerViewDelegate <NSObject>

@optional
- (void)setDataWithParams:(NSString*)params withPickType:(PickType)_pickType;

@end

@interface CityPickerViewController : BaseUIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UISearchBarDelegate>

@property (assign, nonatomic) id <CityPickerViewDelegate> delegate;
@property (assign, nonatomic) PickType    pickType;
@property (retain, nonatomic) UISearchBar *cityName;
@property (retain, nonatomic) UITableView *theTableView;
@property (retain, nonatomic) NSMutableArray *hotCities;

- (void)clearBoard:(UIButton*)sender;

@end
