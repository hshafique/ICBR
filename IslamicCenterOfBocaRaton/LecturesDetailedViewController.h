//
//  LecturesDetailedViewController.h
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 9/13/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol LecturesDetailedViewContollerDelegate <NSObject>
- (void)removeDetailViewController;
@end

@interface LecturesDetailedViewController : UIViewController {
    // this will be used in order to get the correct lecturer data
    int lectureIndex_;
    IBOutlet UITableView *tableView_;
    IBOutlet UIImageView *imageView_;
    NSArray* listOfLectures_;
    AVAudioPlayer *audioPlayer_;
    UINavigationBar *navigationBar_; 
    id<LecturesDetailedViewContollerDelegate> delegate_;
    MPMoviePlayerController *moviePlayer;

}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *listOfLectures;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (assign) id<LecturesDetailedViewContollerDelegate> delegate;
-(IBAction) buttonPressed:(id)sender;
-(void)moviePlaybackDidFinish:(NSNotification*)notification;

@end
