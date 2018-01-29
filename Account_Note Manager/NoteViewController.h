//
//  NoteViewController.h
//  Account_Note Manager
//
//  Created by Jonah on 2015/1/11.
//  Copyright (c) 2015年 CYCU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface NoteViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *noteDisplayTime;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeRight;

@property (strong, nonatomic) IBOutlet UITextField *typeNote;

@property (strong, nonatomic) IBOutlet UIButton *recordAudioButton;

@property (strong, nonatomic) IBOutlet UIButton *homeButton;

@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) IBOutlet UIButton *enterButton;

@property (strong, nonatomic) IBOutlet UIButton *cleanTopButton;

@property (strong, nonatomic) IBOutlet UIButton *cleanBottomButton;

@property (strong, nonatomic) IBOutlet UIScrollView *scroller;

@property (strong, nonatomic) IBOutlet UITableView *noteTable;

@property (strong, nonatomic) NSMutableArray *TabelDatas;

@property (copy, nonatomic) NSString * passMessage;

@property (copy, nonatomic) NSString * passYear;

@property (copy, nonatomic) NSString * passMonth;

@property (copy, nonatomic) NSString * passDay;

- (NSString *) dataFilePath;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

- (NSArray *) statementtoMSarray:(sqlite3_stmt *) sqlstmt;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (IBAction)swipeRightTrigger:(id)sender;

- (IBAction)clickHomeButton:(id)sender;

- (IBAction)clickBackButton:(id)sender;

- (IBAction)clickEnterButton:(id)sender;

- (IBAction)clickCleanTopButton:(id)sender;

- (IBAction)clickCleanBottomButton:(id)sender;

- (IBAction)keyboardDismiss:(id)sender;

@end
