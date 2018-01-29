//
//  RecordAudioViewController.h
//  Account_Note Manager
//
//  Created by Jonah on 2015/1/13.
//  Copyright (c) 2015年 CYCU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RecordAudioViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *audioRecorderDisplayTime;

@property (strong, nonatomic) IBOutlet UITextField *infoTextField;

@property (strong, nonatomic) IBOutlet UIButton *playButton;

@property (strong, nonatomic) IBOutlet UIButton *stopButton;

@property (strong, nonatomic) IBOutlet UIButton *pauseButton;

@property (strong, nonatomic) IBOutlet UIButton *startRecorderButton;

@property (strong, nonatomic) IBOutlet UIButton *endRecorderButton;

@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (copy, nonatomic) NSString * passMessage;

@property (copy, nonatomic) NSString * passYear;

@property (copy, nonatomic) NSString * passMonth;

@property (copy, nonatomic) NSString * passDay;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

- (IBAction)clickPlayButton:(id)sender;

- (IBAction)clickStopButton:(id)sender;

- (IBAction)clickPauseButton:(id)sender;

- (IBAction)clickStartRecorderButton:(id)sender;

- (IBAction)clickEndRecorderButton:(id)sender;

- (IBAction)clickBackButton:(id)sender;

@end
