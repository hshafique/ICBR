//
//  LocalPOIViewController.m
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 3/18/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import "LocalPOIViewController.h"
#import "AdresssAnnotation.h"
#import <CoreLocation/CoreLocation.h>
#import "SettingsViewController.h"


@implementation LocalPOIViewController
@synthesize detailsViewController = detailsViewController_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *tbi = [self tabBarItem];
        //[tbi setTitle:@"Points of Interest"];
        [tbi setImage:[UIImage imageNamed:@"71-compass.png"]];
        [tbi setTitle:@"Points of Interest"];

        addressList_ = [[NSArray alloc] initWithObjects:@"3100 NW 5th Avenue, Boca Raton, FL 33431", @"123 NW 13th St., Boca Raton, FL 33432", @"4893 Purdy Lane, West Palm Beach, FL 33415", @"507 Ne 6th St, Pompano Beach, FL 33060",@"5457 NW 108th Ave, Fort Lauderdale, FL 33351, USA", @"8658 NW 44th ST, Fort Lauderdale, FL 33351, USA", @"1557 NW5th St, Fort Lauderdale, FL 33311, USA", @"2542 Franklin Park Drive, Fort Lauderdale, FL 33311, USA", @"3222 Holiday Springs Blvd. Margate, FL 33063, USA", nil];
        
        addressSubName_ = [[NSArray alloc] initWithObjects:@"Masjid and Islamic School", @"Local Business", @"Masjid", @"Masjid",@"Masjid",@"Masjid", @"Masjid",@"Masjid", @"Masjid", @"Masjid",nil];
        
        addressName_ = [[NSArray alloc] initWithObjects:@"Islamic Center of Boca Raton", @"Airlink Tours and Travel", @"West Palm Beach Masjid", @"Pompano Masjid", @"Islamic Center of South Florida", @"Islamic Center of Broward", @"Masjid Tawhid", @"Masjid Al Iman",@"Masjid Jamaat Al Mumineen", nil];

        detailsViewController_ = [[POIDetailsViewController alloc] init];
        [detailsViewController_ setDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [addressList_ release];
    [addressName_ release];
    [addressName_ release];
    [detailsViewController_ release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    // We want all results from the location manager
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    
    // And we want it to be as accurate as possible
    // regardless of how much time/power it takes
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //  I ADDED THIS LINE BELOW TO WHAT WAS IN THE BOOK.
    // Once configured, the location manager must be "started".
    //[locationManager startUpdatingLocation];
    
    // set mapview to users current location
    [mapView_ setShowsUserLocation:YES];
    for (int i = 0; i < [addressList_ count]; i++)
    {
        CLLocationCoordinate2D coords = [self getLocationFromAddressString:[addressList_ objectAtIndex:i]];
        AdresssAnnotation *addAnnotation = [[AdresssAnnotation alloc] initWithCoordinate:coords];
        addAnnotation.title = [addressName_ objectAtIndex:i];
        addAnnotation.subTitle = [addressSubName_ objectAtIndex:i];
        
        [mapView_ addAnnotation:addAnnotation];
        [addAnnotation release];    

    }/*
    [self.navigationController setToolbarHidden:NO animated:NO];

    // create a custom navigation bar button and set it to always says "Back"
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"Back";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];*/

    // Do any additional setup after loading the view from its nib.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr 
{
    NSError* error;
    NSString *urlStr = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", 
                        [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *locationStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlStr] encoding:NSASCIIStringEncoding error:&error];
    NSArray *items = [locationStr componentsSeparatedByString:@","];
    
    double lat = 0.0;
    double longitude = 0.0;
    
    if([items count] >= 4 && [[items objectAtIndex:0] isEqualToString:@"200"]) {
        lat = [[items objectAtIndex:2] doubleValue];
        longitude = [[items objectAtIndex:3] doubleValue];
    }
    else {
        NSLog(@"Address, %@ not found: Error %@",addressStr, [items objectAtIndex:0]);
    }
    CLLocationCoordinate2D location;
    location.latitude = lat;
    location.longitude = longitude;
    
    return location;
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id <MKAnnotation> mp = [annotationView annotation];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 10000, 10000);
    [mapView setRegion:region animated:YES];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{

    CLLocation *location = [userLocation location];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([location coordinate], 60000, 60000);
    [mapView setRegion:region animated:YES];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%@", newLocation);
    NSLog(@"%@", oldLocation);    
    
    // call this the first time only when oldLocation is Null
    if (!oldLocation) {
        NSLog(@"setting location");
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 25000, 2500);
        [mapView_ setRegion:region animated:YES];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation){
        return nil; //default to blue dot
    }
	
    MKPinAnnotationView *pin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"parkingloc"];
	[pin setPinColor:MKPinAnnotationColorPurple];
    
	// Set up the Left callout
	UIButton *myDetailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	myDetailButton.frame = CGRectMake(0, 0, 23, 23);
	myDetailButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	myDetailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    myDetailButton.tag = [self getTableIndexForPOI:[annotation title]];
	[myDetailButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
	
	
	pin.rightCalloutAccessoryView = myDetailButton;
	pin.animatesDrop = YES;
	pin.canShowCallout = YES;
	
	return pin;
}

- (void)showDetails:(id)sender
{
    NSLog(@"the tag value is: %d", [sender tag]);
    [detailsViewController_ setCurrentIndex:[sender tag]];
    [self presentViewController:self.detailsViewController animated:YES completion:nil];    
}

-(NSInteger)getTableIndexForPOI:(NSString*)POITitle
{
    if ([POITitle isEqual:@"Islamic Center of Boca Raton"])
        return 0;
    else if ([POITitle isEqual:@"Airlink Tours and Travel"])
        return 1;
    else if ([POITitle isEqual:@"West Palm Beach Masjid"])
        return 2;
    else if ([POITitle isEqual:@"Pompano Masjid"])
        return 3;
    else if ([POITitle isEqual:@"Islamic Center of South Florida"])
        return 4;
    else if ([POITitle isEqual:@"Islamic Center of Broward"])
        return 5;
    else if ([POITitle isEqual:@"Masjid Tawhid"])
        return 6;
    else if ([POITitle isEqual:@"Masjid Al Iman"])
        return 7;
    else if ([POITitle isEqual:@"Masjid Jamaat Al Mumineen"])
        return 8;
    else
        return 9;
}

- (void)removeDetailViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
