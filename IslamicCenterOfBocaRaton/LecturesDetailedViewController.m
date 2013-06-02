//
//  LecturesDetailedViewController.m
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 9/13/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import "LecturesDetailedViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation LecturesDetailedViewController

@synthesize tableView = tableView_;
@synthesize listOfLectures = listOfLectures_;
@synthesize audioPlayer = audioPlayer_;
@synthesize imageView = imageView_;
@synthesize delegate = delegate_;


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
    
    NSString *rowData = [listOfLectures_ objectAtIndex:0];
    NSArray *splitData = [rowData componentsSeparatedByString:@","];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: [splitData objectAtIndex:5]]]];
    
    NSLog(@"image name is %@", [splitData objectAtIndex:5]);
    [imageView_ setImage:image];

    navigationBar_ = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 30.0f)];
    
    /*UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" 
                                                                    style:UIBarButtonSystemItemDone target:self action:@selector(buttonPressed:)];
    */
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Return to List of Lecturers"];
    //item.rightBarButtonItem = rightButton;
    item.hidesBackButton = NO;
    UIBarButtonItem *left =   [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonPressed:)];
    item.leftBarButtonItem = left;
    [navigationBar_ pushNavigationItem:item animated:NO];
    //[navigationBar_ pushNavigationItem:left animated:NO];
    [left release];
    
    [item release];
    
    [self.view addSubview: navigationBar_];    


    // Do any additional setup after loading the view from its nib.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listOfLectures_ count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    // to populate each row, we first get the correct row from the listoflectures
    // array, then we extract the data from this array to fill in the row
    
    NSString *rowData = [listOfLectures_ objectAtIndex:indexPath.row];
    NSArray *splitData = [rowData componentsSeparatedByString:@","];
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *cellValue = [splitData objectAtIndex:2];
    [[cell textLabel] setText:cellValue];
    
    [[cell detailTextLabel] setText:[splitData objectAtIndex:4]];
    
    cell.textLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"List of Lectures";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{

    NSString *rowData = [listOfLectures_ objectAtIndex:indexPath.row];
    NSArray *splitData = [rowData componentsSeparatedByString:@","];
    NSString *url = [splitData objectAtIndex:3];
    NSLog(@"NSARRAY is %@ and url is %@", splitData, url);
    
    moviePlayer = [[MPMoviePlayerController alloc]
                                            initWithContentURL:[NSURL URLWithString:url]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(moviePlaybackDidFinish:) 
                                                 name:MPMoviePlayerPlaybackDidFinishNotification 
                                               object:moviePlayer];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:moviePlayer.view];
    [moviePlayer setFullscreen:YES animated:YES];

    [moviePlayer play];
}

-(IBAction) buttonPressed:(id)sender
{
    [[self delegate] removeDetailViewController];
}

-(void)moviePlaybackDidFinish:(NSNotification*)notification
{ 
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer] ; 
    
    moviePlayer.initialPlaybackTime = -1; 
    
    [moviePlayer stop]; 
    [moviePlayer release]; 
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];

}

@end
