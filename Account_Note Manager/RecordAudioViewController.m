//
//  RecordAudioViewController.m
//  Account_Note Manager
//
//  Created by Jonah on 2015/1/13.
//  Copyright (c) 2015年 CYCU. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "AccountViewController.h"
#import "NoteViewController.h"
#import "TotalViewController.h"
#import "RecordAudioViewController.h"
#import "RecordVideoViewController.h"

@interface RecordAudioViewController ()

@end

@implementation RecordAudioViewController {
    AVAudioPlayer*   myAudioPlayer;
    AVAudioRecorder* myAudioRecorder;
    NSString*        strAudioFilePath;
    NSURL*           fileURL;
}

@synthesize audioRecorderDisplayTime;
@synthesize infoTextField;
@synthesize playButton;
@synthesize stopButton;
@synthesize pauseButton;
@synthesize startRecorderButton;
@synthesize endRecorderButton;
@synthesize backButton;

@synthesize passMessage;
@synthesize passYear;
@synthesize passMonth;
@synthesize passDay;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.audioRecorderDisplayTime.text = passMessage;
    
    self.infoTextField.userInteractionEnabled = NO;
    
    // Do any additional setup after loading the view.
    // 設定錄音與播放的檔案位置
    strAudioFilePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"record.m4a"];
    fileURL = [NSURL fileURLWithPath:strAudioFilePath];
    
    // 啟動Audio Session使這個App可同時有錄音與撥音的能力
    // (須在AudioRecorder進行init之前執行)
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initAudioRecoder {
    NSDictionary* settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              //----Basic Setting
                              [NSNumber numberWithFloat:4100.0],AVSampleRateKey,
                              [NSNumber numberWithInt:kAudioFormatAppleLossless],AVFormatIDKey,
                              [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
                              
                              //----Linear PCM Setting
                              //[NSNumber numberWithInt:32],                 AVLinearPCMBitDepthKey,
                              //[NSNumber numberWithBool:YES],               AVLinearPCMIsBigEndianKey,
                              //[NSNumber numberWithBool:YES],               AVLinearPCMIsFloatKey,
                              //[NSNumber numberWithBool:YES],               AVLinearPCMIsNonInterleaved,
                              
                              //----Audio Encoder Setting
                              //[NSNumber numberWithInt:AVAudioQualityHigh], AVEncoderAudioQualityKey,
                              //[NSNumber numberWithInt:256000],             AVEncoderBitRateKey,
                              //[NSNumber numberWithInt:256000],             AVEncoderBitRatePerChannelKey,
                              
                              //----Sample Rate Converter Setting
                              //[NSNumber numberWithInt:AVAudioQualityHigh], AVSampleRateConverterAudioQualityKey,
                              nil];
    
    myAudioRecorder = [[AVAudioRecorder alloc] initWithURL:fileURL settings:settings error:nil];
    [myAudioRecorder prepareToRecord];
}

- (void) initAudioPlayer {
    myAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    // 準備播放，Player會先準備好用於播放的緩衝區
    [myAudioPlayer prepareToPlay];
    // 設定重復播放次數-1為重復無限次
    myAudioPlayer.numberOfLoops = -1;
    // 音量，Value Range: 0.0 ~ 1.0
    myAudioPlayer.volume = 1.0;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.audioRecorderDisplayTime = nil;
    self.playButton = nil;
    self.stopButton = nil;
    self.pauseButton = nil;
    self.startRecorderButton = nil;
    self.endRecorderButton = nil;
    self.backButton = nil;
}

-(BOOL)shouldAutorotate {
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    
    if([segue.identifier isEqualToString:@"RecordAudioToNote"]){
        
        NoteViewController *noteViewController = (NoteViewController *)segue.destinationViewController;
        
        noteViewController.passMessage = passMessage;
        noteViewController.passYear = passYear;
        noteViewController.passMonth = passMonth;
        noteViewController.passDay = passDay;
        // here you have passed the value //
        
    } // if
    
}

- (IBAction)clickPlayButton:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loadDate = [defaults objectForKey:@"saveDate"];
    
    [self initAudioPlayer];
    [myAudioPlayer play];
    
    self.infoTextField.text = [NSString stringWithFormat:@"Playing : %.lf sec %@", myAudioPlayer.duration, loadDate];

    
}

- (IBAction)clickStopButton:(id)sender {
    [myAudioPlayer stop];
    self.infoTextField.text = @"Done";
}

- (IBAction)clickPauseButton:(id)sender {
    [myAudioPlayer pause];
    self.infoTextField.text = @"Pause";
}

- (IBAction)clickStartRecorderButton:(id)sender {
    
    NSString *saveDate = [NSString stringWithFormat:@"(Recorded for %d/%d/%d)", [self.passYear intValue], [self.passMonth intValue], [self.passDay intValue]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:saveDate forKey:@"saveDate"];
    [defaults synchronize];
    
    self.infoTextField.text = @"Recording Audio ...";
    [self initAudioRecoder];
    [myAudioRecorder record];
}

- (IBAction)clickEndRecorderButton:(id)sender {
    [myAudioRecorder stop];
    self.infoTextField.text = @"Recording Done";
}

- (IBAction)clickBackButton:(id)sender {
    [myAudioPlayer stop];
    [myAudioRecorder stop];
}
@end
