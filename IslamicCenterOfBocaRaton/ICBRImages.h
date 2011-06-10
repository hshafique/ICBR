//
//  ICBRImages.h
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 4/4/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICBRImages : NSObject {
    NSMutableData *webData_;
    NSURLConnection *connectionInProgress_;
    NSArray *imageList_;
    
    NSString *loadingStatus_;
    NSString *loadedData_;
    
}

@property (nonatomic, retain) NSMutableData *webData;
@property (nonatomic, retain) NSString *loadingStatus;
@property (nonatomic, retain) NSArray *imageList;

-(void) loadImageData:(NSInteger)currentPage;

@end
