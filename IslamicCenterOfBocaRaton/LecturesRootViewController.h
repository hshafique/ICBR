//
//  LecturesRootViewController.h
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 8/31/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LectureData.h"
#import "LecturesDetailedViewController.h"

@interface LecturesRootViewController : UIViewController <LecturesDetailedViewContollerDelegate> {
    LectureData* lectureData_;
    IBOutlet UITableView *tableView_;
    IBOutlet UIImageView *imageView_;
    LecturesDetailedViewController *lectureDetailsViewController_;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) LecturesDetailedViewController *lectureDetailsViewController;

@end
