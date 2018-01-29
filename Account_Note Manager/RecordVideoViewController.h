//
//  RecordVideoViewController.h
//  Account_Note Manager
//
//  Created by Jonah on 2015/1/13.
//  Copyright (c) 2015年 CYCU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordVideoViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *videoRecorderDisplayTime;

@property (strong, nonatomic) IBOutlet UIButton *playButton;

@property (strong, nonatomic) IBOutlet UIButton *recordButton;

@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (copy, nonatomic) NSString * passMessage;

@property (copy, nonatomic) NSString * passYear;

@property (copy, nonatomic) NSString * passMonth;

@property (copy, nonatomic) NSString * passDay;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

- (IBAction)clickPlayButton:(id)sender;

- (IBAction)clickRecordButton:(id)sender;

@end
