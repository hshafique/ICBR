//
//  ICBRImages.m
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 4/4/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import "ICBRImages.h"


@implementation ICBRImages

@synthesize webData = webData_;
@synthesize loadingStatus = loadingStatus_;
@synthesize imageList = imageList_;

-(id) init
{
    loadingStatus_ = [[NSString alloc] init];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    // construct the web service url
    NSURL *url = [NSURL URLWithString:@"http://www.abd-apps.com/iphone_app/prayer.txt"];
    
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
        loadedData_ = [[NSString alloc] initWithData:response
                                                 encoding:NSUTF8StringEncoding];
        //imageList_ = [[NSArray alloc] initWithObjects:[loadedData_ componentsSeparatedByString:@"\r\n"], nil];
        NSArray *listItems = [loadedData_ componentsSeparatedByString:@","];
        imageList_ = [[NSArray alloc] initWithArray:listItems];
        //imageList_ = [loadedData_ componentsSeparatedByString:@"\r\n"];
        //imageList_ = [NSArray arrayWithObjects:[loadedData_ componentsSeparatedByString:@"\r\n"], nil];
    }
    return self;
}

-(void)loadImageData:(NSInteger)currentPage
{
    NSLog(@"loading image files");
    // construct the web service url
    
    NSURL *url = [NSURL URLWithString:[imageList_ objectAtIndex:currentPage]];
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
    self.loadingStatus = @"DONE";
}

-(NSString *)getStringBasedOnPage:(int) pageNumber
{
    return [imageList_ objectAtIndex:pageNumber];
}

@end
