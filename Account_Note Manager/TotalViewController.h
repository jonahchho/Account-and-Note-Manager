//
//  TotalViewController.h
//  Account_Note Manager
//
//  Created by Jonah on 2015/1/12.
//  Copyright (c) 2015年 CYCU. All rights reserved.
//

#import <UIKit/UIKit.h>

#define yearComponent 0
#define monthComponent 1
#define timeComponent 2
#define kindComponent 3

@interface TotalViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *totalDisplayTime;

@property (strong, nonatomic) IBOutlet UIPickerView *totalPicker;

@property (strong, nonatomic) IBOutlet UILabel *displayCalculation;

@property (strong, nonatomic) IBOutlet UIButton *homeButton;

@property (strong, nonatomic) IBOutlet UIButton *selectButton;

@property (strong, nonatomic) NSArray *yearType;

@property (strong, nonatomic) NSArray *monthType;

@property (strong, nonatomic) NSArray *timeType;

@property (strong, nonatomic) NSArray *kindType;

- (NSString *) dataFilePath;

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

- (IBAction)clickHomeButton:(id)sender;

- (IBAction)clickSelectButton:(id)sender;

@end
