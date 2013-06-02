//
//  AdvancedSettingsViewController.m
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 6/12/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import "AdvancedSettingsViewController.h"


@implementation AdvancedSettingsViewController
@synthesize currentIndexPathForAthaan = currentIndexPathForAthaan_;
@synthesize currentIndexPathForIqama = currentIndexPathForIqama_;
@synthesize tableView = tableView_;
@synthesize toggleStatus = toggleStatus_;
@synthesize audioPlayer = audioPlayer_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }

    numberOfIqamaRows_ = 1;
    numberOfAthaanRows_ = 1;
    plistData_ = [[PlistReaderWriter alloc] init];

    if ([plistData_ getAthaanNotificationFromPlist])
        numberOfAthaanRows_ = 5;
    if ([plistData_ getIqamaNotificationFromPlist])
        numberOfIqamaRows_ = 6;
    iqamaString_ = [[NSMutableString alloc] initWithFormat:@"Alarm will start %d minutes before the ICBR iqama", [plistData_ getIqamaAdvanceTimeFromPlist]];
    toggleStatus_ = [[NSString alloc] init];

    athaanNames_ = [[NSArray alloc] initWithObjects:@"madinah.caf", @"makkah.caf", @"yusuf.caf", @"bird.caf", nil];

    UITabBarItem *tbi = [self tabBarItem];
    [tbi setImage:[UIImage imageNamed:@"19-gear.png"]];
    [tbi setTitle:@"Settings"];

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
    
    navigationBar_ = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 30.0f)];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" 
                                                                    style:UIBarButtonSystemItemDone target:self action:@selector(buttonPressed:)];
    //[rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Settings"];
    item.rightBarButtonItem = rightButton;
    item.hidesBackButton = YES;
    [navigationBar_ pushNavigationItem:item animated:NO];
    [rightButton release];
    [item release];
    
    [self.view addSubview: navigationBar_];    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return numberOfAthaanRows_;
    else
        return numberOfIqamaRows_;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }

    if (indexPath.row == 0)
    {
        if (indexPath.section == 0)
        {
            switch4_ = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
            [cell addSubview:switch4_];
            cell.accessoryView = switch4_;
            [(UISwitch *)cell.accessoryView setOn:[plistData_ getAthaanNotificationFromPlist]];   // Or NO, obviously!
            [(UISwitch *)cell.accessoryView addTarget:self action:@selector(mySelectorForAthaanConfiguration)forControlEvents:UIControlEventValueChanged];
            NSString *cellValue = @"Enable Athaan Alarms";        
            [[cell textLabel] setText:cellValue];
            
        }
        else
        {
            switch3_ = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
            [cell addSubview:switch3_];
            cell.accessoryView = switch3_;
            [(UISwitch *)cell.accessoryView setOn:[plistData_ getIqamaNotificationFromPlist]];   // Or NO, obviously!
            [(UISwitch *)cell.accessoryView addTarget:self action:@selector(mySelectorForIqamaConfiguration)forControlEvents:UIControlEventValueChanged];
            NSString *cellValue = @"Enable Iqama Alarms";        
            [[cell textLabel] setText:cellValue];
        }
    }
    else if (indexPath.row == 1)
    {
        cell.accessoryView = nil;
        NSString *cellValue = @"Yusuf Islam Azan";
        [[cell textLabel] setText:cellValue];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 2)
    {
        cell.accessoryView = nil;
        NSString *cellValue = @"Makkah Azan";
        [[cell textLabel] setText:cellValue];    
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 3)
    {
        cell.accessoryView = nil;
        NSString *cellValue = @"Madina Azan";
        [[cell textLabel] setText:cellValue];        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 4)
    {
        cell.accessoryView = nil;
        NSString *cellValue = @"Bird Sound";
        [[cell textLabel] setText:cellValue];      
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if ((indexPath.section == 1) && (indexPath.row == 5))
    {
        slider_ =  [[[UISlider alloc] initWithFrame:CGRectMake(174,12,80,23)] autorelease];
        slider_.maximumValue=20;
        slider_.minimumValue=0;
        slider_.value = [plistData_ getIqamaAdvanceTimeFromPlist];
        [cell addSubview:slider_];
        cell.accessoryView = slider_;
        [(UISlider *)cell.accessoryView addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        [[cell textLabel] setText:iqamaString_]; 
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
    }

    if (indexPath.row == ([plistData_ getSoundTypeFromPlist]+1) && indexPath.section == 0)
    {
        self.currentIndexPathForAthaan = [indexPath copy];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSLog(@"tracing check mark %d", [plistData_ getSoundTypeFromPlist]+1);
    }
    else if (indexPath.row == ([plistData_ getIqamaSoundTypeFromPlist]+1) && indexPath.section == 1)
    {
        self.currentIndexPathForIqama = [indexPath copy];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSLog(@"tracing check mark section 2 %d", [plistData_ getSoundTypeFromPlist]+1);

    }

    cell.textLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Athaan Configuration";
    else
        return @"Iqama Configuration";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.row > 0 && indexPath.row < 5)
    {
    if (indexPath.row != 0 && indexPath.section == 0 && indexPath.row != currentIndexPathForAthaan_.row)
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
                                    currentIndexPathForAthaan_];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        NSLog(@"current selected row = %d", indexPath.row);
        [plistData_ setSoundTypeInPlist:indexPath.row - 1];
        self.currentIndexPathForAthaan = [indexPath copy];
    }
    else if (indexPath.row != 0 && indexPath.section == 1 && indexPath.row != currentIndexPathForIqama_.row)
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
                                    currentIndexPathForIqama_];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        NSLog(@"current selected row = %d", indexPath.row);
        [plistData_ setIqamaSoundTypeFromPlist:indexPath.row - 1];
        self.currentIndexPathForIqama = [indexPath copy];
    }
        [self playAthaanSound:indexPath.row-1];

    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ((indexPath.section == 1) && (indexPath.row == 5))
    {
        UIFont *cellFont = [UIFont fontWithName:@"Arial-BoldMT" size:14];
        CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
        CGSize labelSize = [iqamaString_ sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        return labelSize.height + 20;
    }
    else
    {
        NSString *cellText = @"Enable Iqama Alarms";
        UIFont *cellFont = [UIFont fontWithName:@"Arial-BoldMT" size:14];
        CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        return labelSize.height + 20;
    }
}

