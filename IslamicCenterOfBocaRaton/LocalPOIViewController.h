//
//  LocalPOIViewController.h
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 3/18/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "POIDetailsViewController.h"

@interface LocalPOIViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate,POIDetailViewContollerDelegate> {
    IBOutlet MKMapView *mapView_;
    CLLocationManager *locationManager;
    NSArray *addressList_;
    NSArray *addressName_;
    NSArray *addressSubName_;
    POIDetailsViewController *detailsViewController_;
}

-(CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr ;
-(NSInteger)getTableIndexForPOI:(NSString*)POITitle;

@property (nonatomic, retain) IBOutlet POIDetailsViewController *detailsViewController;

@end
