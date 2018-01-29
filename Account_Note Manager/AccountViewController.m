//
//  AccountViewController.m
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
#import <sqlite3.h>

#define Filename @"store.sqlite3"

@interface AccountViewController ()

@end

@implementation AccountViewController

@synthesize accountDisplayTime;
@synthesize swipeLeft;
@synthesize accountKindPicker;
@synthesize typeMoney;
@synthesize enterButton;
@synthesize displayTotal;
@synthesize homeButton;
@synthesize backButton;

@synthesize kindType;
@synthesize passMessage;
@synthesize passYear;
@synthesize passMonth;
@synthesize passDay;

int money;

sqlite3 *dataBase;
NSInteger kindRow;
NSString *kind;

- (NSString *) dataFilePath {  // 資料庫路徑
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:Filename];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    int total = 0;
    
    self.swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftTrigger:)];
    [self.swipeLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:swipeLeft];
    
    sqlite3_stmt *stmt;
    
    NSArray *kindArray = [[NSArray alloc] initWithObjects:@"食",@"衣",@"住",@"行",@"其他", nil]; // for kind picker
    
    char *createSQL = "CREATE TABLE IF NOT EXISTS ACCOUNT(YEAR INT, MONTH INT, DAY INT, FOOD INT, CLOTHES INT, LIVING INT, TRANSPORTATION INT, OTHERS INT, TOTAL INT)";  // 創造table,如果已存在會忽略
    
    char *errorMsg;
    
    char *querySQL = "SELECT * FROM ACCOUNT WHERE YEAR=? AND MONTH=? AND DAY=?";
    
    if ( sqlite3_open([[self dataFilePath] UTF8String], &dataBase) != SQLITE_OK ) {  // 開啟資料庫
        sqlite3_close(dataBase);
        NSLog(@"Failed to open dataBase");
    } // if
    
    if ( sqlite3_exec(dataBase, createSQL, NULL, NULL, &errorMsg) != SQLITE_OK ) { // 創造table
        sqlite3_close(dataBase);
        NSLog(@"Error creating table: %s", errorMsg);
    } // if
    
    self.accountDisplayTime.text = passMessage;
    
    self.kindType = kindArray;
    
    self.accountKindPicker.dataSource = self;
    self.accountKindPicker.delegate = self;
    
    [self.typeMoney setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    
    if (sqlite3_prepare_v2(dataBase, querySQL, -1, &stmt, NULL) == SQLITE_OK) {  // 尋找日期是否存在

        sqlite3_bind_int(stmt, 1, [self.passYear intValue]);
        sqlite3_bind_int(stmt, 2, [self.passMonth intValue]);
        sqlite3_bind_int(stmt, 3, [self.passDay intValue]);
        
        while ( sqlite3_step(stmt) == SQLITE_ROW ) {  // QUERY PART

            total = sqlite3_column_int(stmt, 8);
            
        } // while
        
        sqlite3_finalize(stmt);
        
        self.displayTotal.text = [NSString stringWithFormat:@"總花費: %d 元", total];
    } // if
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.accountDisplayTime = nil;
    self.accountKindPicker = nil;
    self.typeMoney = nil;
    self.enterButton = nil;
    self.displayTotal = nil;
    self.homeButton = nil;
    self.backButton = nil;
    self.kindType = nil;

}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    return [self.kindType count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    return [self.kindType objectAtIndex:row];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"AccountBackToSecond"]){
        
        SecondViewController *secondViewController = (SecondViewController *)segue.destinationViewController;
        
        secondViewController.passMessage = self.passMessage;
        secondViewController.passYear = self.passYear;
        secondViewController.passMonth = self.passMonth;
        secondViewController.passDay = self.passDay;
        
        // here you have passed the value //
        
    } // if
    
    if([segue.identifier isEqualToString:@"SwipeToNote"]){
        
        NoteViewController *noteViewController = (NoteViewController *)segue.destinationViewController;
        
        noteViewController.passMessage = self.passMessage;
        noteViewController.passYear = self.passYear;
        noteViewController.passMonth = self.passMonth;
        noteViewController.passDay = self.passDay;
        
        // here you have passed the value //
        
    } // if
    
}

