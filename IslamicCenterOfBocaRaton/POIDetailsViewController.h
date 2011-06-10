//
//  POIDetailsViewController.h
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 4/24/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol POIDetailViewContollerDelegate <NSObject>
- (void)removeDetailViewController;
@end

@interface POIDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UINavigationBar *navigationBar_;
    id<POIDetailViewContollerDelegate> delegate_;
    IBOutlet UITableView *tableView_;
    NSArray *nameOfBusness_;
    NSArray *typeOfBusiness_;
    NSArray *addressList_;
    NSArray *briefDescription_;
    int currentIndex_;
}

@property (assign) id<POIDetailViewContollerDelegate> delegate;

-(IBAction) buttonPressed:(id)sender;
@property (nonatomic, retain) UINavigationBar *navigationBar;
-(void) setCurrentIndex:(int)value;

@end
