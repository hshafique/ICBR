//
//  PrayerTimesViewController.m
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 3/18/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import "DailyPrayerTimes.h"
#import "IFPrayerTimes.h"
#import "PrayerTimesViewController.h"

@implementation PrayerTimesViewController

@synthesize activity = activity_;
@synthesize dailyPrayerTimes = dailyPrayerTimes_;
@synthesize dateData = dateData_;
@synthesize currentDateInP = currentDateInP_;
@synthesize atFajr = atFajr_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"PrayerTimesViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    dailyPrayerTimes_ = [[DailyPrayerTimes alloc] init];
    dateData_ = [[IFPrayerTimes alloc] init];
    currentDateInP_ = [[NSDate alloc] init];
    athaanNames_ = [[NSArray alloc] initWithObjects:@"madinah.caf", @"makkah.caf", @"yusuf.caf", @"bird.caf", nil];
    settingsData = [[PlistReaderWriter alloc] init];

    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    formattedAddress_.text = @"Boca Raton, FL USA";

    [self.dailyPrayerTimes addObserver:self forKeyPath:@"ifStatus" options:NSKeyValueObservingOptionNew context:NULL];
    [self.dateData addObserver:self forKeyPath:@"dateStatus" options:NSKeyValueObservingOptionNew context:NULL];
    
    [activity_ startAnimating];
    [self loadPrayerData];
    
    // Do any additional setup after loading the view from its nib.
}

-(void) loadPrayerData
{
    // now we get the islamic finder data
    BOOL needToUpdateDatabse;
    needToUpdateDatabse = [dailyPrayerTimes_ initDatabase];
    
    // we only perform a fetch if the prayer table is empty
    if (needToUpdateDatabse)
    {
        [dailyPrayerTimes_ loadMonthlyAthanTimes];
    }
    
    // use the IFPrayerTimes instance to get the current hijri and calendar dates
    // this lookup is only done to get the hijri and calendar dates
    [dateData_ loadHijriAndGregorianDates];
    
}
-(void) clearPrayerTable
{
    [dailyPrayerTimes_ removePrayerTable];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"view did appear");
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"view will appear");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"dateStatus"])
    {
        NSLog(@"calendar date is received");
        if (pageNumber_ == 0)
            hijriDate_.text = [NSString stringWithString:[dateData_ hijriDate]];
    }
    else if ([keyPath isEqualToString:@"ifStatus"])
    {
        [self updateAthaanTimes];

        // lets set up maghrib time
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSCharacterSet* characters = [NSCharacterSet characterSetWithCharactersInString:@" amp"];
        NSString *tmpMaghribTime = [atMaghrib_.text stringByTrimmingCharactersInSet:characters];
        
        [formatter setDateFormat:@"h:mm"];
        NSDate *athanMaghrib = [formatter dateFromString:tmpMaghribTime];
        [formatter release];
        NSTimeInterval newMaghribTim = 10*60;
        athanMaghrib = [athanMaghrib dateByAddingTimeInterval:newMaghribTim];
        
        NSDateFormatter *dateFormating = [[NSDateFormatter alloc] init];
        [dateFormating setDateFormat:@"hh:mm"];
        
        NSString *theTime = [dateFormating stringFromDate:athanMaghrib];
        theTime = [theTime substringWithRange:NSMakeRange(1, [theTime length]-1)];  
        theTime = [theTime stringByAppendingFormat:@" pm"];
        iqMaghrib_.text = theTime;
        
    }
}

-(void)updateAthaanTimes
{
    [activity_ startAnimating];
    DailyPrayerTimes *result = [[DailyPrayerTimes alloc] init];
    // the month day and year is based on the calendar data
    NSCalendar *gregorian = [[NSCalendar alloc]  initWithCalendarIdentifier:NSGregorianCalendar];

    NSDate *newDate1 = [currentDateInP_ dateByAddingTimeInterval:60*60*24*pageNumber_];

    NSDateComponents *components = [gregorian components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:newDate1];

    NSInteger day = [components day];    
    NSInteger month = [components month];
    NSInteger year = [components year];   
    NSString *dayStr = [NSString stringWithFormat:@"%d", day];    
    NSString *monthStr = [NSString stringWithFormat:@"%d", month];
    NSString *yearStr = [NSString stringWithFormat:@"%d", year];
    
    NSLog(@"getting prayer time for %@ %@ %@", monthStr, dayStr, yearStr);
    
    [result getRowFromDatabase:monthStr:dayStr:yearStr:result];
    if ([[result fajr] isEqual:@""])
    {
        [NSTimer scheduledTimerWithTimeInterval:20
                                     target:self 
                                   selector:@selector(updateAthaanTimes) 
                                   userInfo:nil 
                                    repeats:NO];
        return;
    }
    atFajr_.text= [result fajr];
    atShurooq_.text = [result shurooq];
    atDhohur_.text = [result dhohur];
    atAsr_.text = [result asr];
    atMaghrib_.text = [result maghrib];
    atIsha_.text = [result isha];    
    jumaa_.text = @"1:15 pm";
    iqJumaa_.text = @"1:15 pm";

    // now lets get the iqama times
    [result getIqamaRowFromDatabase:[self convertMonthToString:month]:dayStr:yearStr:result];
    iqFajr_.text = [result fajr];
    iqDhohur_.text = [result dhohur];
    iqAsr_.text = [result asr];
    iqIsha_.text = [result isha];    
    iqShurooq_.text = atShurooq_.text;
    
    [self updateCalendarDateBasedOnPageNumber];
    [self updateMaghribIqamaTime];
}

