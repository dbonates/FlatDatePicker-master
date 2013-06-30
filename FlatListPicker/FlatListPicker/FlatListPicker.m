//
//  FlatDatePicker.m
//  FlatDatePicker
//
//  Created by Christopher Ney on 25/05/13.
//  Copyright (c) 2013 Christopher Ney. All rights reserved.
//

#import "FlatListPicker.h"

// Constants times :
#define kFlatDatePickerAnimationDuration 0.4

// Constants colors :
#define kFlatDatePickerBackgroundColor [UIColor colorWithRed:227.0/255.0 green:132.0/255.0 blue:118.0/255.0 alpha:1.0]
#define kFlatDatePickerBackgroundColorTitle [UIColor colorWithRed:227.0/255.0 green:93./255.0 blue:74.0/255.0 alpha:1.000]
#define kFlatDatePickerBackgroundColorButtonValid [UIColor colorWithRed:49.0/255.0 green:180.0/255.0 blue:153.0/255.0 alpha:1.000]
#define kFlatDatePickerBackgroundColorButtonCancel [UIColor colorWithRed:227.0/255.0 green:132.0/255.0 blue:118.0/255.0 alpha:1.0]
#define kFlatDatePickerBackgroundColorScrolView [UIColor colorWithRed:227.0/255.0 green:93./255.0 blue:74.0/255.0 alpha:1.000]
#define kFlatDatePickerBackgroundColorLines [UIColor whiteColor]

// Constants fonts colors :
#define kFlatDatePickerFontColorTitle [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]
#define kFlatDatePickerFontColorLabel [UIColor colorWithWhite:1.000 alpha:0.640]
#define kFlatDatePickerFontColorLabelSelected [UIColor whiteColor]

// Constants sizes :
#define kFlatDatePickerHeight 260
#define kFlatDatePickerHeaderHeight 44
#define kFlatDatePickerButtonHeaderWidth 44
#define kFlatDatePickerHeaderBottomMargin 1
#define kFlatDatePickerScrollViewLeftMargin 1
#define kFlatDatePickerScrollViewItemHeight 45
#define kFlatDatePickerLineWidth 2
#define kFlatDatePickerLineMargin 15

// Constants fonts
#define kFlatDatePickerFontTitle [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0]
#define kFlatDatePickerFontLabel [UIFont fontWithName:@"HelveticaNeue-Regular" size:16.0]
#define kFlatDatePickerFontLabelSelected [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0]

// Constants icons
#define kFlatDatePickerIconCancel @"Icon-Close.png"
#define kFlatDatePickerIconValid @"Icon-Check.png"

// Constants :


@interface FlatListPicker ()

- (void)setupControl:(NSInteger)initialSelected;

- (void)buildHeader;


- (void)buildSelectorCitiesOffsetX:(CGFloat)x andWidth:(CGFloat)width;
- (void)buildSelectorLabelsCities;
- (void)removeSelectorCities;


- (void)actionButtonCancel;
- (void)actionButtonValid;


- (void)setScrollView:(UIScrollView*)scrollView atIndex:(int)index animated:(BOOL)animated;
- (void)highlightLabelInArray:(NSMutableArray*)labels atIndex:(int)index;


- (void)singleTapGestureCitiesCaptured:(UITapGestureRecognizer *)gesture;

- (void)animationShowDidFinish;
- (void)animationDismissDidFinish;

@end

@implementation FlatListPicker

#pragma mark - Initializers



-(id)initWithParentView:(UIView*)parentView andCities:(NSArray *)cities initialSelected:(NSInteger)initialSelected
{
    
    _parentView = parentView;
    _cidades = cities;
    
    if ([self initWithFrame:CGRectMake(0.0, _parentView.frame.size.height, _parentView.frame.size.width, kFlatDatePickerHeight)]) {
        [_parentView addSubview:self];
        [self setupControl:initialSelected];
    }
    return self;
}




