//
//  ValidateLocationRequest.h
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 4/12/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlistReaderWriter.h"


@interface ValidateLocationRequest : NSObject <NSXMLParserDelegate>
{
    NSURLConnection *connectionInProgress_;
    NSMutableData *webData_;
    NSString *title_;
    NSMutableString *value_;
    BOOL foundLocation_;
    PlistReaderWriter *settings;
    NSString *finishedParsing_;
}

@property(nonatomic, retain) NSString *finishedParsing;

-(void)getCityInformationFromGoogle:(NSString *)cityName;

@end
