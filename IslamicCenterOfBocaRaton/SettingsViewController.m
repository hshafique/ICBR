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
#define kSectionIqamaConfiguration 2
#define kSectionAthaanConfiguration 3

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kSectionAthaanNames || section == kSectionAthaanConfiguration)
        return 4;//[athaanNames_ count]+1;
    else if (section == kSectionIqamaConfiguration)
    {
        if (switch3_.on == YES)
            return 6;
        else
            return 6;
    }
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
    else if (indexPath.section == kSectionAthaanNames)
    {
        if (indexPath.row == [plistData_ getSoundTypeFromPlist])
        {
            self.currentIndexPath = [indexPath copy];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        NSString *cellValue = [athaanNames_ objectAtIndex:indexPath.row];        
        [[cell textLabel] setText:cellValue];
    }
    else if (indexPath.section == kSectionIqamaConfiguration)
    {
        // if the switch is on, display 4 athaan names plus switch in first row
        switch (indexPath.row) 
        {
            case(0): 
            {
                switch3_ = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
                [cell addSubview:switch3_];
                cell.accessoryView = switch3_;
                [(UISwitch *)cell.accessoryView setOn:[plistData_ getAthaanNotificationFromPlist]];   // Or NO, obviously!
                [(UISwitch *)cell.accessoryView addTarget:self action:@selector(mySelectorForIqamaConfiguration)forControlEvents:UIControlEventValueChanged];
                NSString *cellValue = [notificationArray_ objectAtIndex:indexPath.row];        
                [[cell textLabel] setText:cellValue];
                break;
            }
            case(1):
            case(2):
            case(3):
            case(4):
            {
                NSString *cellValue = [athaanNames_ objectAtIndex:indexPath.row-1];  
                cell.accessoryView = nil;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [[cell textLabel] setText:cellValue];
                break;
            }
            case(5):
            {
                sliderValue_ = nil;
                slider_ =  [[[UISlider alloc] initWithFrame:CGRectMake(174,12,80,23)] autorelease];
                slider_.maximumValue=20;
                slider_.minimumValue=1;
                [slider_ addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];

                [cell addSubview:slider_];
                cell.accessoryView = slider_;    
                
                NSString *cellValue = @"minutes before the iqama";   
                cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
                cell.textLabel.numberOfLines = 0;
                [[cell textLabel] setText:cellValue];
                
                sliderValue_ = [[[UILabel alloc] initWithFrame:CGRectMake( 7.0, 0.0, 140.0, 44.0 )] autorelease];
                sliderValue_.tag = 21;
                sliderValue_.font = [UIFont systemFontOfSize: 17.0];
                sliderValue_.textAlignment = UITextAlignmentLeft;
                sliderValue_.textColor = [UIColor blackColor];
                sliderValue_.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
                sliderValue_.backgroundColor = [UIColor clearColor];
                sliderValue_.text = @"1";
                [cell.contentView addSubview: sliderValue_];

                break;
            }
        }
    }
    else if (indexPath.section == kSectionIqamaConfiguration)
    {
        switch (indexPath.row) 
        {
            case(0): 
            {
                switch4_ = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
                [cell addSubview:switch4_];
                cell.accessoryView = switch4_;
                [(UISwitch *)cell.accessoryView setOn:[plistData_ getAthaanNotificationFromPlist]];   // Or NO, obviously!
                [(UISwitch *)cell.accessoryView addTarget:self action:@selector(mySelectorForAthaanConfiguration)forControlEvents:UIControlEventValueChanged];
                NSString *cellValue = [notificationArray_ objectAtIndex:indexPath.row];        
                [[cell textLabel] setText:cellValue];
                break;
            }
            case(1):
            case(2):
            case(3):
            case(4):
            {
                NSString *cellValue = [athaanNames_ objectAtIndex:indexPath.row-1];  
                cell.accessoryView = nil;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [[cell textLabel] setText:cellValue];
                break;
            }
        }

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
    return 4;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Activate Notifications";
    else if (section == 1)
        return @"Athaan Names";
    else if (section == 2)
        return @"Iqama Configuation";
    else
        return @"Athaan Configuration";
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kSectionIqamaConfiguration && indexPath.row ==5)
    {
        return 5;
    }
    else
        return 0;
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
    [pt release];
}

-(void)mySelectorForIqamaConfiguration
{
    if (switch1_.on == YES)
        NSLog(@"selector launched ON");
    else
    {
        NSLog(@"selector launched OFF");
        [sliderValue_ removeFromSuperview];
    }
    [plistData_ setAthaanNotificationInPlist:switch3_.on];
    [tableView_ reloadData];
}

- (void)sliderChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    int discreteValue = (NSInteger) (slider.value);
    NSLog(@"Slider value %f",slider.value);
    sliderValue_.text = [NSString stringWithFormat:@"%d", discreteValue];
}

-(void)mySelectorForAthaanConfiguration
{
    
}

@end
