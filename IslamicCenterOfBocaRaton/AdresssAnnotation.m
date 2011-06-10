//
//  AdresssAnnotation.m
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 4/7/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import "AdresssAnnotation.h"

@implementation AdresssAnnotation
@synthesize coordinate;
@synthesize title = title_;
@synthesize subTitle = subTitle_;

-(NSString*) title
{
    return title_;
}

-(NSString*) subtitle
{
    return subTitle_;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
    title_ = [[NSString alloc] init];
    subTitle_ = [[NSString alloc] init];
    
	return self;
}

@end