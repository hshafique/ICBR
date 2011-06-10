//
//  SettingsViewController.m
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 4/3/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import "SettingsViewController.h"
#import "PlistReaderWriter.h"
#import "ValidateLocationRequest.h"
#import "DailyPrayerTimes.h"

#define kSectionAthaanNames 0
#define kSectionAlarm 1

@implementation SettingsViewController
@synthesize currentIndexPath = currentIndexPath_;
@synthesize toggleStatus = toggleStatus_;

-(id)init
{
    notificationArray_ = [[NSArray alloc] initWithObjects:@"activate athaan alarm", @"activate iqama alarm", nil];
    athaanNames_ = [[NSArray alloc] initWithObjects:@"Yusuf Islam Azan", @"Makkah Azan", @"Madina Azan", @"Bird Sound", nil];

    currentIndexPath_ = [[NSIndexPath alloc] initWithIndex:-1];
    UITabBarItem *tbi = [self tabBarItem];
    //[tbi setTitle:@"Settings"];
    [tbi setImage:[UIImage imageNamed:@"Settings.png"]];

    plistData_ = [[PlistReaderWriter alloc] init];
    toggleStatus_ = [[NSString alloc] init];
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
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
    // Do any additional setup after loading the view from its nib.
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kSectionAthaanNames)
        return [athaanNames_ count];
    else
        return [notificationArray_ count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...

    if (indexPath.section == kSectionAlarm)
    {
        NSString *cellValue = [notificationArray_ objectAtIndex:indexPath.row];        

        switch (indexPath.row) 
        {
            case(0): 
            {
                switch1_ = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
                [cell addSubview:switch1_];
                cell.accessoryView = switch1_;
                [(UISwitch *)cell.accessoryView setOn:[plistData_ getAthaanNotificationFromPlist]];   // Or NO, obviously!
                [(UISwitch *)cell.accessoryView addTarget:self action:@selector(mySelectorForAthaan)forControlEvents:UIControlEventValueChanged];
                break;
            }
            case(1): 
            {
                switch2_ = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
                [cell addSubview:switch2_];
                cell.accessoryView = switch2_;
                [(UISwitch *)cell.accessoryView setOn:[plistData_ getIqamaNotificationFromPlist]];   // Or NO, obviously!
                [(UISwitch *)cell.accessoryView addTarget:self action:@selector(mySelectorForIqama)forControlEvents:UIControlEventValueChanged];
                break;
            }  
        }                
        [[cell textLabel] setText:cellValue];
    }
    else
    {
        if (indexPath.row == [plistData_ getSoundTypeFromPlist])
        {
            self.currentIndexPath = [indexPath copy];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        NSString *cellValue = [athaanNames_ objectAtIndex:indexPath.row];        
        [[cell textLabel] setText:cellValue];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.section == kSectionAthaanNames && indexPath.row != currentIndexPath_.row)
    {
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:
                                             indexPath];

        if (selectedCell.accessoryType == UITableViewCellAccessoryNone) 
        {
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else 
        {
            selectedCell.accessoryType = UITableViewCellAccessoryNone;
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:
                                         currentIndexPath_];
        oldCell.accessoryType = UITableViewCellAccessoryNone;

        NSLog(@"current selected row = %d", indexPath.row);
        [plistData_ setSoundTypeInPlist:indexPath.row];
        self.currentIndexPath = [indexPath copy];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1)
        return @"Activate Notifications";
    else 
        return @"Athaan Names";
}

-(void)mySelectorForAthaan
{
    [plistData_ setAthaanNotificationInPlist:switch1_.on];
    if (switch1_.on == YES)
        NSLog(@"selector launched ON");
    else
        NSLog(@"selector launched OFF");
    self.toggleStatus = @"DONE";
}

-(void)mySelectorForIqama
{
    [plistData_ setIqamaNotificationInPlist:switch2_.on];
    if (switch1_.on == YES)
        NSLog(@"selector launched ON");
    else
        NSLog(@"selector launched OFF");
    self.toggleStatus = @"DONE";
    DailyPrayerTimes *pt = [[DailyPrayerTimes alloc] init];
    [pt removePrayerTable];
}

@end