-(void)setupControl:(NSInteger)initialSelected {
    
    // Set parent View :
    self.hidden = YES;
    
    // Clear old selectors
    [self removeSelectorCities];

    // Background :
    self.backgroundColor = kFlatDatePickerBackgroundColor;
    
    // Header DatePicker :
    [self buildHeader];

    
    
    [self buildSelectorCitiesOffsetX:(0 + kFlatDatePickerScrollViewLeftMargin) andWidth:320];

    // Defaut Date selected :
//    [self setDate:[NSDate date] animated:NO];
    [self setCity:[_cidades objectAtIndex:initialSelected] animated:NO];
}

#pragma mark - Build Header View

- (void)buildHeader {
    
    // Button Cancel
    _buttonClose = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, kFlatDatePickerButtonHeaderWidth, kFlatDatePickerHeaderHeight)];
    _buttonClose.backgroundColor = kFlatDatePickerBackgroundColorButtonCancel;
    [_buttonClose setImage:[UIImage imageNamed:kFlatDatePickerIconCancel] forState:UIControlStateNormal];
    [_buttonClose addTarget:self action:@selector(actionButtonCancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_buttonClose];

    // Button Valid
    _buttonValid = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - kFlatDatePickerButtonHeaderWidth, 0.0, kFlatDatePickerButtonHeaderWidth, kFlatDatePickerHeaderHeight)];
    _buttonValid.backgroundColor = kFlatDatePickerBackgroundColorButtonValid;
    [_buttonValid setImage:[UIImage imageNamed:kFlatDatePickerIconValid] forState:UIControlStateNormal];
    [_buttonValid addTarget:self action:@selector(actionButtonValid) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_buttonValid];

    // Label Title
    _labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(kFlatDatePickerButtonHeaderWidth, 0.0, self.frame.size.width - (kFlatDatePickerHeaderHeight * 2), kFlatDatePickerHeaderHeight)];
    _labelTitle.backgroundColor = kFlatDatePickerBackgroundColorTitle;
    _labelTitle.text = self.title;
    _labelTitle.font = kFlatDatePickerFontTitle;
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    _labelTitle.textColor = kFlatDatePickerFontColorTitle;
    [self addSubview:_labelTitle];
}




#pragma mark - Build Selector Cities

- (void)buildSelectorCitiesOffsetX:(CGFloat)x andWidth:(CGFloat)width {
    
    // ScrollView Months
    
    _scollViewMonths = [[UIScrollView alloc] initWithFrame:CGRectMake(x, kFlatDatePickerHeaderHeight + kFlatDatePickerHeaderBottomMargin, width, self.frame.size.height - kFlatDatePickerHeaderHeight - kFlatDatePickerHeaderBottomMargin)];
    _scollViewMonths.delegate = self;
    _scollViewMonths.backgroundColor = kFlatDatePickerBackgroundColorScrolView;
    _scollViewMonths.showsHorizontalScrollIndicator = NO;
    _scollViewMonths.showsVerticalScrollIndicator = NO;
    [self addSubview:_scollViewMonths];
    
    _lineMonthsTop = [[UIView alloc] initWithFrame:CGRectMake(_scollViewMonths.frame.origin.x + kFlatDatePickerLineMargin, _scollViewMonths.frame.origin.y + (_scollViewMonths.frame.size.height / 2) - (kFlatDatePickerScrollViewItemHeight / 2), width - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineMonthsTop.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineMonthsTop];
    
    _lineDaysBottom = [[UIView alloc] initWithFrame:CGRectMake(_scollViewMonths.frame.origin.x + kFlatDatePickerLineMargin, _scollViewMonths.frame.origin.y + (_scollViewMonths.frame.size.height / 2) + (kFlatDatePickerScrollViewItemHeight / 2), width - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineDaysBottom.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineDaysBottom];
    
    
    // Update ScrollView Data
    [self buildSelectorLabelsCities];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCitiesCaptured:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_scollViewMonths addGestureRecognizer:singleTap];
}

- (void)buildSelectorLabelsCities {
    
    CGFloat offsetContentScrollView = ((self.frame.size.height - kFlatDatePickerHeaderHeight - kFlatDatePickerHeaderBottomMargin) - kFlatDatePickerScrollViewItemHeight) / 2.0;
    
    if (_labelsMonths != nil && _labelsMonths.count > 0) {
        for (UILabel *label in _labelsMonths) {
            [label removeFromSuperview];
        }
    }
    
    _labelsMonths = [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i < _cidades.count; i++) {
        
        UILabel *labelDay = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (i * kFlatDatePickerScrollViewItemHeight) + offsetContentScrollView, _scollViewMonths.frame.size.width, kFlatDatePickerScrollViewItemHeight)];
        
        labelDay.text = [_cidades objectAtIndex:i];
        
        
        
        labelDay.font = kFlatDatePickerFontLabel;
        labelDay.textAlignment = NSTextAlignmentCenter;
        labelDay.textColor = kFlatDatePickerFontColorLabel;
        labelDay.backgroundColor = [UIColor clearColor];
        
        [_labelsMonths addObject:labelDay];
        [_scollViewMonths addSubview:labelDay];
    }
    
    _scollViewMonths.contentSize = CGSizeMake(_scollViewMonths.frame.size.width, (kFlatDatePickerScrollViewItemHeight * _cidades.count) + (offsetContentScrollView * 2));
}

