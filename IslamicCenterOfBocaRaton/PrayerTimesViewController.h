//
//  PrayerTimesViewController.h
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 3/18/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyPrayerTimes.h"
#import "PlistReaderWriter.h"
#import "SettingsViewController.h"

@interface PrayerTimesViewController : UIViewController <NSXMLParserDelegate> {
    DailyPrayerTimes *dailyPrayerTimes_;
    NSDate *currentDateInP_;
    NSArray *athaanNames_;
    PlistReaderWriter *settingsData;
    
	IBOutlet UILabel* label;
    UIActivityIndicatorView *activity_;
    IBOutlet UILabel *iqFajr_;
    IBOutlet UILabel *iqShurooq_;
    IBOutlet UILabel *iqDhohur_;
    IBOutlet UILabel *iqAsr_;
    IBOutlet UILabel *iqMaghrib_;
    IBOutlet UILabel *iqIsha_;
    IBOutlet UILabel *jumaa_;
    IBOutlet UILabel *iqJumaa_;
    IBOutlet UILabel *atFajr_;
    IBOutlet UILabel *atShurooq_;
    IBOutlet UILabel *atDhohur_;
    IBOutlet UILabel *atAsr_;
    IBOutlet UILabel *atMaghrib_;
    IBOutlet UILabel *atIsha_;
    IBOutlet UILabel *hijriDate_;
    IBOutlet UILabel *calendarDate_;
    IBOutlet UILabel *formattedAddress_;
    
    int pageNumber_;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, retain) DailyPrayerTimes *dailyPrayerTimes;
@property (nonatomic, retain) NSDate *currentDateInP;
@property (nonatomic, retain) UILabel *atFajr;


-(void) setAlarm:(NSDate*)date:(NSString*)eventText:(NSInteger)alarmType;
-(void) updateAthaanTimes;
-(void) setPageNumber:(int)pageNumber;
-(void) updateCalendarDateBasedOnPageNumber;
-(void) startAthaanAlarms;
-(void) startIqamaAlarms;
-(void) cancelAllNotifications;
-(void) loadPrayerData;
-(NSString *) convertMonthToString:(NSInteger)month;
-(void) clearPrayerTable;
-(void) updateData;
-(void) updateMaghribIqamaTime;

@end
