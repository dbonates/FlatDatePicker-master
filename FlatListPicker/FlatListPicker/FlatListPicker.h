//
//  FlatDatePicker.h
//  FlatDatePicker
//
//  Created by Christopher Ney on 25/05/13.
//  Copyright (c) 2013 Christopher Ney. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlatListPicker;

@protocol FlatDatePickerDelegate<NSObject>
@optional
- (void)flatDatePicker:(FlatListPicker*)datePicker cityDidChange:(NSString*)city;
- (void)flatDatePicker:(FlatListPicker*)datePicker didCancel:(UIButton*)sender;
- (void)flatDatePicker:(FlatListPicker*)datePicker didValid:(UIButton*)sender city:(NSString*)city;
@end


@interface FlatListPicker : UIControl <UIScrollViewDelegate> {
    
    // Parent View :
    UIView *_parentView;
    
    // Header :
    UILabel *_labelTitle;
    UIButton *_buttonClose;
    UIButton *_buttonValid;
    
    // ScrollView :
    UIScrollView *_scollViewMonths;
    
    // Lines :
    UIView *_lineDaysBottom;
    UIView *_lineMonthsTop;
    UIView *_lineMonthsBottom;
    
    // Title :
    NSString *_title;
    
    
    // Labels :
    NSMutableArray *_labelsMonths;
    
    
    // Date selected :
    int _selectedMonth;
    
    
    // City selected
    int _selectedCity;
    
    // First init flag :
    BOOL _isInitialized;
}

@property (nonatomic, strong) NSObject<FlatDatePickerDelegate> *delegate;


@property(nonatomic,readonly) BOOL        isOpen;                 // read only property, indicate in datepicker is open.

@property (nonatomic, strong) NSArray *cidades;

@property(nonatomic,assign) BOOL        openFromTop;

#pragma mark - Initializers

- (id)initWithParentView:(UIView*)parentView andCities:(NSArray *)cities initialSelected:(NSInteger)initialSelected;

#pragma mark - Show and Dismiss

- (void)show;
- (void)dismiss;

#pragma mark - Title DatePicker

- (void)setTitle:(NSString *)title;
- (NSString*)title;

#pragma mark - Date

- (void)setCity:(NSString *)city animated:(BOOL)animated;
- (NSString *)getCity;

@end

