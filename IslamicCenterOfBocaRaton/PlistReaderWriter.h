//
//  PlistReaderWriter.h
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 4/10/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PlistReaderWriter : NSObject {
    
    NSString *path_;
    NSString *path2_;
}

-(void) updatePlistFile:(BOOL) athhan:(BOOL)iqama:(NSString*)zip:(NSInteger) sound;
-(BOOL) getAthaanNotificationFromPlist;
-(BOOL) getIqamaNotificationFromPlist;
-(NSInteger) getSoundTypeFromPlist;
-(NSString*) getFormmatedAddressFromPlist;
-(NSInteger) getIqamaAdvanceTimeFromPlist;
-(NSInteger) getIqamaSoundTypeFromPlist;
-(BOOL)is2012Updated;
-(BOOL)is2013Updated;

-(void) setAthaanNotificationInPlist:(BOOL) status;
-(void) set2012Updated:(BOOL) status;
-(void) set2013Updated:(BOOL) status;
-(void) setIqamaNotificationInPlist:(BOOL) status;
-(void) setSoundTypeInPlist:(NSInteger) soundValue;
-(void) setFormattedAddressInPlist:(NSString*) formattedAddress;
-(void) setIqamaSoundTypeFromPlist:(NSInteger) soundValue;
-(void) setIqamaAdvanceTimeFromPlist:(NSInteger) noticeValue;

// set the iqama override data
-(void)setIqamaOverride:(BOOL) status;
-(BOOL)getIqamaOverride;
-(void)setFajr:(NSString*)fajrTime;
-(NSString*)getFajr;
-(void)setDhohur:(NSString*)dhohurTime;
-(NSString*)getDhohur;
-(void)setAsr:(NSString*)asrTime;
-(NSString*)getAsr;
-(void)setMaghrib:(NSString*)maghribTime;
-(NSString*)getMaghrib;
-(void)setIsha:(NSString*)ishaTime;
-(NSString*)getIsha;

@property(nonatomic, retain) NSString *zipCode;
@property(nonatomic, retain) NSString *path;
@end
