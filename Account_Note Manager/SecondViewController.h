//
//  SecondViewController.h
//  Account_Note Manager
//
//  Created by Jonah on 2015/1/8.
//  Copyright (c) 2015年 CYCU. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *secondDisplayTime;

@property (strong, nonatomic) IBOutlet UIButton *accountButton;

@property (strong, nonatomic) IBOutlet UIButton *noteButton;

@property (strong, nonatomic) IBOutlet UIButton *backButton;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@property (copy, nonatomic) NSString * passMessage;

@property (copy, nonatomic) NSString * passYear;

@property (copy, nonatomic) NSString * passMonth;

@property (copy, nonatomic) NSString * passDay;

@end