-(void)mySelectorForIqamaConfiguration
{
    NSLog(@"into click");
    [plistData_ setIqamaNotificationInPlist:switch3_.on];
    if (switch3_.on == YES)
    {
        NSLog(@"selector launched ON");
        numberOfIqamaRows_ = 6;
    }
    else
    {
        NSLog(@"selector launched OFF");
        numberOfIqamaRows_ = 1;
    }
    [tableView_ reloadData];
}

-(void)mySelectorForAthaanConfiguration
{
    NSLog(@"into click for athaan");
    [plistData_ setAthaanNotificationInPlist:switch4_.on];
    if (switch4_.on == YES)
    {
        NSLog(@"selector launched ON");
        numberOfAthaanRows_ = 5;
    }
    else
    {
        NSLog(@"selector launched OFF");
        numberOfAthaanRows_ = 1;
    }
    [tableView_ reloadData];
}

-(void)sliderValueChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    NSLog(@"Slider value %f",slider.value);
    int currentSliderValue = (NSInteger) (slider.value);

    NSString *tmpString = [[NSString alloc] initWithFormat:@"Alarm will start %d minutes before the ICBR iqama", currentSliderValue];
    [iqamaString_ setString:tmpString]; 
    [plistData_ setIqamaAdvanceTimeFromPlist:currentSliderValue];
    [tableView_ reloadData];
}

-(void) buttonPressed:(id)sender
{
    NSLog(@"pressed save!!!");

    self.toggleStatus = @"DONE";
}

-(void) playAthaanSound:(NSInteger)athaanIndex
{
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],[athaanNames_ objectAtIndex:athaanIndex]]];
    
	NSError *error;
	AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.audioPlayer = newPlayer;
    [newPlayer release];

	self.audioPlayer.numberOfLoops = 0;
    [self.audioPlayer play];
}
@end
