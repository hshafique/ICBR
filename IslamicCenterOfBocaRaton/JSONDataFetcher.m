//
//  JSONDataFetcher.m
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 11/6/11.
//  Copyright (c) 2011 Siemens Enterprise. All rights reserved.
//

#import "JSONDataFetcher.h"
#import "JSON.h"

@implementation JSONDataFetcher

@synthesize webData = webData_;
@synthesize loadingStatus = loadingStatus_;
@synthesize imageList = imageList_;
@synthesize allTweets = allTweets_;

-(id) init
{
    loadingStatus_ = [[NSString alloc] init];
    
    // construct the web service url    
    tweets = [NSMutableArray array];
    allTweets_ = [[NSArray alloc] init];
	/*NSURLRequest *request = [NSURLRequest requestWithURL:
							 [NSURL URLWithString:@"http://search.twitter.com/search.json?q=from:icbr_masjid&rpp=5"]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];*/

    NSURL *url = [NSURL URLWithString:@"http://search.twitter.com/search.json?q=from:icbr_masjid&rpp=5"];
    
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

    return self;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData_ appendData:data];
//    NSLog(@"web data is %@", webData_);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[webData_ setLength:0];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"did fail with error %@", error);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Finished loading web data");
    [connection release];
	NSString *responseString = [[NSString alloc] initWithData:webData_ encoding:NSUTF8StringEncoding];
    //NSLog(@"response string is %@", responseString);
	[webData_ release];
	
	NSDictionary *results = [responseString JSONValue];
	
	allTweets_ = [results objectForKey:@"results"];
	
//    NSLog(@"all tweets = %@", allTweets_);
	/*[viewController setTweets:allTweets];
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];*/
    self.loadingStatus = @"DONE";

}

@end
