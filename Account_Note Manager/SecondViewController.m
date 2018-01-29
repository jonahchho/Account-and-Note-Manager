//
//  SecondViewController.m
//  Account_Note Manager
//
//  Created by Jonah on 2015/1/8.
//  Copyright (c) 2015年 CYCU. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "AccountViewController.h"
#import "NoteViewController.h"
#import "TotalViewController.h"
#import "RecordAudioViewController.h"
#import "RecordVideoViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

@synthesize secondDisplayTime;
@synthesize accountButton;
@synthesize noteButton;
@synthesize backButton;
@synthesize passMessage;
@synthesize passYear;
@synthesize passMonth;
@synthesize passDay;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.secondDisplayTime.text = passMessage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.secondDisplayTime = nil;
    self.accountButton = nil;
    self.noteButton = nil;
    self.backButton = nil;
    
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"Account"]){
        
         AccountViewController *accountViewController = (AccountViewController *)segue.destinationViewController;
        accountViewController.passMessage = passMessage;
        
        accountViewController.passYear = passYear;
        accountViewController.passMonth = passMonth;
        accountViewController.passDay = passDay;

        // here you have passed the value //
        
    } // if
    
    if([segue.identifier isEqualToString:@"Note"]){
        
        NoteViewController *noteViewController = (NoteViewController *)segue.destinationViewController;
        
        noteViewController.passMessage = passMessage;
        noteViewController.passYear = passYear;
        noteViewController.passMonth = passMonth;
        noteViewController.passDay = passDay;

        // here you have passed the value //
        
    } // if
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
