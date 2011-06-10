//
//  ValidateLocationRequest.m
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 4/12/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import "ValidateLocationRequest.h"


@implementation ValidateLocationRequest
@synthesize finishedParsing = finishedParsing_;

-(id)init
{
    value_ = [[NSMutableString alloc] init];
    foundLocation_ = NO;
    settings = [[PlistReaderWriter alloc] init];
    
    return self;
}

-(void)getCityInformationFromGoogle:(NSString *)cityName
{
    NSLog(@"loading city data");

    // construct the web service url
    NSMutableString *googleApiString = [[NSMutableString alloc] initWithFormat:@"http://maps.googleapis.com/maps/api/geocode/xml?address=%@&sensor=false", cityName];

    [googleApiString replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [googleApiString length])];
    
    NSURL *url = [NSURL URLWithString:googleApiString];
    
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
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:webData_];
    
    //give it a delegate
    [parser setDelegate:self];
    [parser parse];
    
    [parser release];
    
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"location"])
    {
        foundLocation_ = YES;
    }
    else
    {
        title_ = elementName;
    }
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
    if (foundLocation_ == YES && [elementName isEqualToString:@"lat"])
    {
        NSLog(@"latitude is %@", value_);
    }
    else if (foundLocation_ == YES && [elementName isEqualToString:@"lng"])
    {
        NSLog(@"longitude is %@", value_);
    }
    
    if ([elementName isEqualToString:@"location"])
        foundLocation_ = NO;
    
    if ([elementName isEqualToString:@"formatted_address"])
    {
        NSLog(@"address is %@", value_);
        // lets ensure that the entered city is a valid US city
        NSArray *chunks = [value_ componentsSeparatedByString: @","];
        if ([[chunks objectAtIndex:2] isEqualToString:@" USA"])
            [settings setFormattedAddressInPlist:value_];
        else
            self.finishedParsing = @"FAILED";
    }
    if ([elementName isEqualToString:@"status"] && [value_ isEqualToString:@"ZERO_RESULTS"])
        self.finishedParsing = @"FAILED";
    //clear out the value_ ivar
    [value_ setString:@""];
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"parsing completed");
    self.finishedParsing = @"DONE";
    [webData_ release];
    [connectionInProgress_ release];
    [finishedParsing_ release];
    [value_ release];
    [title_ release];
}


@end