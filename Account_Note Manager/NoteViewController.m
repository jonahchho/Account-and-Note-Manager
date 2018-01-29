//
//  NoteViewController.m
//  Account_Note Manager
//
//  Created by Jonah on 2015/1/11.
//  Copyright (c) 2015年 CYCU. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "AccountViewController.h"
#import "NoteViewController.h"
#import "TotalViewController.h"
#import "RecordAudioViewController.h"
#import "RecordVideoViewController.h"
#import <sqlite3.h>

#define Filename @"store.sqlite3"

@interface NoteViewController ()

@end

@implementation NoteViewController
@synthesize noteDisplayTime;
@synthesize swipeRight;
@synthesize typeNote;
@synthesize homeButton;
@synthesize backButton;
@synthesize enterButton;
@synthesize cleanTopButton;
@synthesize cleanBottomButton;
@synthesize scroller;
@synthesize noteTable;
@synthesize TabelDatas;

@synthesize passMessage;
@synthesize passYear;
@synthesize passMonth;
@synthesize passDay;


sqlite3 *dataBase;

- (NSString *) dataFilePath {  // 資料庫路徑
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:Filename];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightTrigger:)];
    [self.swipeRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:swipeRight];

    sqlite3_stmt *stmt;
    
    char *errorMsg;
    
    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS NOTE(ID INTEGER PRIMARY KEY AUTOINCREMENT, DATE TEXT, DATA TEXT)";  // 創造table,如果已存在會忽略
    
    char *querySQL = "SELECT * FROM NOTE WHERE DATE=?";
    
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320,1000)];
    
    self.noteDisplayTime.text = passMessage;
    
    if ( sqlite3_open([[self dataFilePath] UTF8String], &dataBase) != SQLITE_OK ) {  // 開啟資料庫
        sqlite3_close(dataBase);
        NSLog(@"Failed to open dataBase");
    } // if
    
    
    if ( sqlite3_exec(dataBase, [createSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK ) { // 創造table
        sqlite3_close(dataBase);
        NSLog(@"Error creating table: %s", errorMsg);
    } // if
    
    self.noteTable.delegate = self;
    self.noteTable.dataSource = self;
    
    if ( sqlite3_prepare_v2(dataBase, querySQL, -1, &stmt, nil) == SQLITE_OK ) {
        
        sqlite3_bind_text(stmt, 1, [self.passMessage UTF8String], -1, NULL);
        
        self.TabelDatas = [self statementtoMSarray:stmt];
        
        sqlite3_finalize(stmt);
        
        [self.noteTable reloadData];
        
    } // if
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.noteDisplayTime = nil;
    self.typeNote = nil;
    self.homeButton = nil;
    self.backButton = nil;
    self.enterButton = nil;
    self.cleanTopButton = nil;
    self.cleanBottomButton = nil;
    self.scroller = nil;
    self.noteTable = nil;
    self.TabelDatas = nil;
    
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"NoteBackToSecond"]){
        
        SecondViewController *secondViewController = (SecondViewController *)segue.destinationViewController;
        
        secondViewController.passMessage = self.passMessage;
        secondViewController.passYear = self.passYear;
        secondViewController.passMonth = self.passMonth;
        secondViewController.passDay = self.passDay;
        
        // here you have passed the value
        
    } // if
    
    if([segue.identifier isEqualToString:@"NoteToRecordAudio"]){
        
        RecordAudioViewController *recordAudioViewController = (RecordAudioViewController *)segue.destinationViewController;
        
        recordAudioViewController.passMessage = self.passMessage;
        recordAudioViewController.passYear = self.passYear;
        recordAudioViewController.passMonth = self.passMonth;
        recordAudioViewController.passDay = self.passDay;
        
        // here you have passed the value //
        
    } // if
    
    if([segue.identifier isEqualToString:@"NoteToRecordVideo"]){
        
        RecordVideoViewController *recordVideoViewController = (RecordVideoViewController *)segue.destinationViewController;
        
        recordVideoViewController.passMessage = self.passMessage;
        recordVideoViewController.passYear = self.passYear;
        recordVideoViewController.passMonth = self.passMonth;
        recordVideoViewController.passDay = self.passDay;
        
        // here you have passed the value //
        
    } // if
    
    if([segue.identifier isEqualToString:@"SwipeToAccount"]){
        
        NoteViewController *noteViewController = (NoteViewController *)segue.destinationViewController;
        
        noteViewController.passMessage = self.passMessage;
        noteViewController.passYear = self.passYear;
        noteViewController.passMonth = self.passMonth;
        noteViewController.passDay = self.passDay;
        
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

- (NSArray *) statementtoMSarray:(sqlite3_stmt *) sqlstmt{
    
    self.TabelDatas = [[NSMutableArray alloc]init];
    
    NSString *data;
    
    while ( sqlite3_step(sqlstmt) == SQLITE_ROW ) {
        
        data = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlstmt,2)];
        
        [self.TabelDatas addObject:data];
        
    } // while
    
    return self.TabelDatas;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //這個方法是用來指定每個Section裡面有多少Rows

    return [self.TabelDatas count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil){

        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    } // if

    //Configure the cell.

    cell.textLabel.text = [self.TabelDatas objectAtIndex:[indexPath row]];

    return cell;

}

