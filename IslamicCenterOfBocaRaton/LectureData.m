//
//  LectureData.m
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 8/31/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import "LectureData.h"


@implementation LectureData

-(id)init
{    
    // Step 1 is to load the text file that has the list of online lectures
    // This will be done using a syncronous call to the icbr website
    numberOfLecturers_ = 0;
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    // construct the web service url
    NSURL *url = [NSURL URLWithString:@"http://www.assahaba.org/icbr.org/iphone_App/lecture.txt"];
    
    // create a request object with that URL for the exact times
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    /* Return Value
     The downloaded data for the URL request. Returns nil if a connection could not be created or if the download fails.
     */
    if (response == nil) 
    {
        // Check for problems
        if (requestError != nil) 
        {
            NSLog(@"error on lookup");
        }
    }
    else 
    {
        lectureList_ = [[NSString alloc] initWithData:response
                                            encoding:NSUTF8StringEncoding];
        NSArray *listItems = [lectureList_ componentsSeparatedByString:@"\n"];
        seperatedLectureList_ = [[NSArray alloc] initWithArray:listItems];
    }

    // Now let's seperate each row into the actual data structures. These data structures will consist of NSMutableArrays
    // with the lecture data. The data will be saved in the data members lectureSetXX_
    lectureSet1_ = [[NSMutableArray alloc] init];
    lectureSet2_ = [[NSMutableArray alloc] init];
    lectureSet3_ = [[NSMutableArray alloc] init];
    lectureSet4_ = [[NSMutableArray alloc] init];
    lectureSet5_ = [[NSMutableArray alloc] init];
    lectureSet6_ = [[NSMutableArray alloc] init];
    lectureSet7_ = [[NSMutableArray alloc] init];
    lectureSet8_ = [[NSMutableArray alloc] init];
    lectureSet9_ = [[NSMutableArray alloc] init];
    lectureSet10_ = [[NSMutableArray alloc] init];
    lectureSet11_ = [[NSMutableArray alloc] init];
    lectureSet12_ = [[NSMutableArray alloc] init];
    lectureSet13_ = [[NSMutableArray alloc] init];
    lectureSet14_ = [[NSMutableArray alloc] init];
    lectureSet15_ = [[NSMutableArray alloc] init];
    lectureSet16_ = [[NSMutableArray alloc] init];
    lectureSet17_ = [[NSMutableArray alloc] init];
    lectureSet18_ = [[NSMutableArray alloc] init];
    lectureSet19_ = [[NSMutableArray alloc] init];
    lectureSet20_ = [[NSMutableArray alloc] init];
    lectureSet21_ = [[NSMutableArray alloc] init];
    lectureSet22_ = [[NSMutableArray alloc] init];
    lectureSet23_ = [[NSMutableArray alloc] init];
    lectureSet24_ = [[NSMutableArray alloc] init];
    lectureSet25_ = [[NSMutableArray alloc] init];
    lectureSet26_ = [[NSMutableArray alloc] init];
    lectureSet27_ = [[NSMutableArray alloc] init];
    lectureSet28_ = [[NSMutableArray alloc] init];
    lectureSet29_ = [[NSMutableArray alloc] init];
    lectureSet30_ = [[NSMutableArray alloc] init];

    [self parseSeperatedLectureList];
    return self;
}

