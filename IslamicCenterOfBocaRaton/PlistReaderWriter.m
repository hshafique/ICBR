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

    path2_ = [[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:@"settings2.plist"]];
    
    NSFileManager *fileManager2 = [NSFileManager defaultManager];
    
    if (![fileManager2 fileExistsAtPath: path2_]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"settings2" ofType:@"plist"]; //5
        
        [fileManager2 copyItemAtPath:bundle toPath: path2_ error:&error]; //6
    }
    return self;

}

// this method will update both the plist file and the local ivars so the
// delegate routine will get the updates
-(void) updatePlistFile: (BOOL) athhan : (BOOL) iqama : (NSString*) zip : (NSInteger) sound
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

-(BOOL)is2012Updated
{
    NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: path2_];
    
    return [[savedData objectForKey:@"NewYear2012IsUpdated"] boolValue];    
}

-(BOOL)is2013Updated
{
    NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: path2_];
    
    return [[savedData objectForKey:@"NewYear2013IsUpdated"] boolValue];
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

-(void) set2012Updated:(BOOL) status
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path2_];
    
    //here add elements to data file and write data to file
    [data setObject:[NSNumber numberWithBool:status] forKey:@"NewYear2012IsUpdated"];
    BOOL getsaveddata = [[data objectForKey:@"NewYear2012IsUpdated"] boolValue];

    NSLog(@"bool value is %d status us %d path is %@", getsaveddata, status, path2_);
    [data writeToFile: path2_ atomically:YES];
    [data release];
    
}

-(void) set2013Updated:(BOOL) status
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path2_];
    
    //here add elements to data file and write data to file
    [data setObject:[NSNumber numberWithBool:status] forKey:@"NewYear2013IsUpdated"];
    BOOL getsaveddata = [[data objectForKey:@"NewYear2013IsUpdated"] boolValue];
    
    NSLog(@"bool value is %d status us %d path is %@", getsaveddata, status, path2_);
    [data writeToFile: path2_ atomically:YES];
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

-(NSInteger) getIqamaAdvanceTimeFromPlist
{
    NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: path_];
    
    return [[savedData objectForKey:@"IqamaAdvanceTime"] intValue];
    
}

-(NSInteger) getIqamaSoundTypeFromPlist
{
    NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: path_];
    
    return [[savedData objectForKey:@"IqamaName"] intValue];

}

-(void) setIqamaSoundTypeFromPlist:(NSInteger) soundValue
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path_];
    
    //here add elements to data file and write data to file
    
    [data setObject:[NSNumber numberWithInt:soundValue] forKey:@"IqamaName"];
    
    [data writeToFile: path_ atomically:YES];
    [data release];
}

-(void) setIqamaAdvanceTimeFromPlist:(NSInteger) noticeValue
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path_];
    
    //here add elements to data file and write data to file
    
    [data setObject:[NSNumber numberWithInt:noticeValue] forKey:@"IqamaAdvanceTime"];
    
    [data writeToFile: path_ atomically:YES];
    [data release];
}

-(void)setIqamaOverride:(BOOL) status
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path2_];
    
    //here add elements to data file and write data to file
    
    [data setObject:[NSNumber numberWithBool:status] forKey:@"IqamaOverride"];
    
    [data writeToFile: path2_ atomically:YES];
    [data release];
    
}
-(BOOL)getIqamaOverride
{
    NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: path2_];
    
    return [[savedData objectForKey:@"IqamaOverride"] boolValue];    

}

-(void)setFajr:(NSString*)fajrTime
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path2_];
    
    //here add elements to data file and write data to file
    
    [data setObject:[NSString stringWithString:fajrTime] forKey:@"Fajr"];
    
    [data writeToFile: path2_ atomically:YES];
    [data release];
    
}
-(NSString*)getFajr
{
    NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: path2_];
    NSString *formattedAddress = [[NSString alloc] initWithString:[savedData objectForKey:@"Fajr"]];
    [savedData release];
    return formattedAddress;

}
-(void)setDhohur:(NSString*)dhohurTime
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path2_];
    
    //here add elements to data file and write data to file
    
    [data setObject:[NSString stringWithString:dhohurTime] forKey:@"Dhohur"];
    
    [data writeToFile: path2_ atomically:YES];
    [data release];

}
-(NSString*)getDhohur
{
    NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: path2_];
    NSString *formattedAddress = [[NSString alloc] initWithString:[savedData objectForKey:@"Dhohur"]];
    [savedData release];
    return formattedAddress;

}
-(void)setAsr:(NSString*)asrTime
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path2_];
    
    //here add elements to data file and write data to file
    
    [data setObject:[NSString stringWithString:asrTime] forKey:@"Asr"];
    
    [data writeToFile: path2_ atomically:YES];
    [data release];

}
-(NSString*)getAsr
{
    NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: path2_];
    NSString *formattedAddress = [[NSString alloc] initWithString:[savedData objectForKey:@"Asr"]];
    [savedData release];
    return formattedAddress;

}
-(void)setMaghrib:(NSString*)maghribTime
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path2_];
    
    //here add elements to data file and write data to file
    
    [data setObject:[NSString stringWithString:maghribTime] forKey:@"Maghrib"];
    
    [data writeToFile: path2_ atomically:YES];
    [data release];

}
-(NSString*)getMaghrib
{
    NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: path2_];
    NSString *formattedAddress = [[NSString alloc] initWithString:[savedData objectForKey:@"Maghrib"]];
    [savedData release];
    return formattedAddress;

}
-(void)setIsha:(NSString*)ishaTime
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path2_];
    
    //here add elements to data file and write data to file
    
    [data setObject:[NSString stringWithString:ishaTime] forKey:@"Isha"];
    
    [data writeToFile: path2_ atomically:YES];
    [data release];

}-(NSString*)getIsha
{
    NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: path2_];
    NSString *formattedAddress = [[NSString alloc] initWithString:[savedData objectForKey:@"Isha"]];
    [savedData release];
    return formattedAddress;

}

@end
