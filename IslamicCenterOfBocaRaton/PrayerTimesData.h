//
//  PrayerTimesData.h
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 3/18/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PrayerTimesData : NSObject {
    NSDate *currentDate_; // used to initialize the notifications
    NSString *hijriDate_;
    NSMutableArray *iqamaTimes_;
    NSURLConnection *connectionInProgress_;
    NSMutableData *webData_;
    NSString* name;
    NSString *status_;

    
}
@property(nonatomic, retain) NSURLConnection *connectionInProgress;
@property(nonatomic, retain) NSMutableData *webData;
@property (nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSMutableArray *iqamaTimes;
@property(nonatomic, retain) NSString *status;

-(void)loadIqamaTimes;
-(void)parseHtmlData;
@end
