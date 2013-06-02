//
//  SettingsViewController.h
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 4/3/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlistReaderWriter.h"
#import "DailyPrayerTimes.h"
#import "ValidateLocationRequest.h"


@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    IBOutlet UITableView *tableView_;
    
    NSArray *notificationArray_;
    NSArray *athaanNames_;
    UISwitch *switch1_;
    UISwitch *switch2_;
    UISwitch *switch3_;
    UISwitch *switch4_;
    UISlider *slider_;
    UILabel *sliderValue_;
    UITextField *textField_;
    NSString *toggleStatus_;
    NSIndexPath *currentIndexPath_;
    PlistReaderWriter *plistData_;
}

-(void)mySelectorForAthaan;
-(void)mySelectorForIqama;
-(void)mySelectorForIqamaConfiguration;
-(void)sliderChanged:(id)sender;
-(void)mySelectorForAthaanConfiguration;

@property (nonatomic, retain) NSString *toggleStatus;
@property (nonatomic, retain) NSIndexPath *currentIndexPath;
@end
