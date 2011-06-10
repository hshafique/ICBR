//
//  AdresssAnnotation.h
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 4/7/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AdresssAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title_;
    NSString *subTitle_;

}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subTitle;

@end
