//
//  DailyPrayerTimes.h
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 3/30/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFilename @"data.sqlite3"

@interface DailyPrayerTimes : NSObject <NSXMLParserDelegate> {
    NSString *fajr_;
    NSString *shurooq_;
    NSString *dhohur_;
    NSString *asr_;
    NSString *maghrib_;
    NSString *isha_;
    NSString *month_;
    NSString *day_;
    NSString *year_;
    NSString *hijriDate_;
    NSMutableString *value_;
    BOOL tableNeedsToBeUpdated_;
    
    
    NSURLConnection *connectionInProgress_;
    NSMutableData *webData_;
    NSString *title_;

    NSString *ifStatus_;
    NSInteger currentMonthUsedforQuery_;

}

@property (nonatomic, retain) NSString *fajr;
@property (nonatomic, retain) NSString *shurooq;
@property (nonatomic, retain) NSString *dhohur;
@property (nonatomic, retain) NSString *asr;
@property (nonatomic, retain) NSString *maghrib;
@property (nonatomic, retain) NSString *isha;
@property (nonatomic, retain) NSString *month;
@property (nonatomic, retain) NSString *day;
@property (nonatomic, retain) NSString *year;
@property (nonatomic, retain) NSString *hijriDate;
@property(nonatomic, retain) NSString *ifStatus;

-(BOOL) initDatabase;
-(void) getdataFromDatabase;
-(void) insertRowIntoDatabase;
-(void)loadMonthlyAthanTimes;
-(void) getRowFromDatabase:(NSString*)lMonth:(NSString*)lDay:(NSString*)lYear:(DailyPrayerTimes*)result;
-(void) getIqamaRowFromDatabase:(NSString*)lMonth:(NSString*)lDay:(NSString*)lYear:(DailyPrayerTimes*)result;
-(void)removePrayerTable;
-(void) insertIqamaRowIntoDatabase;
-(BOOL)update2012data;
-(BOOL)update2013data;

@end
