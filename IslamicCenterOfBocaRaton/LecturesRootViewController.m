//
//  LecturesRootViewController.m
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 8/31/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

// This module will be used to do the following
// Step 1: go to icbr.org/lectures.txt. This file will be read and parsed
// Step 2: a table view will be used to populate the following data
//         - picture of lecturer
//         - name of lecturer
//         - number of lectures that have been parsed
//         - upon clicking on this row, a new module view controller is opened with a 
//           new table

// format of lectures.txt will be as follows:
// 1,Sheikh Mokhtar Magrawi,Lessons on Ramadhaan,http://www.icbr.org/lecture1.wav,
// 44 minutes,mokhtar1.jpg

#import "LecturesRootViewController.h"
#import "LectureData.h"
#import "LecturesDetailedViewController.h"


@implementation LecturesRootViewController
@synthesize tableView = tableView_;
@synthesize imageView = imageView_;
@synthesize lectureDetailsViewController = lectureDetailsViewController_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setImage:[UIImage imageNamed:@"66-microphone.png"]];
        [tbi setTitle:@"Lectures"];
        lectureData_ = [[LectureData alloc] init];
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

    UIImage *image = [UIImage imageNamed: @"home_1_04.jpg"];
    [imageView_ setImage:image];
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [lectureData_ getNumberOfLecturers];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSLog(@"table value is %@", [lectureData_ getLecturerNameForIndex:indexPath.row]);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *cellValue = [lectureData_ getLecturerNameForIndex:indexPath.row];
    [[cell textLabel] setText:cellValue];
    
    NSString *string1 = [NSString stringWithFormat:@"%d Audio Lectures",[lectureData_ getNumberOfLecturesForIndex:indexPath.row]];

    [[cell detailTextLabel] setText:string1];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: [lectureData_ getLecturerPictureForIndex:indexPath.row]]]];;
    NSLog(@"lecturer picture is %@", [lectureData_ getLecturerPictureForIndex:indexPath.row]);
    
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
    NSArray *lectures = [[NSArray alloc] initWithArray:[lectureData_ getLectureDataForIndex:indexPath.row]];
    lectureDetailsViewController_ = [[LecturesDetailedViewController alloc] init];
    [lectureDetailsViewController_ setDelegate:self];

    [lectureDetailsViewController_ setListOfLectures:lectures]; 

    [lectureDetailsViewController_ setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:self.lectureDetailsViewController animated:YES completion:nil];
    
    [lectures release];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)removeDetailViewController
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [lectureDetailsViewController_ release];
}

@end
