//
//  POIDetailsViewController.m
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 4/24/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import "POIDetailsViewController.h"


@implementation POIDetailsViewController
@synthesize navigationBar = navigationBar_;
@synthesize delegate = delegate_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    nameOfBusness_ = [[NSArray alloc] initWithObjects:@"Islamic Center of Boca Raton", @"Airlink Tours and Travel", @"West Palm Beach Masjid", @"Pompano Masjid", @"Islamic Center of South Florida", @"Islamic Center of Broward", @"Masjid Tawhid", @"Masjid Al Iman",@"Masjid Jamaat Al Mumineen", nil];
    typeOfBusiness_ = [[NSArray alloc] initWithObjects:@"Masjid", @"business", @"Masjid",@"Masjid", @"Masjid", @"Masjid", @"Masjid", @"Masjid", @"Masjid",nil];
    addressList_ = [[NSArray alloc] initWithObjects:@"3100 NW 5th Avenue, Boca Raton, FL 33431", @"123 NW 13th St., Boca Raton, FL 33432", @"4893 Purdy Lane, West Palm Beach, FL 33415", @"507 Ne 6th St, Pompano Beach, FL 33060",@"5457 NW 108th Ave, Fort Lauderdale, FL 33351, USA", @"8658 NW 44th ST, Fort Lauderdale, FL 33351, USA", @"1557 NW5th St, Fort Lauderdale, FL 33311, USA", @"2542 Franklin Park Drive, Fort Lauderdale, FL 33311, USA", @"3222 Holiday Springs Blvd. Margate, FL 33063, USA", nil];
    briefDescription_ = [[NSArray alloc] initWithObjects:@"The Islamic Center of Boca Raton consists of a Masjid and a fulltime Islamic School (Garden of the Sahaba Academy). ICBR offers daily lectures after Maghrib prayer, and a wide host of Social Activities, as well as other services. We strive our utmost to keep all of such activities grounded in and conducted according to the Quran and Sunnah, with strict attention given to avoiding any innovations", @"Local travel agency with Hajj and Umrah packages available", @"1:30pm-2:00 pm: Friday,Jumah prayer", @"All prayers 5 times/day Eid prayers ( more than 2000 attend ) Jumua Prayers ( around 200 attend) Weekend School to teach Arabic & culture Arabic for Adults Classes on Saturdays Qura'n Classes for new Muslims", @"open for all prayers each day. Juma Prayer services start at 1:30pm each Friday. A part-time school has been operating since 1993 for children of all ages Friday evenings 7:00 to 9:30pm . A fulltime school with classes from Pre K3 through Grade 8 has been open since 2000. The school times are 8am to 3pm. A Hifz program also runs fulltime at the masjid Monday through Friday after school. The Masjid hosts a Family Night Dinner with a guest speaker each last saturday of the month. For more information see www.ifsf.net", @"Masjid & Islamic School", @"1:30pm-2:30pm: Friday,Jummah,Congregational Pray",@"Mosque and Islamic Center",@"MASJID IS NOW OPEN FOR 5 TIMES DAILY SALAAT AT THE NEW PERMANENT LOCATION",nil];

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
    
    navigationBar_ = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 48.0f)];
        
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" 
                                                                    style:UIBarButtonSystemItemDone target:self action:@selector(buttonPressed:)];
    //[rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];

    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"General Information"];
    item.rightBarButtonItem = rightButton;
    item.hidesBackButton = YES;
    [navigationBar_ pushNavigationItem:item animated:NO];
    [rightButton release];
    [item release];
    
    [self.view addSubview: navigationBar_];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewDidAppear:(BOOL)animated
{
    [tableView_ reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) buttonPressed:(id)sender
{
    [[self delegate] removeDetailViewController];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    }
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = [nameOfBusness_ objectAtIndex:currentIndex_];
        return cell;
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = [typeOfBusiness_ objectAtIndex:currentIndex_];
        return cell;
    }
    else if (indexPath.section == 2)
    {
        cell.textLabel.text = [addressList_ objectAtIndex:currentIndex_];
        return cell;
    }
    else
    {
        cell.textLabel.text = [briefDescription_ objectAtIndex:currentIndex_];
        return cell;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Name of Organization";
    else  if (section == 1)
        return @"Type of Organization";
    else  if (section == 2)
        return @"Address";
    else
        return @"Brief Description";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *cellText = @"Go get some text for your cell.";
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize;
    if (indexPath.section == 0)
    {
        labelSize = [[nameOfBusness_ objectAtIndex:currentIndex_] sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    }
    else if (indexPath.section == 1)
    {
        labelSize = [[typeOfBusiness_ objectAtIndex:currentIndex_] sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    }
    else if (indexPath.section == 2)
    {
        labelSize = [[addressList_ objectAtIndex:currentIndex_] sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    }
    else
    {
        labelSize = [[briefDescription_ objectAtIndex:currentIndex_] sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    }

    return labelSize.height + 20;
}

-(void) setCurrentIndex:(int)value;
{
    currentIndex_ = value;
}
@end
