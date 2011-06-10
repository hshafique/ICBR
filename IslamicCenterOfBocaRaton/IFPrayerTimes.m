//
//  IFPrayerTimes.m
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 3/26/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import "IFPrayerTimes.h"

@implementation IFPrayerTimes
@synthesize webData = webData_;
@synthesize connectionInProgress = connectionInProgress_;
@synthesize hijriDate = hijriDate_;
@synthesize dateStatus = dateStatus_;
@synthesize name = name_;

-(id) init
{
    title_ = [[NSString alloc] init];
    dateStatus_ = [[NSString alloc] init];
    return self;
}

-(void)loadHijriAndGregorianDates
{
    NSLog(@"loading athan times");
    // construct the web service url
    NSURL *url = [NSURL URLWithString:@"http://www.islamicfinder.org/prayer_service.php?country=usa&city=delray_beach&state=FL&zipcode=33445&latitude=26.4558&longitude=-80.1064&timezone=-5&HanfiShafi=1&pmethod=5&fajrTwilight1=10&fajrTwilight2=10&ishaTwilight=10&ishaInterval=30&dhuhrInterval=1&maghribInterval=1&dayLight=1&simpleFormat=xml"];
    
    // create a request object with that URL for the exact times
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
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Finished loading web data");
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:webData_];
    
    //give it a delegate
    [parser setDelegate:self];
    [parser parse];
    
    [parser release];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    title_ = elementName;
    value_ = [[NSMutableString alloc] init];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([string length] >0)
    {
        [value_ appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([title_ isEqualToString:@"date"])
        name_ = [NSString stringWithString:value_];
    else if ([title_ isEqualToString:@"hijri"])
        hijriDate_ = [NSString stringWithString:value_];
    [value_ setString:@""];

}


-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    self.dateStatus = @"DONE";
    //[connectionInProgress_ release];
    //[dateStatus_ release];
    //[value_ release];
    //[title_ release];
    //[name_ release];
}

@end