- (IBAction)swipeRightTrigger:(id)sender {
    [self performSegueWithIdentifier:@"SwipeToAccount" sender:self];
    
}

- (IBAction)clickHomeButton:(id)sender {
    sqlite3_close(dataBase);
}

- (IBAction)clickBackButton:(id)sender {
    sqlite3_close(dataBase);
}

- (IBAction)clickEnterButton:(id)sender {
    
    sqlite3_stmt *stmt;
    
    char *insertSQL = "INSERT INTO NOTE(DATE, DATA) VALUES(?,?)";
    
    char *deleteSQL = "DELETE FROM NOTE";
    
    char *dropSQL = "DROP TABLE NOTE";
    
    char *querySQL = "SELECT * FROM NOTE WHERE DATE=?";
    /*
    // DELETE PART
    
    if ( sqlite3_prepare_v2(dataBase, deleteSQL, -1, &stmt, nil) == SQLITE_OK ) {
     while (sqlite3_step(stmt) == SQLITE_ROW);
    } // if
     
    sqlite3_finalize(stmt);
    */
    
    if ( [self.typeNote.text isEqual:@""] );
    
    else {
        
        if ( sqlite3_prepare_v2(dataBase, insertSQL, -1, &stmt, nil) == SQLITE_OK ) {
            
            sqlite3_bind_text(stmt, 1, [self.passMessage UTF8String], -1, NULL);
            
            sqlite3_bind_text(stmt, 2, [self.typeNote.text UTF8String], -1, NULL);
            
            sqlite3_step(stmt);
            
            sqlite3_finalize(stmt);
            
        } // if
        
        
    } // else
    
    if ( sqlite3_prepare_v2(dataBase, querySQL, -1, &stmt, nil) == SQLITE_OK ) {
        
        sqlite3_bind_text(stmt, 1, [self.passMessage UTF8String], -1, NULL);
        
        self.TabelDatas = [self statementtoMSarray:stmt];
        
        sqlite3_finalize(stmt);
        
        [self.noteTable reloadData];
        
        
    } // if
    
    self.typeNote.text = @"";
    
}

- (IBAction)clickCleanTopButton:(id)sender {
    
    sqlite3_stmt *stmt;
    
    char *deleteSpecificSQL = "DELETE FROM NOTE WHERE DATE=? AND DATA=?";
    
    if ( [self.TabelDatas count] != 0 ) {
        
        if ( sqlite3_prepare_v2(dataBase, deleteSpecificSQL, -1, &stmt, nil) == SQLITE_OK ) {
            
            sqlite3_bind_text(stmt, 1, [self.passMessage UTF8String], -1, NULL);
            
            sqlite3_bind_text(stmt, 2, [[self.TabelDatas objectAtIndex:0] UTF8String], -1, NULL);
            
            sqlite3_step(stmt);
            
            sqlite3_finalize(stmt);
            
        } // if
        
        [self.TabelDatas removeObjectAtIndex:0];
        [self.noteTable reloadData];
    } // if
    
}

- (IBAction)clickCleanBottomButton:(id)sender {
    
    sqlite3_stmt *stmt;
    
    char *deleteSpecificSQL = "DELETE FROM NOTE WHERE DATE=? AND DATA=?";
    
    if ( [self.TabelDatas count] != 0 ) {
        
        if ( sqlite3_prepare_v2(dataBase, deleteSpecificSQL, -1, &stmt, nil) == SQLITE_OK ) {
            
            sqlite3_bind_text(stmt, 1, [self.passMessage UTF8String], -1, NULL);
            
            sqlite3_bind_text(stmt, 2, [[self.TabelDatas objectAtIndex:[self.TabelDatas count]-1] UTF8String], -1, NULL);
            
            sqlite3_step(stmt);
            
            sqlite3_finalize(stmt);
            
        } // if
        
        [self.TabelDatas removeObjectAtIndex:[self.TabelDatas count]-1];
        [self.noteTable reloadData];
    } // if
    
}

- (IBAction)keyboardDismiss:(id)sender {
    [sender resignFirstResponder];
}
@end
