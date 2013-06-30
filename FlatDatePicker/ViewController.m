//
//  ViewController.m
//  FlatDatePicker
//
//  Created by Christopher Ney on 25/05/13.
//  Copyright (c) 2013 Christopher Ney. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"FlatDatePicker";
    NSArray *cities = @[@"Rio de Janeiro", @"Búzios", @"Angra dos Reis", @"Paraty", @"Petrópolis", @"Tiradentes", @"São Paulo"];
    self.flatDatePicker = [[FlatListPicker alloc] initWithParentView:self.view andCities:cities initialSelected:2];
//    self.flatDatePicker.openFromTop = YES;
    self.flatDatePicker.delegate = self;
    self.flatDatePicker.title = @"Selecione uma cidade:";
}

- (IBAction)actionOpen:(id)sender {
    
    [self.flatDatePicker show];
}

- (IBAction)actionClose:(id)sender {
    
    [self.flatDatePicker dismiss];
}

- (IBAction)actionSetDate:(id)sender {
    
    if (self.flatDatePicker.isOpen) {
         [self.flatDatePicker setCity:@"Paraty" animated:YES];
    } else {
         [self.flatDatePicker setCity:@"Paraty" animated:NO];
    }
}

#pragma mark - FlatDatePicker Delegate

- (void)flatDatePicker:(FlatListPicker*)datePicker cityDidChange:(NSString*)city {
    
    self.labelDateSelected.text = city;
}

- (void)flatDatePicker:(FlatListPicker*)datePicker didCancel:(UIButton*)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"FlatDatePicker" message:@"Did cancelled !" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)flatDatePicker:(FlatListPicker*)datePicker didValid:(UIButton*)sender city:(NSString*)city {
    
            
    self.labelDateSelected.text = city;
    
    NSString *message = [NSString stringWithFormat:@"Did valid city : %@", city];
  
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"FlatDatePicker" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
