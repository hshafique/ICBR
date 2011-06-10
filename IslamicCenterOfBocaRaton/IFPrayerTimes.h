//
//  IFPrayerTimes.h
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 3/26/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import <Foundation/Foundation.h>

// this interface is only used to get the hijri date from islamic finder . org
@interface IFPrayerTimes : NSObject <NSXMLParserDelegate> {
    NSString *hijriDate_;
    NSURLConnection *connectionInProgress_;
    NSMutableData *webData_;
    NSString *title_;
    NSMutableString *value_;
    NSString *dateStatus_;
    NSString *name_;
}
@property(nonatomic, retain) NSURLConnection *connectionInProgress;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSString *hijriDate;
@property(nonatomic, retain) NSString *dateStatus;
@property(nonatomic, retain) NSString *name;

-(void)loadHijriAndGregorianDates;

@end
