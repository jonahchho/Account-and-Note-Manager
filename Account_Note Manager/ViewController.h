//
//  ViewController.h
//  Account_Note Manager
//
//  Created by Jonah on 2015/1/7.
//  Copyright (c) 2015年 CYCU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

#define yearComponent 0
#define monthComponent 1
#define dayComponent 2

@interface ViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *calculateButton;

@property (strong, nonatomic) IBOutlet UIButton *alertButton;

@property (strong, nonatomic) IBOutlet UIPickerView *Picker;

@property (strong, nonatomic) IBOutlet UIButton *selectButton;

@property (strong, nonatomic) IBOutlet UILabel *displayTime;

@property (strong, nonatomic) NSArray *yearType;

@property (strong, nonatomic) NSArray *monthType;

@property (strong, nonatomic) NSArray *dayType;

@property (strong, nonatomic) NSMutableArray *TabelDatas;

- (NSString *) dataFilePath;

- (NSArray *) statementtoMSarray:(sqlite3_stmt *) sqlstmt;

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

- (IBAction)clickCalculateButton:(id)sender;

- (IBAction)clickAlertButton:(id)sender;

- (IBAction)clickButton:(id)sender;

@end

