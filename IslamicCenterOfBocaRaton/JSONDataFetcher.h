//
//  JSONDataFetcher.h
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 11/6/11.
//  Copyright (c) 2011 Siemens Enterprise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONDataFetcher : NSObject
{
    NSMutableData *webData_;
    NSURLConnection *connectionInProgress_;
    NSArray *imageList_;
    
    NSString *loadingStatus_;
    NSString *loadedData_;
    NSMutableArray *tweets;
    
    NSArray *allTweets_;
    
}

@property (nonatomic, retain) NSMutableData *webData;
@property (nonatomic, retain) NSString *loadingStatus;
@property (nonatomic, retain) NSArray *imageList;
@property (nonatomic, retain) NSArray *allTweets;

@end