- (void)removeSelectorCities {
    
    if (_scollViewMonths != nil) {
        [_scollViewMonths removeFromSuperview];
        _scollViewMonths = nil;
    }
    if (_lineMonthsTop != nil) {
        [_lineMonthsTop removeFromSuperview];
        _lineMonthsTop = nil;
    }
    if (_lineMonthsBottom != nil) {
        [_lineMonthsBottom removeFromSuperview];
        _lineMonthsBottom = nil;
    }
}


#pragma mark - Actions 

- (void)actionButtonCancel {
    
    [self dismiss];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(flatDatePicker:didCancel:)]) {
        [self.delegate flatDatePicker:self didCancel:_buttonClose];
    }
}

- (void)actionButtonValid {
    
    [self dismiss];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(flatDatePicker:didValid:city:)]) {
        [self.delegate flatDatePicker:self didValid:_buttonValid city:[self getCity]];
    }
}

#pragma mark - Show and Dismiss

-(void)show {

    if (_parentView != nil) {
        
        if (self.hidden == YES) {
            self.hidden = NO;
        }
        
        if (_isInitialized == NO) {
            
            if (!_openFromTop) {
                self.frame = CGRectMake(self.frame.origin.x, _parentView.frame.size.height, self.frame.size.width, self.frame.size.height);

            }
            else
            {
                self.frame = CGRectMake(self.frame.origin.x, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
                _isInitialized = YES;
            }
            
        }
        
        
        [UIView beginAnimations:@"FlatDatePickerShow" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:kFlatDatePickerAnimationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationShowDidFinish)];
        
        if (!_openFromTop)
        {
            self.frame = CGRectMake(self.frame.origin.x, _parentView.frame.size.height - kFlatDatePickerHeight, self.frame.size.width, self.frame.size.height);
        }
        else
        {
            self.frame = CGRectMake(self.frame.origin.x, 0, self.frame.size.width, self.frame.size.height);
        }
        

        
        [UIView commitAnimations];
    }
}

- (void)animationShowDidFinish {
    _isOpen = YES;
}

-(void)dismiss {
    
    if (_parentView != nil) {
        
        [UIView beginAnimations:@"FlatDatePickerShow" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:kFlatDatePickerAnimationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDismissDidFinish)];
        
        if (!_openFromTop)
        {
            self.frame = CGRectMake(self.frame.origin.x, _parentView.frame.size.height, self.frame.size.width, self.frame.size.height);
        }
        else
        {
            self.frame = CGRectMake(self.frame.origin.x, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
        }
        
        
        [UIView commitAnimations];
    }
}

- (void)animationDismissDidFinish {
    _isOpen = NO;
}




#pragma mark - Title DatePicker

-(void)setTitle:(NSString *)title {
    _title = title;
    _labelTitle.text = _title;
}

-(NSString*)title {
    return _title;
}


#pragma mark - UIScrollView Delegate


