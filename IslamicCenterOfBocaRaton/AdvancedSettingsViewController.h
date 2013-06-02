//
//  AdvancedSettingsViewController.h
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 6/12/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlistReaderWriter.h"
#import <AVFoundation/AVFoundation.h>

@interface AdvancedSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> 
{
    UINavigationBar *navigationBar_;
    IBOutlet UITableView *tableView_;
    UISwitch *switch3_;
    UISwitch *switch4_;
    int numberOfIqamaRows_;
    int numberOfAthaanRows_;
    PlistReaderWriter *plistData_;
    UISlider *slider_;
    NSMutableString *iqamaString_;
    NSIndexPath *currentIndexPathForAthaan_;
    NSIndexPath *currentIndexPathForIqama_;
    NSString *toggleStatus_;
    AVAudioPlayer *audioPlayer_;
    NSArray *athaanNames_;
}

-(void)mySelectorForIqamaConfiguration;
-(void)sliderValueChange:(id)sender;
-(void) buttonPressed:(id)sender;
-(void) playAthaanSound:(NSInteger)athaanIndex;

@property (nonatomic, retain) NSIndexPath *currentIndexPathForAthaan;
@property (nonatomic, retain) NSIndexPath *currentIndexPathForIqama;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSString *toggleStatus;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

@end
