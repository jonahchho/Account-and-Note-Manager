//
//  RecordVideoViewController.m
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
#import <MobileCoreServices/MobileCoreServices.h>

@interface RecordVideoViewController ()

@end

@implementation RecordVideoViewController

@synthesize videoRecorderDisplayTime;
@synthesize playButton;
@synthesize recordButton;

@synthesize passMessage;
@synthesize passYear;
@synthesize passMonth;
@synthesize passDay;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.videoRecorderDisplayTime.text = passMessage;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.videoRecorderDisplayTime = nil;
    self.playButton = nil;
    self.recordButton = nil;
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
    
    
    if([segue.identifier isEqualToString:@"RecordVideoToNote"]){
        
        NoteViewController *noteViewController = (NoteViewController *)segue.destinationViewController;
        
        noteViewController.passMessage = passMessage;
        noteViewController.passYear = passYear;
        noteViewController.passMonth = passMonth;
        noteViewController.passDay = passDay;
        // here you have passed the value //
        
    } // if
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:NO completion:NO];
    
    //Handle a movie capture
    if ( CFStringCompare((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo ) {
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        
        if ( UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath) ) {
            UISaveVideoAtPathToSavedPhotosAlbum(moviePath, self, nil, nil);
        } // if
        
    } // if
    
}

- (IBAction)clickPlayButton:(id)sender {
    UIImagePickerController *mediaLibrary = [[UIImagePickerController alloc] init];
    mediaLibrary.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaLibrary.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *) kUTTypeMovie, nil];
    
    mediaLibrary.allowsEditing = NO;
    [self presentViewController:mediaLibrary animated:YES completion:NO];
    
}

- (IBAction)clickRecordButton:(id)sender {
    
    if ( ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [myAlertView show];
        
    } // if
    
    else {
    
        UIImagePickerController *videoScreen = [[UIImagePickerController alloc] init];
        videoScreen.sourceType = UIImagePickerControllerSourceTypeCamera;
    
        // Display movie capture control
        videoScreen.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    
        videoScreen.allowsEditing = NO;
        videoScreen.delegate = self;
    
        [self presentViewController:videoScreen animated:YES completion:NO];
    } // else
    
}
@end
