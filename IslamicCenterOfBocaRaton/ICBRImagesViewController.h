//
//  ICBRImagesViewController.h
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 4/4/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICBRImages.h"


@interface ICBRImagesViewController : UIViewController {
    IBOutlet UIImageView *imageView_;
    IBOutlet UIButton *button_;
    IBOutlet UIActivityIndicatorView *activityView_;
    IBOutlet UIWebView *webView_;
    
    ICBRImages *imageData_;
    int pageNumber_;
}

@property (nonatomic, retain) ICBRImages *imageData;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;
-(IBAction) buttonPressed:(id)sender;
-(void) setPageNumber:(int)pageNumber;
-(void)reloadData;

@end
