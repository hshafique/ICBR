//
//  ICBRImageScrollViewController.h
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 4/4/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICBRImages.h"


@interface ICBRImageScrollViewController : UIViewController <UIScrollViewDelegate> {
	UIScrollView *scrollView_;
	UIPageControl *pageControl_;
    NSMutableArray *viewControllers_;
    NSInteger numberOfPages_;
	
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
    
    ICBRImages *imageList_;
    BOOL objectDidEnterForeground;
    
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) ICBRImages *imageList;

- (IBAction)changePage:(id)sender;
-(void)reloadImages;

@end