- (IBAction)swipeLeftTrigger:(id)sender {
    [self performSegueWithIdentifier:@"SwipeToNote" sender:self];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickEnterButton:(id)sender {
    
    char *insertSQL = "INSERT INTO ACCOUNT(YEAR, MONTH, DAY, FOOD, CLOTHES, LIVING, TRANSPORTATION, OTHERS, TOTAL) VALUES(?,?,?,?,?,?,?,?,?)";
    
    char *updateSQL = "UPDATE ACCOUNT SET FOOD=?, CLOTHES=?, LIVING=?, TRANSPORTATION=?, OTHERS=?, TOTAL=? WHERE YEAR=? AND MONTH=? AND DAY=?";
    
    char *deleteSQL = "DELETE FROM ACCOUNT";
    
    char *dropSQL = "DROP TABLE ACCOUNT";
    
    char *queryAllSQL = "SELECT * FROM ACCOUNT";
    
    char *querySQL = "SELECT * FROM ACCOUNT WHERE YEAR=? AND MONTH=? AND DAY=?";
    
    int i1 = 0, i2 = 0, i3 = 0, i4 = 0, i5 = 0, total = 0;
    
    bool check = false;
    
    NSCharacterSet *numericOnly = [NSCharacterSet decimalDigitCharacterSet];
    
    NSCharacterSet *checkTextField = [NSCharacterSet characterSetWithCharactersInString:[self.typeMoney text]];
    
    sqlite3_stmt *stmt;
    
    NSDateFormatter *currentDate = [[NSDateFormatter alloc] init];
    
    NSString *currentYear, *currentMonth, *currentDay;
    
    [currentDate setDateFormat:@"yyyy"];
    currentYear = [currentDate stringFromDate:[NSDate date]];
    
    [currentDate setDateFormat:@"MM"];
    currentMonth = [currentDate stringFromDate:[NSDate date]];
    
    [currentDate setDateFormat:@"dd"];
    currentDay = [currentDate stringFromDate:[NSDate date]];
    
    kindRow = [self.accountKindPicker selectedRowInComponent:0];
    
    kind = [self.kindType objectAtIndex:kindRow];  // 選取之種類
    
    if ( [numericOnly isSupersetOfSet:checkTextField] ) {
        
        money = [[self.typeMoney text] intValue];  // 輸入之金額
    
    
        if (sqlite3_prepare_v2(dataBase, querySQL, -1, &stmt, NULL) == SQLITE_OK) {  // 尋找日期是否存在
            check = false;

            sqlite3_bind_int(stmt, 1, [self.passYear intValue]);
            sqlite3_bind_int(stmt, 2, [self.passMonth intValue]);
            sqlite3_bind_int(stmt, 3, [self.passDay intValue]);
            
            
            while ( sqlite3_step(stmt) == SQLITE_ROW ) {  // UPDATE PART
                
                i1 = sqlite3_column_int(stmt, 3);  // 食 money
                i2 = sqlite3_column_int(stmt, 4);  // 衣 money
                i3 = sqlite3_column_int(stmt, 5);  // 住 money
                i4 = sqlite3_column_int(stmt, 6);  // 行 money
                i5 = sqlite3_column_int(stmt, 7);  // 其他 money
                total = sqlite3_column_int(stmt, 8);  // total money
            
                total = total + money;
            
                //使用完畢後將statement清空
                sqlite3_finalize(stmt);
                
                if (sqlite3_prepare_v2(dataBase, updateSQL, -1, &stmt, NULL) == SQLITE_OK) {
                    
                    NSLog(@"update");
                    sqlite3_bind_int(stmt, 7, [self.passYear intValue]);
                    sqlite3_bind_int(stmt, 8, [self.passMonth intValue]);
                    sqlite3_bind_int(stmt, 9, [self.passDay intValue]);
                    
                    if ( [kind isEqual:@"食"] ){
                        sqlite3_bind_int(stmt, 1, money+i1);
                        sqlite3_bind_int(stmt, 2, i2);
                        sqlite3_bind_int(stmt, 3, i3);
                        sqlite3_bind_int(stmt, 4, i4);
                        sqlite3_bind_int(stmt, 5, i5);
                        sqlite3_bind_int(stmt, 6, total);
                    } // else if
                    
                    else if ( [kind isEqual:@"衣"] ) {
                        sqlite3_bind_int(stmt, 1, i1);
                        sqlite3_bind_int(stmt, 2, money+i2);
                        sqlite3_bind_int(stmt, 3, i3);
                        sqlite3_bind_int(stmt, 4, i4);
                        sqlite3_bind_int(stmt, 5, i5);
                        sqlite3_bind_int(stmt, 6, total);
                    } // else if
                    
                    else if ( [kind isEqual:@"住"] ) {
                        sqlite3_bind_int(stmt, 1, i1);
                        sqlite3_bind_int(stmt, 2, i2);
                        sqlite3_bind_int(stmt, 3, money+i3);
                        sqlite3_bind_int(stmt, 4, i4);
                        sqlite3_bind_int(stmt, 5, i5);
                        sqlite3_bind_int(stmt, 6, total);
                    } // else if
                    
                    else if ( [kind isEqual:@"行"] ) {
                        sqlite3_bind_int(stmt, 1, i1);
                        sqlite3_bind_int(stmt, 2, i2);
                        sqlite3_bind_int(stmt, 3, i3);
                        sqlite3_bind_int(stmt, 4, money+i4);
                        sqlite3_bind_int(stmt, 5, i5);
                        sqlite3_bind_int(stmt, 6, total);
                    } // else if
                    
                    else if ( [kind isEqual:@"其他"] ) {
                        sqlite3_bind_int(stmt, 1, i1);
                        sqlite3_bind_int(stmt, 2, i2);
                        sqlite3_bind_int(stmt, 3, i3);
                        sqlite3_bind_int(stmt, 4, i4);
                        sqlite3_bind_int(stmt, 5, money+i5);
                        sqlite3_bind_int(stmt, 6, total);
                    } // else if
                    
                    sqlite3_step(stmt);
                
                } // if
                
                check = true;
            
            } // while
            
            sqlite3_finalize(stmt);
            
            if ( !check ) {
                
                // INSERT PART
                
                if ( sqlite3_prepare_v2(dataBase, insertSQL, -1, &stmt, nil) == SQLITE_OK ) {
                    
                    NSLog(@"First insert");
                
                    total = money;
                
                    sqlite3_bind_int(stmt, 1, [self.passYear intValue]);
                    sqlite3_bind_int(stmt, 2, [self.passMonth intValue]);
                    sqlite3_bind_int(stmt, 3, [self.passDay intValue]);
                
                    if ( [kind isEqual:@"食"] ){
                        sqlite3_bind_int(stmt, 4, money);
                        sqlite3_bind_int(stmt, 5, 0);
                        sqlite3_bind_int(stmt, 6, 0);
                        sqlite3_bind_int(stmt, 7, 0);
                        sqlite3_bind_int(stmt, 8, 0);
                        sqlite3_bind_int(stmt, 9, total);
                    } // else if
                
                    else if ( [kind isEqual:@"衣"] ) {
                        sqlite3_bind_int(stmt, 4, 0);
                        sqlite3_bind_int(stmt, 5, money);
                        sqlite3_bind_int(stmt, 6, 0);
                        sqlite3_bind_int(stmt, 7, 0);
                        sqlite3_bind_int(stmt, 8, 0);
                        sqlite3_bind_int(stmt, 9, total);
                    } // else if
                
                    else if ( [kind isEqual:@"住"] ) {
                        sqlite3_bind_int(stmt, 4, 0);
                        sqlite3_bind_int(stmt, 5, 0);
                        sqlite3_bind_int(stmt, 6, money);
                        sqlite3_bind_int(stmt, 7, 0);
                        sqlite3_bind_int(stmt, 8, 0);
                        sqlite3_bind_int(stmt, 9, total);
                    } // else if
                
                    else if ( [kind isEqual:@"行"] ) {
                        sqlite3_bind_int(stmt, 4, 0);
                        sqlite3_bind_int(stmt, 5, 0);
                        sqlite3_bind_int(stmt, 6, 0);
                        sqlite3_bind_int(stmt, 7, money);
                        sqlite3_bind_int(stmt, 8, 0);
                        sqlite3_bind_int(stmt, 9, total);
                    } // else if
                
                    else if ( [kind isEqual:@"其他"] ) {
                        sqlite3_bind_int(stmt, 4, 0);
                        sqlite3_bind_int(stmt, 5, 0);
                        sqlite3_bind_int(stmt, 6, 0);
                        sqlite3_bind_int(stmt, 7, 0);
                        sqlite3_bind_int(stmt, 8, money);
                        sqlite3_bind_int(stmt, 9, total);
                    } // else if
                
                    sqlite3_step(stmt);
                
                } // if
            
                sqlite3_finalize(stmt);
        
            } // if
        
        } // if
        
    } // if
    
    else {

        if (sqlite3_prepare_v2(dataBase, querySQL, -1, &stmt, NULL) == SQLITE_OK) {  // 尋找日期是否存在
            
            sqlite3_bind_int(stmt, 1, [self.passYear intValue]);
            sqlite3_bind_int(stmt, 2, [self.passMonth intValue]);
            sqlite3_bind_int(stmt, 3, [self.passDay intValue]);
            
            while ( sqlite3_step(stmt) == SQLITE_ROW ) {  // QUERY PART
                
                total = sqlite3_column_int(stmt, 8);
                
            } // while
            
            sqlite3_finalize(stmt);
            
            self.displayTotal.text = [NSString stringWithFormat:@"總花費: %d 元", total];
        } // if
        
    } // else

    /*
    // DELETE PART
    
    if ( sqlite3_prepare_v2(dataBase, deleteSQL, -1, &stmt, nil) == SQLITE_OK ) {
        while (sqlite3_step(stmt) == SQLITE_ROW);
    } // if

    sqlite3_finalize(stmt);
    */
    
    // QUERY PART
    
    if (sqlite3_prepare_v2(dataBase, queryAllSQL, -1, &stmt, NULL) == SQLITE_OK) {
        
        while ( sqlite3_step(stmt) == SQLITE_ROW ) {

            i1 = sqlite3_column_int(stmt, 3);
            i2 = sqlite3_column_int(stmt, 4);
            i3 = sqlite3_column_int(stmt, 5);
            i4 = sqlite3_column_int(stmt, 6);
            i5 = sqlite3_column_int(stmt, 7);
            
            NSLog(@"日期: %d年%d月%d日, 食: %d, 衣: %d, 住: %d, 行: %d, 其他: %d, 總和: %d", sqlite3_column_int(stmt, 0), sqlite3_column_int(stmt, 1), sqlite3_column_int(stmt, 2), i1, i2, i3, i4, i5, sqlite3_column_int(stmt, 8));
            
        }
        
        //使用完畢後將statement清空
        sqlite3_finalize(stmt);
    } // if
    
    self.typeMoney.text = @"";
    self.displayTotal.text = [NSString stringWithFormat:@"總花費: %d 元", total];
    
}

- (IBAction)clickHomeButton:(id)sender {
    sqlite3_close(dataBase);
}

- (IBAction)clickBackButton:(id)sender {
    sqlite3_close(dataBase);
}

- (IBAction)keyboardDismiss:(id)sender {
    [sender resignFirstResponder];
}


@end
