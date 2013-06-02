//
//  ICBRImagesViewController.m
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 4/4/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import "ICBRImagesViewController.h"


@implementation ICBRImagesViewController
@synthesize imageData = imageData_;
@synthesize activityView = activityView_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        imageData_ = [[ICBRImages alloc] init];
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
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
    [self.imageData addObserver:self forKeyPath:@"loadingStatus" options:NSKeyValueObservingOptionNew context:NULL];

    [activityView_ startAnimating];
    [imageData_ loadImageData:pageNumber_];
    // Do any additional setup after loading the view from its nib.
    NSString *urlAddress = [imageData_ getStringBasedOnPage:pageNumber_];
    //NSString *urlAddress = @"http://hosted-p0.vresp.com/626586/9216464906/ARCHIVE";
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    webView_.scalesPageToFit = YES;
    [webView_ loadRequest:requestObj];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || 
            (interfaceOrientation == UIInterfaceOrientationLandscapeRight));

}

-(IBAction) buttonPressed:(id)sender
{
    UIImage *image = [[UIImage alloc] initWithData:[imageData_ webData]];
    [imageView_ setImage:image];
    [image release];
}

-(void) setPageNumber:(int)pageNumber
{
    pageNumber_ = pageNumber;
}

-(void)reloadData
{
    [self.imageData addObserver:self forKeyPath:@"loadingStatus" options:NSKeyValueObservingOptionNew context:NULL];
    
    [activityView_ startAnimating];
    [imageData_ loadImageData:pageNumber_];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UIImage *image = [[UIImage alloc] initWithData:[imageData_ webData]];
    [activityView_ stopAnimating];
    [imageView_ setImage:image];
    [image release];    
}
@end
