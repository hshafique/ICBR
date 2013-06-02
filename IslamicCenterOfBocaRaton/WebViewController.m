//
//  WebViewController.m
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 12/31/11.
//  Copyright (c) 2011 Siemens Enterprise. All rights reserved.
//

#import "WebViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation WebViewController
@synthesize webaddress = webaddress_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        webaddress_ = [[NSString alloc] init];
    }
    return self;
}

-(id) initWithWebAddress:(NSString*)web
{
    webaddress_ = [[NSString alloc] initWithString:web];
    return self;
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
    // Do any additional setup after loading the view from its nib.
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:webaddress_];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [detailedTweet loadRequest:requestObj];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {    
//    m_activity.hidden= TRUE;     
//    [m_activity stopAnimating];  
    NSLog(@"Web View started loading...");
    [_activityIndicatorView stopAnimating];
    [_hudView removeFromSuperview];

}

- (void)webViewDidStartLoad:(UIWebView *)webView {     
//    m_activity.hidden= FALSE;    
//    [m_activity startAnimating];     
    NSLog(@"Web View Did finish loading");
    _hudView = [[UIView alloc] initWithFrame:CGRectMake(80, 125, 170, 170)];
    _hudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _hudView.clipsToBounds = YES;
    _hudView.layer.cornerRadius = 10.0;
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.frame = CGRectMake(65, 40, _activityIndicatorView.bounds.size.width, _activityIndicatorView.bounds.size.height);
    [_hudView addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    
    _captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    _captionLabel.backgroundColor = [UIColor clearColor];
    _captionLabel.textColor = [UIColor whiteColor];
    _captionLabel.adjustsFontSizeToFitWidth = YES;
    _captionLabel.textAlignment = UITextAlignmentCenter;
    _captionLabel.text = @"Loading...";
    [_hudView addSubview:_captionLabel];
    
    [self.view addSubview:_hudView];

}
@end
