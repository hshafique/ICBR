//
//  UpcomingActivitiesViewController.h
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 11/7/11.
//  Copyright (c) 2011 Siemens Enterprise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONDataFetcher.h"

@interface UpcomingActivitiesViewController : UIViewController
{
    IBOutlet UITableView *tableView_;
    JSONDataFetcher *twitterData_;

    NSMutableArray *listOfUrls_;
    
    NSArray *localTweets_;
    BOOL noTweetsPresent_;

    UIView *_hudView;
    UIActivityIndicatorView *_activityIndicatorView;
    UILabel *_captionLabel;

}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) JSONDataFetcher *twitterData;
-(void)buttonPressed:(id)sender;

@end