-(void)parseSeperatedLectureList
{
    int lecturerIndex;
    for (unsigned i=0;i<[seperatedLectureList_ count];i++)
    {
        NSString *currentObject = [[NSString alloc] initWithString:[seperatedLectureList_ objectAtIndex:i]];
        NSArray *listItems = [currentObject componentsSeparatedByString:@","];
        NSLog(@"****current object is**** %@", currentObject);
        NSLog(@"****list object is**** %@", listItems);

        lecturerIndex = [[listItems objectAtIndex:0] intValue];
        NSLog(@"first index is %d", lecturerIndex);
        if (lecturerIndex > numberOfLecturers_)
            numberOfLecturers_ = lecturerIndex;
        
        // let's insert it into the correct mutable array
        if ([currentObject hasPrefix:@"1,"])
        {
            [lectureSet1_ addObject:currentObject];
            NSLog(@"+++++RIGHT HERE++++++ %@", lectureSet1_);
        }
        else if ([currentObject hasPrefix:@"2,"])
            [lectureSet2_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"3,"])
            [lectureSet3_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"4,"])
            [lectureSet4_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"5,"])
            [lectureSet5_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"6,"])
            [lectureSet6_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"7,"])
            [lectureSet7_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"8,"])
            [lectureSet8_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"9,"])
            [lectureSet9_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"10,"])
            [lectureSet10_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"11,"])
            [lectureSet11_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"12,"])
            [lectureSet12_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"13,"])
            [lectureSet13_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"14"])
            [lectureSet14_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"15"])
            [lectureSet15_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"16"])
            [lectureSet16_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"17"])
            [lectureSet17_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"18"])
            [lectureSet18_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"19"])
            [lectureSet19_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"20"])
            [lectureSet20_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"21"])
            [lectureSet21_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"22"])
            [lectureSet22_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"23"])
            [lectureSet23_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"24"])
            [lectureSet24_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"25"])
            [lectureSet25_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"26"])
            [lectureSet26_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"27"])
            [lectureSet27_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"28"])
            [lectureSet28_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"29"])
            [lectureSet29_ addObject:currentObject];
        else if ([currentObject hasPrefix:@"30"])
            [lectureSet30_ addObject:currentObject];
        
        NSLog(@"list of lecture set 1 is %@", lectureSet1_);
        
        rootArrayOfLectures = [[NSMutableArray alloc] initWithObjects:lectureSet1_, lectureSet2_,lectureSet3_,lectureSet4_,lectureSet5_,lectureSet6_,lectureSet7_,lectureSet8_,lectureSet9_,lectureSet10_,lectureSet11_,lectureSet12_,lectureSet13_,lectureSet14_,lectureSet15_,lectureSet16_,lectureSet17_,lectureSet18_,lectureSet19_,lectureSet20_,lectureSet21_,lectureSet22_,lectureSet23_,lectureSet24_,lectureSet25_,lectureSet26_,lectureSet27_,lectureSet28_,lectureSet29_,lectureSet30_, nil];
        
        [currentObject release];
        
    }
}

-(int)getNumberOfLecturers
{
    return numberOfLecturers_;
}

-(NSString *)getLecturerNameForIndex:(int) lectureIndex
{
    // this is an array of lectures, each element in the array is a comma seperated list
    NSArray *lectures = [rootArrayOfLectures objectAtIndex:lectureIndex];
    NSArray *listItems = [[lectures objectAtIndex:0] componentsSeparatedByString:@","];
    NSLog(@"list of lectures = %@ and first element is %@", lectures, listItems);
    return [listItems objectAtIndex:1];
}

-(int)getNumberOfLecturesForIndex:(int) lectureIndex
{
    NSArray *lectures = [rootArrayOfLectures objectAtIndex:lectureIndex];
    NSLog(@"number of lectures for index %d is %d", lectureIndex, [lectures count]);
    return [lectures count];
}

-(NSString *)getLecturerPictureForIndex:(int) lectureIndex
{
    // this is an array of lectures, each element in the array is a comma seperated list
    NSArray *lectures = [rootArrayOfLectures objectAtIndex:lectureIndex];
    NSArray *listItems = [[lectures objectAtIndex:0] componentsSeparatedByString:@","];
    NSLog(@"list of lectures = %@ and picture path is %@", lectures, [listItems objectAtIndex:5]);
    return [listItems objectAtIndex:5];
}

-(NSArray *)getLectureDataForIndex:(int) lectureIndex
{
    NSArray *lectures = [rootArrayOfLectures objectAtIndex:lectureIndex];
    return lectures;
}

-(NSString *)getLecturePathForIndex:(int) lectureIndex
{
    // this is an array of lectures, each element in the array is a comma seperated list
    NSArray *lectures = [rootArrayOfLectures objectAtIndex:lectureIndex];
    NSArray *listItems = [[lectures objectAtIndex:0] componentsSeparatedByString:@","];
    NSLog(@"list of lectures = %@ and picture path is %@", lectures, [listItems objectAtIndex:5]);
    return [listItems objectAtIndex:3];    
}

@end
