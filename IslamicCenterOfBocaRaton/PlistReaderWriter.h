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
}

-(void) updatePlistFile:(BOOL) athhan:(BOOL)iqama:(NSString*)zip:(NSInteger) sound;
-(BOOL) getAthaanNotificationFromPlist;
-(BOOL) getIqamaNotificationFromPlist;
-(NSInteger) getSoundTypeFromPlist;
-(NSString*) getFormmatedAddressFromPlist;

-(void) setAthaanNotificationInPlist:(BOOL) status;
-(void) setIqamaNotificationInPlist:(BOOL) status;
-(void) setSoundTypeInPlist:(NSInteger) soundValue;
-(void) setFormattedAddressInPlist:(NSString*) formattedAddress;

@property(nonatomic, retain) NSString *zipCode;
@property(nonatomic, retain) NSString *path;
@end
