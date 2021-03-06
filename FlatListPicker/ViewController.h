//
//  ViewController.h
//  FlatDatePicker
//
//  Created by Christopher Ney on 25/05/13.
//  Copyright (c) 2013 Christopher Ney. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FlatListPicker.h"

@interface ViewController : UIViewController <FlatDatePickerDelegate>

@property (nonatomic, strong) FlatListPicker *flatDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *labelDateSelected;

- (IBAction)actionOpen:(id)sender;
- (IBAction)actionClose:(id)sender;
- (IBAction)actionSetDate:(id)sender;

@end
