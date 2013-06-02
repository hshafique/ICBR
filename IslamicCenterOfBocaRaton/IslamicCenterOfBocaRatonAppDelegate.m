//
//  IslamicCenterOfBocaRatonAppDelegate.m
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 3/18/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import "IslamicCenterOfBocaRatonAppDelegate.h"
#import "PrayerTimesViewController.h"
#import "LocalPOIViewController.h"
#import "DailyPrayerScrollerViewController.h"
#import "SettingsViewController.h"
#import "ICBRImagesViewController.h"
#import "ICBRImageScrollViewController.h"
#import "ICBRImages.h"
#import "AdvancedSettingsViewController.h"
#import "LecturesRootViewController.h"
#import "UpcomingActivitiesViewController.h"
#import "PlistReaderWriter.h"

@implementation IslamicCenterOfBocaRatonAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    PlistReaderWriter *plistData = [[PlistReaderWriter alloc]init];
    ICBRImages *prayerOverride = [[ICBRImages alloc] init];

    // Override point for customization after application launch.
    if ([[prayerOverride.imageList objectAtIndex:0] isEqualToString:@"YES"])
    {
        [plistData setIqamaOverride:YES];
        [plistData setFajr:[prayerOverride.imageList objectAtIndex:1]];
        [plistData setDhohur:[prayerOverride.imageList objectAtIndex:2]];
        [plistData setAsr:[prayerOverride.imageList objectAtIndex:3]];
        [plistData setMaghrib:[prayerOverride.imageList objectAtIndex:4]];
        [plistData setIsha:[prayerOverride.imageList objectAtIndex:5]];
    }
    else
        [plistData setIqamaOverride:NO];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    // create three view controllers
    UIViewController *vc1 = [[DailyPrayerScrollerViewController alloc] init];
    UIViewController *vc3 = [[LocalPOIViewController alloc] init];
    UIViewController *vc4 = [[LecturesRootViewController alloc] init];
    UIViewController *vc5 = [[AdvancedSettingsViewController alloc] init];
    UIViewController *vc2 = [[UpcomingActivitiesViewController alloc] init];
    
    
    // make an array containing the three view controllers
    viewControllers_ = [NSArray arrayWithObjects:vc1, vc4, vc2, vc3, vc5, nil];
    
    // the view controller array retains vc1, vc2, and vc3, and vc4 we can release
    // our ownership of them in this method
    [vc1 release];
    [vc2 release];
    [vc3 release];
    [vc4 release];    
    [vc5 release];
    
    [vc5 addObserver:self forKeyPath:@"toggleStatus" options:NSKeyValueObservingOptionNew context:NULL];

    // attach them to the tab bar controller
    [tabBarController setViewControllers:viewControllers_];
    
    // set tabbarcontroller as root view controller of window
    [self.window setRootViewController:tabBarController];
    
    // the window retains tabbarcontroller, we can release our reference
    [tabBarController release];
    
    [self.window makeKeyAndVisible];
    //application.applicationIconBadgeNumber = 0;
    
    // Handle launching from a notification
         

    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        NSLog(@"Recieved Notification on launch%@",localNotif);
        
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    NSLog(@"applicationwillenterforeground");
    // when application becomes active again we need to do two things to
    // refresh application data
    // 1. check the current data month, day, year with the currentDateInP_ for page 0
    // 2. check to see if the activity page needs to be restarted
    DailyPrayerScrollerViewController *prayerController = [viewControllers_ objectAtIndex:0];

    
    PrayerTimesViewController *pt = [prayerController.viewControllers objectAtIndex:0];
    
    NSDate * now = [NSDate date];
    //add 20 hours to both the current date and the date in the view controller
    NSTimeInterval secondsInEightHours = 20 * 60 * 60;
    NSDate *dateHoursAhead = [now dateByAddingTimeInterval:secondsInEightHours];
    
    NSDate *dateInViewController = [[pt currentDateInP] dateByAddingTimeInterval:secondsInEightHours];
    
    NSLog(@"current date is %@ and date in view controller is %@", dateHoursAhead, dateInViewController);
    
    int days1 = [dateHoursAhead timeIntervalSince1970] / 86400;
    int days2 = [dateInViewController timeIntervalSince1970] / 86400;
    
    NSLog(@"days 1 is %d and days 2 is %d",days1, days2);
    
    if (days1 != days2) //reload data all the time
    {
        [prayerController reloadPrayerDate];
    }

    // now lets check to see if the image array has been updated
    PlistReaderWriter *plistData = [[PlistReaderWriter alloc]init];
    ICBRImages *prayerOverride = [[ICBRImages alloc] init];
    if ([[prayerOverride.imageList objectAtIndex:0] isEqualToString:@"YES"])
    {
        [plistData setIqamaOverride:YES];
        [plistData setFajr:[prayerOverride.imageList objectAtIndex:1]];
        [plistData setDhohur:[prayerOverride.imageList objectAtIndex:2]];
        [plistData setAsr:[prayerOverride.imageList objectAtIndex:3]];
        [plistData setMaghrib:[prayerOverride.imageList objectAtIndex:4]];
        [plistData setIsha:[prayerOverride.imageList objectAtIndex:5]];
    }
    else
        [plistData setIqamaOverride:NO];


}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    // Override point for customization after application launch.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

-(void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notification
{
    // Handle the notificaton when the app is running
    
}
- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"add an update");
    DailyPrayerScrollerViewController *prayerController = [viewControllers_ objectAtIndex:0];
    
    PrayerTimesViewController *pt = [prayerController.viewControllers objectAtIndex:0];
    if ([keyPath isEqualToString:@"toggleStatus"])
    {
        [pt cancelAllNotifications];
        [pt startAthaanAlarms];
        [pt startIqamaAlarms];
    }
}

@end
