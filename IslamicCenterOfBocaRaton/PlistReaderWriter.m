//
//  PlistReaderWriter.m
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 4/10/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import "PlistReaderWriter.h"


@implementation PlistReaderWriter
@synthesize zipCode = zipCode_;
@synthesize path = path_;

-(id)init
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    path_ = [[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:@"settings.plist"]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path_]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path_ error:&error]; //6
    }

    return self;

}

// this method will update both the plist file and the local ivars so the
// delegate routine will get the updates
-(void) updatePlistFile:(BOOL) athhan:(BOOL)iqama:(NSString*)zip:(NSInteger) sound
{
    
}

-(NSString*) getFormmatedAddressFromPlist
{
    NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: path_];
    NSString *formattedAddress = [[NSString alloc] initWithString:[savedData objectForKey:@"FormattedAddress"]];
    [savedData release];
    return formattedAddress;
    
}

-(BOOL) getAthaanNotificationFromPlist
{
    NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: path_];
    
    return [[savedData objectForKey:@"ActivateAthaanAlarm"] boolValue];

}
-(BOOL) getIqamaNotificationFromPlist
{
    NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: path_];
    
    return [[savedData objectForKey:@"ActivateIqamaAlarm"] boolValue];
  
}
-(NSInteger) getSoundTypeFromPlist
{
    NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: path_];
    
    return [[savedData objectForKey:@"AzaanName"] intValue];
  
}

-(void) setAthaanNotificationInPlist:(BOOL) status
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path_];
    
    //here add elements to data file and write data to file
    
    [data setObject:[NSNumber numberWithBool:status] forKey:@"ActivateAthaanAlarm"];
    
    [data writeToFile: path_ atomically:YES];
    [data release];

}
-(void) setIqamaNotificationInPlist:(BOOL) status
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path_];
    
    //here add elements to data file and write data to file
    
    [data setObject:[NSNumber numberWithBool:status] forKey:@"ActivateIqamaAlarm"];
    
    [data writeToFile: path_ atomically:YES];
    [data release];
  
}

-(void) setSoundTypeInPlist:(NSInteger) soundValue
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path_];
    
    //here add elements to data file and write data to file
    
    [data setObject:[NSNumber numberWithInt:soundValue] forKey:@"AzaanName"];
    
    [data writeToFile: path_ atomically:YES];
    [data release];
}

-(void) setFormattedAddressInPlist:(NSString*) formattedAddress
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path_];
    
    //here add elements to data file and write data to file
    
    [data setObject:[NSString stringWithString:formattedAddress] forKey:@"FormattedAddress"];
    
    [data writeToFile: path_ atomically:YES];
    [data release];
}

@end
