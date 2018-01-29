//
//  TotalViewController.m
//  Account_Note Manager
//
//  Created by Jonah on 2015/1/12.
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

@interface TotalViewController ()

@end

@implementation TotalViewController

@synthesize totalDisplayTime;
@synthesize totalPicker;
@synthesize displayCalculation;
@synthesize homeButton;
@synthesize selectButton;

@synthesize yearType;
@synthesize monthType;
@synthesize timeType;
@synthesize kindType;

sqlite3 *dataBase;
NSInteger yearRow;
NSInteger monthrRow;
NSInteger timeRow;
NSInteger kindRow;


NSString *year;
NSString *month;
NSString *Time;
NSString *kind;

- (NSString *) dataFilePath {  // 資料庫路徑
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:Filename];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyy年 MM月 dd日"];
    
    NSString *dateString = [dateFormat stringFromDate:today];
    
    NSArray *yearArray = [[NSArray alloc] initWithObjects:@"2010",@"2011",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030",@"2031",@"2032",@"2033",@"2034",@"2035",@"2036",@"2037",@"2038",@"2039",@"2040",@"2041",@"2042",@"2043",@"2044",@"2045",@"2046",@"2047",@"2048",@"2049",@"2050", nil];
    self.yearType = yearArray;
    
    NSArray *monthArray = [[NSArray alloc] initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil];
    self.monthType = monthArray;
    
    NSArray *timeArray = [[NSArray alloc] initWithObjects:@"當年",@"當季",@"當月", nil];
    self.timeType = timeArray;
    
    NSArray *kindArray = [[NSArray alloc] initWithObjects:@"食",@"衣",@"住",@"行",@"其他",@"總計", nil];
    self.kindType = kindArray;
    
    self.totalPicker.dataSource = self;
    self.totalPicker.delegate = self;
    
    self.totalDisplayTime.text = [ NSString stringWithFormat:@"Today is %@", dateString];
    
    if ( sqlite3_open([[self dataFilePath] UTF8String], &dataBase) != SQLITE_OK ) {  // 開啟資料庫
        sqlite3_close(dataBase);
        NSLog(@"Failed to open dataBase");
    } // if
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.totalDisplayTime = nil;
    self.totalPicker = nil;
    self.displayCalculation = nil;
    self.homeButton = nil;
    self.selectButton = nil;
    self.yearType = nil;
    self.monthType = nil;
    self.timeType = nil;
    self.kindType = nil;
    
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if ( component == yearComponent )
        return [self.yearType count];
    
    else if ( component == monthComponent )
        return [self.monthType count];
    
    else if ( component == timeComponent )
        return [self.timeType count];
    
    else
        return [self.kindType count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if ( component == yearComponent )
        return [self.yearType objectAtIndex:row];
    
    else if ( component == monthComponent )
        return [self.monthType objectAtIndex:row];
    
    else if ( component == timeComponent )
        return [self.timeType objectAtIndex:row];
        
    else
        return [self.kindType objectAtIndex:row];
    
}

- (IBAction)clickHomeButton:(id)sender {
    sqlite3_close(dataBase);
}

- (IBAction)clickSelectButton:(id)sender {
    
    int show = 0;
    
    sqlite3_stmt *stmt;
    
    char *queryYearSQL = "SELECT * FROM ACCOUNT WHERE YEAR=?"; // 本年
    
    char *queryMonthSQL = "SELECT * FROM ACCOUNT WHERE YEAR=? AND MONTH=?"; // 本月
    
    char *querySeason1SQL = "SELECT * FROM ACCOUNT WHERE YEAR=? AND MONTH>=1 AND MONTH<=3"; // 第1季
    
    char *querySeason2SQL = "SELECT * FROM ACCOUNT WHERE YEAR=? AND MONTH>=4 AND MONTH<=6"; // 第2季
    
    char *querySeason3SQL = "SELECT * FROM ACCOUNT WHERE YEAR=? AND MONTH>=7 AND MONTH<=9"; // 第3季
    
    char *querySeason4SQL = "SELECT * FROM ACCOUNT WHERE YEAR=? AND MONTH>=10 AND MONTH<=12"; // 第4季
    
    yearRow = [self.totalPicker selectedRowInComponent:yearComponent];
    year = [self.yearType objectAtIndex:yearRow];  // 選取之年
    
    monthrRow = [self.totalPicker selectedRowInComponent:monthComponent];
    month = [self.monthType objectAtIndex:monthrRow];  // 選取之月
    
    timeRow = [self.totalPicker selectedRowInComponent:timeComponent];
    Time = [self.timeType objectAtIndex:timeRow];  // 選取之時間
    
    kindRow = [self.totalPicker selectedRowInComponent:kindComponent];
    kind = [self.kindType objectAtIndex:kindRow];  // 選取之種類
    
    
    if ( [Time isEqual:@"當年"] ) {
        
        if (sqlite3_prepare_v2(dataBase, queryYearSQL, -1, &stmt, NULL) == SQLITE_OK) {  // 尋找日期是否存在
            
            show = 0;
            
            sqlite3_bind_int(stmt, 1, [year intValue]);
            
            while ( sqlite3_step(stmt) == SQLITE_ROW ) {  // QUERY PART
                
                if ( [kind isEqual:@"食"] )
                    show = show + sqlite3_column_int(stmt, 3);
                
                else if ( [kind isEqual:@"衣"] )
                    show = show + sqlite3_column_int(stmt, 4);
                
                else if ( [kind isEqual:@"住"] )
                    show = show + sqlite3_column_int(stmt, 5);
                
                else if ( [kind isEqual:@"行"] )
                    show = show + sqlite3_column_int(stmt, 6);
                
                else if ( [kind isEqual:@"總計"] )
                    show = show + sqlite3_column_int(stmt, 8);
                
                else
                    show = show + sqlite3_column_int(stmt, 7);
                
            } // while
            
            sqlite3_finalize(stmt);
            
            self.displayCalculation.text = [NSString stringWithFormat:@"總花費: %d 元", show];
        } // if
        
    } // if
    
    else if ( [Time isEqual:@"當月"] ) {
        
        if (sqlite3_prepare_v2(dataBase, queryMonthSQL, -1, &stmt, NULL) == SQLITE_OK) {  // 尋找日期
            
            show = 0;
            
            sqlite3_bind_int(stmt, 1, [year intValue]);
            
            sqlite3_bind_int(stmt, 2, [month intValue]);
            
            while ( sqlite3_step(stmt) == SQLITE_ROW ) {  // QUERY PART
                
                if ( [kind isEqual:@"食"] )
                    show = show + sqlite3_column_int(stmt, 3);
                
                else if ( [kind isEqual:@"衣"] )
                    show = show + sqlite3_column_int(stmt, 4);
                
                else if ( [kind isEqual:@"住"] )
                    show = show + sqlite3_column_int(stmt, 5);
                
                else if ( [kind isEqual:@"行"] )
                    show = show + sqlite3_column_int(stmt, 6);
                
                else if ( [kind isEqual:@"總計"] )
                    show = show + sqlite3_column_int(stmt, 8);
                
                else
                    show = show + sqlite3_column_int(stmt, 7);
                
            } // while
            
            sqlite3_finalize(stmt);
            
            self.displayCalculation.text = [NSString stringWithFormat:@"總花費: %d 元", show];
        } // if
        
    } // else if
    
    else {
        
        if ( [month intValue] >= 1 && [month intValue] <= 3 ) {
            
            if (sqlite3_prepare_v2(dataBase, querySeason1SQL, -1, &stmt, NULL) == SQLITE_OK) {  // 尋找日期
                
                show = 0;
                
                sqlite3_bind_int(stmt, 1, [year intValue]);
                
                while ( sqlite3_step(stmt) == SQLITE_ROW ) {  // QUERY PART
                    
                    if ( [kind isEqual:@"食"] )
                        show = show + sqlite3_column_int(stmt, 3);
                    
                    else if ( [kind isEqual:@"衣"] )
                        show = show + sqlite3_column_int(stmt, 4);
                    
                    else if ( [kind isEqual:@"住"] )
                        show = show + sqlite3_column_int(stmt, 5);
                    
                    else if ( [kind isEqual:@"行"] )
                        show = show + sqlite3_column_int(stmt, 6);
                    
                    else if ( [kind isEqual:@"總計"] )
                        show = show + sqlite3_column_int(stmt, 8);
                    
                    else
                        show = show + sqlite3_column_int(stmt, 7);
                    
                } // while
                
                sqlite3_finalize(stmt);
                
                self.displayCalculation.text = [NSString stringWithFormat:@"總花費: %d 元", show];
            } // if
            
        } // if
        
        else if ( [month intValue] >= 4 && [month intValue] <= 6 ) {
            
            if (sqlite3_prepare_v2(dataBase, querySeason2SQL, -1, &stmt, NULL) == SQLITE_OK) {  // 尋找日期
                
                show = 0;
                
                sqlite3_bind_int(stmt, 1, [year intValue]);
                
                while ( sqlite3_step(stmt) == SQLITE_ROW ) {  // QUERY PART
                    
                    if ( [kind isEqual:@"食"] )
                        show = show + sqlite3_column_int(stmt, 3);
                    
                    else if ( [kind isEqual:@"衣"] )
                        show = show + sqlite3_column_int(stmt, 4);
                    
                    else if ( [kind isEqual:@"住"] )
                        show = show + sqlite3_column_int(stmt, 5);
                    
                    else if ( [kind isEqual:@"行"] )
                        show = show + sqlite3_column_int(stmt, 6);
                    
                    else if ( [kind isEqual:@"總計"] )
                        show = show + sqlite3_column_int(stmt, 8);
                    
                    else
                        show = show + sqlite3_column_int(stmt, 7);
                    
                } // while
                
                sqlite3_finalize(stmt);
                
                self.displayCalculation.text = [NSString stringWithFormat:@"總花費: %d 元", show];
            } // if
            
        } // else if
        
        else if ( [month intValue] >= 7 && [month intValue] <= 9 ) {
            
            if (sqlite3_prepare_v2(dataBase, querySeason3SQL, -1, &stmt, NULL) == SQLITE_OK) {  // 尋找日期
                
                show = 0;
                
                sqlite3_bind_int(stmt, 1, [year intValue]);
                
                while ( sqlite3_step(stmt) == SQLITE_ROW ) {  // QUERY PART
                    
                    if ( [kind isEqual:@"食"] )
                        show = show + sqlite3_column_int(stmt, 3);
                    
                    else if ( [kind isEqual:@"衣"] )
                        show = show + sqlite3_column_int(stmt, 4);
                    
                    else if ( [kind isEqual:@"住"] )
                        show = show + sqlite3_column_int(stmt, 5);
                    
                    else if ( [kind isEqual:@"行"] )
                        show = show + sqlite3_column_int(stmt, 6);
                    
                    else if ( [kind isEqual:@"總計"] )
                        show = show + sqlite3_column_int(stmt, 8);
                    
                    else
                        show = show + sqlite3_column_int(stmt, 7);
                    
                } // while
                
                sqlite3_finalize(stmt);
                
                self.displayCalculation.text = [NSString stringWithFormat:@"總花費: %d 元", show];
            } // if
            
        } // else if
        
        else {
            
            if (sqlite3_prepare_v2(dataBase, querySeason4SQL, -1, &stmt, NULL) == SQLITE_OK) {  // 尋找日期
                
                show = 0;
                
                sqlite3_bind_int(stmt, 1, [year intValue]);
                
                while ( sqlite3_step(stmt) == SQLITE_ROW ) {  // QUERY PART
                    
                    if ( [kind isEqual:@"食"] )
                        show = show + sqlite3_column_int(stmt, 3);
                    
                    else if ( [kind isEqual:@"衣"] )
                        show = show + sqlite3_column_int(stmt, 4);
                    
                    else if ( [kind isEqual:@"住"] )
                        show = show + sqlite3_column_int(stmt, 5);
                    
                    else if ( [kind isEqual:@"行"] )
                        show = show + sqlite3_column_int(stmt, 6);
                    
                    else if ( [kind isEqual:@"總計"] )
                        show = show + sqlite3_column_int(stmt, 8);
                    
                    else
                        show = show + sqlite3_column_int(stmt, 7);
                    
                } // while
                
                sqlite3_finalize(stmt);
                
                self.displayCalculation.text = [NSString stringWithFormat:@"總花費: %d 元", show];
            } // if
            
        } // else
        
        
        
    } // else
    
    
    
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
