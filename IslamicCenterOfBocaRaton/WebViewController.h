//
//  WebViewController.h
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 12/31/11.
//  Copyright (c) 2011 Siemens Enterprise. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
{
    IBOutlet UIWebView *detailedTweet;
    NSString *webaddress_;
    
    UIView *_hudView;
    UIActivityIndicatorView *_activityIndicatorView;
    UILabel *_captionLabel;

}

@property (nonatomic, retain) NSString *webaddress;
-(id) initWithWebAddress:(NSString*)web;
@end