- (void)singleTapGestureCitiesCaptured:(UITapGestureRecognizer *)gesture
{
    return;
    // TODO: restaurar o singletap para selecionar o item no picker
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchY = touchPoint.y;

    if (touchY < (_lineMonthsTop.frame.origin.y)) {
        
        if (_selectedCity > 1) {
            _selectedCity -= 1;
            [self setScrollView:_scollViewMonths atIndex:(_selectedCity - 1) animated:YES];
        }
        
    } else if (touchY > (_lineMonthsBottom.frame.origin.y)) {
        
        if (_selectedCity < _cidades.count) {
            _selectedCity += 1;
            [self setScrollView:_scollViewMonths atIndex:(_selectedCity - 1) animated:YES];
        }
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    int index = [self getIndexForScrollViewPosition:scrollView];
    
    [self highlightLabelInArray:_labelsMonths atIndex:index];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    int index = [self getIndexForScrollViewPosition:scrollView];

    [self setScrollView:scrollView atIndex:index animated:YES];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(flatDatePicker:cityDidChange:)]) {
        [self.delegate flatDatePicker:self cityDidChange:[self getCity]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    int index = [self getIndexForScrollViewPosition:scrollView];
    
    [self setScrollView:scrollView atIndex:index animated:YES];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(flatDatePicker:cityDidChange:)]) {
        [self.delegate flatDatePicker:self cityDidChange:[self getCity]];
    }
}



- (int)getIndexForScrollViewPosition:(UIScrollView *)scrollView {

    CGFloat offsetContentScrollView = (scrollView.frame.size.height - kFlatDatePickerScrollViewItemHeight) / 2.0;
    CGFloat offetY = scrollView.contentOffset.y;
    CGFloat index = floorf((offetY + offsetContentScrollView) / kFlatDatePickerScrollViewItemHeight);
    index = (index - 1);
    return index;
}

- (void)setScrollView:(UIScrollView*)scrollView atIndex:(int)index animated:(BOOL)animated {
    
    if (scrollView != nil) {
        
        if (animated) {
            [UIView beginAnimations:@"ScrollViewAnimation" context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:kFlatDatePickerAnimationDuration];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        }
        
        scrollView.contentOffset = CGPointMake(0.0, (index * kFlatDatePickerScrollViewItemHeight));
        
        if (animated) {
            [UIView commitAnimations];
        }
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(flatDatePicker:dateDidChange:)]) {

            [self.delegate flatDatePicker:self cityDidChange:[self getCity]];
        }
    }
}

- (void)highlightLabelInArray:(NSMutableArray*)labels atIndex:(int)index {
    
    if (labels != nil) {
        
        if ((index - 1) >= 0 && index < _cidades.count) {
            UILabel *label = (UILabel*)[labels objectAtIndex:(index - 1)];
            label.textColor = kFlatDatePickerFontColorLabel;
            label.font = kFlatDatePickerFontLabel;
        }
        
        if (index >= 0 && index < labels.count) {
            UILabel *label = (UILabel*)[labels objectAtIndex:index];
            label.textColor = kFlatDatePickerFontColorLabelSelected;
            label.font = kFlatDatePickerFontLabelSelected;
            _selectedCity = index;
        }
        
        if ((index + 1) < labels.count) {
            UILabel *label = (UILabel*)[labels objectAtIndex:(index + 1)];
            label.textColor = kFlatDatePickerFontColorLabel;
            label.font = kFlatDatePickerFontLabel;
        }
    }
}

- (void)setCity:(NSString *)city animated:(BOOL)animated
{
    NSLog(@"Definir cidade: %@", city);
    int index;
    for (int i=0; i<_cidades.count; i++) {
        NSString *cidade = [_cidades objectAtIndex:i];
        if ([cidade isEqualToString:city]) {
            index = i;
        }
    }
    if (city != nil) {
        [self setScrollView:_scollViewMonths atIndex:(index) animated:animated];
        
    }
}


- (NSString *)getCity {
    
    return [_cidades objectAtIndex:_selectedCity];
}

@end
