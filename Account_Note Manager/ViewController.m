//
//  ViewController.m
//  Account_Note Manager
//
//  Created by Jonah on 2015/1/7.
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

@interface ViewController ()

@end

@implementation ViewController
@synthesize calculateButton;
@synthesize alertButton;
@synthesize Picker;
@synthesize selectButton;
@synthesize displayTime;
@synthesize yearType;
@synthesize monthType;
@synthesize dayType;
@synthesize TabelDatas;

sqlite3 *dataBase;

NSInteger yearRow;
NSInteger monthRow;
NSInteger dayRow;

NSString *year;
NSString *month;
NSString *day;
NSString *message;

- (NSString *) dataFilePath {  // 資料庫路徑
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:Filename];
}

- (NSArray *) statementtoMSarray:(sqlite3_stmt *) sqlstmt{
    
    self.TabelDatas = [[NSMutableArray alloc]init];
    
    NSString *data;
    
    while ( sqlite3_step(sqlstmt) == SQLITE_ROW ) {
        
        data = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlstmt,2)];
        
        [self.TabelDatas addObject:data];
        
    } // while
    
    return self.TabelDatas;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyy年 MM月 dd日"];
    
    NSString *dateString = [dateFormat stringFromDate:today];
    
    self.displayTime.text = [NSString stringWithFormat:@"Today is %@", dateString];
    
    NSArray *yearArray = [[NSArray alloc] initWithObjects:@"2010",@"2011",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030",@"2031",@"2032",@"2033",@"2034",@"2035",@"2036",@"2037",@"2038",@"2039",@"2040",@"2041",@"2042",@"2043",@"2044",@"2045",@"2046",@"2047",@"2048",@"2049",@"2050", nil];
    self.yearType = yearArray;
    
    NSArray *monthArray = [[NSArray alloc] initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil];
    self.monthType = monthArray;
    
    NSArray *dayArray = [[NSArray alloc] initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31", nil];
    self.dayType = dayArray;
    
    self.Picker.dataSource = self;
    self.Picker.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.calculateButton = nil;
    self.alertButton = nil;
    self.Picker = nil;
    self.selectButton = nil;
    self.displayTime = nil;
    self.yearType = nil;
    self.monthType = nil;
    self.dayType = nil;
    self.TabelDatas = nil;
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if ( component == yearComponent )
        return [self.yearType count];
    
    else if ( component == monthComponent )
        return [self.monthType count];
    
    else
        return [self.dayType count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if ( component == yearComponent )
        return [self.yearType objectAtIndex:row];
    
    else if ( component == monthComponent )
        return [self.monthType objectAtIndex:row];
    
    else
        return [self.dayType objectAtIndex:row];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"Second"]){
        
        SecondViewController *secondViewController = (SecondViewController *)segue.destinationViewController;
        
        secondViewController.passMessage = message;
        secondViewController.passYear = year;
        secondViewController.passMonth = month;
        secondViewController.passDay = day;
        
        //secondViewController.passYear =
        // here you have passed the value //
        
    }
    
}

- (IBAction)clickCalculateButton:(id)sender {
}

- (IBAction)clickAlertButton:(id)sender {  // 提醒～
    
    sqlite3_stmt *stmt;
    
    char *querySQL = "SELECT * FROM NOTE WHERE DATE=?";
    
    UIAlertView *alert;
    
    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyy年 MM月 dd日"];
    
    NSString *dateString = [dateFormat stringFromDate:today];
    
    NSString *showAlert = @"";
    
    if ( sqlite3_open([[self dataFilePath] UTF8String], &dataBase) != SQLITE_OK ) {  // 開啟資料庫
        sqlite3_close(dataBase);
        NSLog(@"Failed to open dataBase");
    } // if
    
    
    if ( sqlite3_prepare_v2(dataBase, querySQL, -1, &stmt, nil) == SQLITE_OK ) {
        
        sqlite3_bind_text(stmt, 1, [dateString UTF8String], -1, NULL);
        
        self.TabelDatas = [self statementtoMSarray:stmt];
        
        sqlite3_finalize(stmt);

    } // if
    
    
    if ( [self.TabelDatas count] == 0 ) {
        
        alert = [[UIAlertView alloc] initWithTitle:@"今日待辦事項" message:@"Nothing" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    } // if
    
    else {
        
        for ( int i = 0; i < [self.TabelDatas count]; i++ ) {
            showAlert = [showAlert stringByAppendingFormat:@"%@\n", [self.TabelDatas objectAtIndex:i]];
        } // for
        
        alert = [[UIAlertView alloc] initWithTitle:@"今日待辦事項" message:showAlert delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        
    } // else
    
    [alert show];
}

- (IBAction)clickButton:(id)sender {
    
    yearRow = [self.Picker selectedRowInComponent:yearComponent];
    
    monthRow = [self.Picker selectedRowInComponent:monthComponent];
    
    dayRow = [self.Picker selectedRowInComponent:dayComponent];
    
    year = [self.yearType objectAtIndex:yearRow];
    
    month = [self.monthType objectAtIndex:monthRow];
    
    day = [self.dayType objectAtIndex:dayRow];
    
    message = [[NSString alloc] initWithFormat:@"%@年 %@月 %@日", year, month, day];
    
    self.displayTime.text = message;
   
}


@end
