//
//  AccountViewController.h
//  Account_Note Manager
//
//  Created by Jonah on 2015/1/8.
//  Copyright (c) 2015年 CYCU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *accountDisplayTime;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeLeft;

@property (strong, nonatomic) IBOutlet UIPickerView *accountKindPicker;

@property (strong, nonatomic) IBOutlet UITextField *typeMoney;

@property (strong, nonatomic) IBOutlet UIButton *enterButton;

@property (strong, nonatomic) IBOutlet UILabel *displayTotal;

@property (strong, nonatomic) IBOutlet UIButton *homeButton;

@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) NSArray *kindType;

@property (copy, nonatomic) NSString * passMessage;

@property (copy, nonatomic) NSString * passYear;

@property (copy, nonatomic) NSString * passMonth;

@property (copy, nonatomic) NSString * passDay;

- (NSString *) dataFilePath;

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

- (IBAction)swipeLeftTrigger:(id)sender;

- (IBAction)clickEnterButton:(id)sender;

- (IBAction)clickHomeButton:(id)sender;

- (IBAction)clickBackButton:(id)sender;

- (IBAction)keyboardDismiss:(id)sender;

@end
