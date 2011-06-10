//
//  PrayerTimesData.m
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 3/18/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import "PrayerTimesData.h"

@implementation PrayerTimesData
@synthesize connectionInProgress = connectionInProgress_;
@synthesize webData = webData_;
@synthesize name;
@synthesize iqamaTimes = iqamaTimes_;
@synthesize status = status_;


-(id) init
{
    NSLog(@"into init");
    iqamaTimes_ = [[NSMutableArray alloc] init];
    status_ = [[NSString alloc] init];
    return self;
}

-(void)setIsDataLoaded
{
    NSLog(@"into set");
}

-(void)loadIqamaTimes
{
    // construct the web service url
    NSURL *url = [NSURL URLWithString:@"http://www.icbr.org"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    //clear out the existing progress if there is one
    if (connectionInProgress_)
    {
        [connectionInProgress_ cancel];
        [connectionInProgress_ release];
    }
    [webData_ release];
    webData_ = [[NSMutableData alloc] init];
    
    // create and initiate the connection non - blocking
    connectionInProgress_ = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData_ appendData:data];
    //NSLog(@"received web data %@", webData_);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Finished loading web data");
    self.name = [[NSString alloc] initWithData:webData_ encoding:NSUTF8StringEncoding];
    [self parseHtmlData];
}

-(void)parseHtmlData
{
    NSRange rangeF = [name rangeOfString:@"Fajr:"];
    NSRange rangeD = [name rangeOfString:@"Duhur:"];
    NSRange rangeA = [name rangeOfString:@"Asr:"];
    NSRange rangeI = [name rangeOfString:@"Isha:"];
    NSRange rangeJ = [name rangeOfString:@"Jumaa:"];
    int htmlLength = [name length];
    
    NSString *subString = [[NSString alloc] init];
    
    if (rangeF.length > 0 && (htmlLength > (rangeF.location + 9)))
    {
        NSRange newRange = NSMakeRange(rangeF.location + rangeF.length, 9);
        // starting at range + length get 6 bytes
        subString = [name substringWithRange:newRange];
        subString = [subString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        subString = [subString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"b<</"]];

        NSLog(@"Fajr time is %@", subString );
        [iqamaTimes_ addObject:subString];
    }
    if (rangeD.length > 0 && (htmlLength > (rangeD.location + 9)))
    {
        NSRange newRange = NSMakeRange(rangeD.location + rangeD.length, 9);
        // starting at range + length get 6 bytes
        subString = [name substringWithRange:newRange];
        subString = [subString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        subString = [subString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"b<</"]];
        
        NSLog(@"Dhohur time is %@", subString );
        [iqamaTimes_ addObject:subString];
    }
    if (rangeA.length > 0 && (htmlLength > (rangeA.location + 9)))
    {
        NSRange newRange = NSMakeRange(rangeA.location + rangeA.length, 9);
        // starting at range + length get 6 bytes
        subString = [name substringWithRange:newRange];
        subString = [subString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        subString = [subString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"b<</"]];
        
        NSLog(@"Asr time is %@", subString );
        [iqamaTimes_ addObject:subString];
    }
    if (rangeI.length > 0 && (htmlLength > (rangeI.location + 9)))
    {
        NSRange newRange = NSMakeRange(rangeI.location + rangeI.length, 9);
        // starting at range + length get 6 bytes
        subString = [name substringWithRange:newRange];
        subString = [subString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        subString = [subString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"b<</"]];
        
        NSLog(@"Isha time is %@", subString );
        [iqamaTimes_ addObject:subString];
    }
    if (rangeJ.length > 0 && (htmlLength > (rangeJ.location + 9)))
    {
        NSRange newRange = NSMakeRange(rangeJ.location + rangeJ.length, 9);
        // starting at range + length get 6 bytes
        subString = [name substringWithRange:newRange];
        subString = [subString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        subString = [subString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"b<</"]];
        
        NSLog(@"Jumaa time is %@", subString );
        [iqamaTimes_ addObject:subString];
    }
    self.status = @"DONE";
    

}
@end