-(void) setAlarm:(NSDate*)date:(NSString*)eventText
{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = date;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    // Notification details
    localNotif.alertBody = eventText;
    // Set the action button
    localNotif.alertAction = @"View";
    
    NSInteger soundnumber = [settingsData getSoundTypeFromPlist];
    localNotif.soundName = [athaanNames_ objectAtIndex:soundnumber];
    //localNotif.applicationIconBadgeNumber = 1;
    // Specify custom data for the notification
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"refreshdata" forKey:@"action"];
    localNotif.userInfo = infoDict;

	// Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];    
}

-(void) setPageNumber:(int)pageNumber
{
    pageNumber_ = pageNumber;
}

-(void) updateCalendarDateBasedOnPageNumber
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    currentDateInP_ = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:pageNumber_];
    NSDate *tempDate = [gregorian dateByAddingComponents:comps toDate:currentDateInP_ options:0];
    currentDateInP_ = [tempDate copy];
    [comps release];
    NSLog(@"Page date is %@", currentDateInP_);

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE MMMM d, yyyy"];
    NSString *dateString = [dateFormat stringFromDate:currentDateInP_];
    calendarDate_.text = dateString;
    [dateFormat release];
    NSLog(@"page number is %d", pageNumber_);
    if (pageNumber_ == 0)
    {
        [self startAthaanAlarms];
        [self startIqamaAlarms];
    }
    [activity_ stopAnimating];
}

-(void)startAthaanAlarms
{
    // alarms will be started for the currentdate + the next 5 days
    if ([settingsData getAthaanNotificationFromPlist] == NO)
        return;
    
    for (int i=0;i<5;i++)
    {
        // two things need to be done
        // 1) get the date based on our iteration value
        // get the times from the sqlite prayer database
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:i];
        NSDate *tempDate = [gregorian dateByAddingComponents:comps toDate:currentDateInP_ options:0];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMMM d, yyyy"];
        NSString *dateString = [dateFormat stringFromDate:tempDate];

        // now lets get the row of data from the sqlite database
        NSDateComponents *components = [gregorian components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:tempDate];
        NSInteger day = [components day];    
        NSInteger month = [components month];
        NSInteger year = [components year];   
        NSString *dayStr = [NSString stringWithFormat:@"%d", day];    
        NSString *monthStr = [NSString stringWithFormat:@"%d", month];
        NSString *yearStr = [NSString stringWithFormat:@"%d", year];
        DailyPrayerTimes *result = [[DailyPrayerTimes alloc] init];        
        [result getRowFromDatabase:monthStr:dayStr:yearStr:result];
        
        
        // set up asr alarm
        NSString *asrTime = [[NSString alloc] init];
        asrTime = [result asr];
        asrTime = [asrTime stringByAppendingString:@" "];
        asrTime = [asrTime stringByAppendingString:dateString];
        
        NSDateFormatter *dateFormatV2 = [[NSDateFormatter alloc] init];
        [dateFormatV2 setDateFormat:@"h:mm a MMMM d, yyyy"];
        NSDate *date = [dateFormatV2 dateFromString:asrTime];
        [self setAlarm:date:@"The time for Asr Prayer has begun"];
        
        // set up fajr alarm
        NSString *fajrTime = [NSString stringWithFormat:@"%@ %@", [result fajr], dateString];
        date = [dateFormatV2 dateFromString:fajrTime];
        [self setAlarm:date:@"The time for Fajr Prayer has begun"];
        
        // set up dhohur alarm
        NSString *dhohur = [NSString stringWithFormat:@"%@ %@", [result dhohur], dateString];
        date = [dateFormatV2 dateFromString:dhohur];
        [self setAlarm:date:@"The time for Dhohur Prayer has begun"];
        
        // set up maghrib alarm
        NSString *maghrib = [NSString stringWithFormat:@"%@ %@", [result maghrib], dateString];
        date = [dateFormatV2 dateFromString:maghrib];
        [self setAlarm:date:@"The time for Maghrib Prayer has begun"];
        
        // set up isha alarm
        NSString *isha = [NSString stringWithFormat:@"%@ %@", [result isha], dateString];
        date = [dateFormatV2 dateFromString:isha];
        [self setAlarm:date:@"The time for Ishaa Prayer has begun"];
        
        //now lets set up the iqama times
        
        
        [dateFormat release];        
        
    }
}

