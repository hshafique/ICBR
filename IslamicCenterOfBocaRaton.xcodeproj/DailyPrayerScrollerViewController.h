//
//  DailyPrayerScrollerViewController.h
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 4/1/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DailyPrayerScrollerViewController : UIViewController <UIScrollViewDelegate> {
	UIScrollView *scrollView_;
	UIPageControl *pageControl_;
    NSMutableArray *viewControllers_;
	
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
    BOOL objectDidEnterForeground;
    
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) UIPageControl *pageControl;

-(void)reloadPrayerDate;

- (IBAction)changePage:(id)sender;

@end