-(void) startIqamaAlarms
{
    // alarms will be started for the currentdate + the next 5 days
    if ([settingsData getIqamaNotificationFromPlist] == NO)
        return;
    
    for (int i=0;i<5;i++)
    {
        // two things need to be done
        // 1) get the date based on our iteration value
        // get the times from the sqlite prayer database
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:i];
        NSDate *tempDate = [gregorian dateByAddingComponents:comps toDate:currentDateInP_ options:0];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMMM d, yyyy"];
        NSString *dateString = [dateFormat stringFromDate:tempDate];
        
        // now lets get the row of data from the sqlite database
        NSDateComponents *components = [gregorian components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:tempDate];
        NSInteger day = [components day];    
        NSInteger month = [components month];
        NSInteger year = [components year];   
        NSString *dayStr = [NSString stringWithFormat:@"%d", day];    
        NSString *yearStr = [NSString stringWithFormat:@"%d", year];
        DailyPrayerTimes *result = [[DailyPrayerTimes alloc] init];        
        [result getIqamaRowFromDatabase:[self convertMonthToString:month]:dayStr:yearStr:result];

        // set up asr alarm
        NSString *asrTime = [[NSString alloc] init];
        asrTime = [result asr];
        asrTime = [asrTime stringByAppendingString:@" "];
        asrTime = [asrTime stringByAppendingString:dateString];
        
        NSDateFormatter *dateFormatV2 = [[NSDateFormatter alloc] init];
        [dateFormatV2 setDateFormat:@"h:mm a MMMM d, yyyy"];
        NSDate *date = [dateFormatV2 dateFromString:asrTime];
        [self setAlarm:date:@"Asr Prayer at ICBR is about to begin"];
        
        // set up fajr alarm
        NSString *fajrTime = [NSString stringWithFormat:@"%@ %@", [result fajr], dateString];
        date = [dateFormatV2 dateFromString:fajrTime];
        [self setAlarm:date:@"Fajr Prayer at ICBR is about to begin"];
        
        // set up dhohur alarm
        NSString *dhohur = [NSString stringWithFormat:@"%@ %@", [result dhohur], dateString];
        date = [dateFormatV2 dateFromString:dhohur];
        [self setAlarm:date:@"Dhohur Prayer at ICBR is about to begin"];
        
        // set up maghrib alarm
        NSString *maghrib = [NSString stringWithFormat:@"%@ %@", [result maghrib], dateString];
        date = [dateFormatV2 dateFromString:maghrib];
        [self setAlarm:date:@"Maghrib Prayer at ICBR is about to begin"];
        
        // set up isha alarm
        NSString *isha = [NSString stringWithFormat:@"%@ %@", [result isha], dateString];
        date = [dateFormatV2 dateFromString:isha];
        [self setAlarm:date:@"Isha Prayer at ICBR is about to begin"];
        
        //now lets set up the iqama times
        
        [dateFormat release];                
    }
}

-(void) cancelAllNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
-(NSString *) convertMonthToString:(NSInteger)month
{
    if (month ==1)
        return @"January";
    else if (month ==2)
        return @"February";
    else if (month ==3)
        return @"March";
    else if (month ==4)
        return @"April";
    else if (month ==5)
        return @"May";
    else if (month ==6)
        return @"June";
    else if (month ==7)
        return @"July";
    else if (month ==8)
        return @"August";
    else if (month ==9)
        return @"September";
    else if (month ==10)
        return @"October";
    else if (month ==11)
        return @"November";
    else
        return @"December";
}

-(void)updateData
{
    atFajr_.text = atFajr_.text;
    atShurooq_.text = atShurooq_.text;;
    atDhohur_.text = atDhohur_.text;
    atAsr_.text = atAsr_.text;
    atMaghrib_.text = atMaghrib_.text;
    atIsha_.text = atIsha_.text;    
    jumaa_.text = jumaa_.text;
    
    iqJumaa_.text = iqJumaa_.text;
    iqFajr_.text = iqFajr_.text;
    iqDhohur_.text = iqDhohur_.text;
    iqAsr_.text = iqAsr_.text;
    iqIsha_.text =iqIsha_.text;    
    iqShurooq_.text = iqShurooq_.text;
    iqMaghrib_.text = iqMaghrib_.text;
    calendarDate_.text = calendarDate_.text;
}

-(void) updateMaghribIqamaTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSCharacterSet* characters = [NSCharacterSet characterSetWithCharactersInString:@" amp"];

    NSString *tmpMaghribTime = [atMaghrib_.text stringByTrimmingCharactersInSet:characters];
    
    [formatter setDateFormat:@"h:mm"];
    NSDate *athanMaghrib = [formatter dateFromString:tmpMaghribTime];
    [formatter release];
    NSTimeInterval newMaghribTim = 10*60;
    athanMaghrib = [athanMaghrib dateByAddingTimeInterval:newMaghribTim];
    
    NSDateFormatter *dateFormating = [[NSDateFormatter alloc] init];
    [dateFormating setDateFormat:@"hh:mm"];
    
    NSString *theTime = [dateFormating stringFromDate:athanMaghrib];
    theTime = [theTime substringWithRange:NSMakeRange(1, [theTime length]-1)];  
    theTime = [theTime stringByAppendingFormat:@" pm"];
    iqMaghrib_.text = theTime;

}

@end
