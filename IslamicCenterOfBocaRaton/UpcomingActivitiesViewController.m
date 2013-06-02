//
//  UpcomingActivitiesViewController.m
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 11/7/11.
//  Copyright (c) 2011 Siemens Enterprise. All rights reserved.
//

#import "UpcomingActivitiesViewController.h"
#import "WebViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation UpcomingActivitiesViewController
@synthesize tableView = tableView_;
@synthesize twitterData = twitterData_;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        listOfUrls_ = [[NSMutableArray alloc] init];
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setImage:[UIImage imageNamed:@"83-calendar.png"]];
        [tbi setTitle:@"Activities"];
        noTweetsPresent_ = YES;
        
        _hudView = [[UIView alloc] initWithFrame:CGRectMake(75, 155, 170, 170)];
        _hudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _hudView.clipsToBounds = YES;
        _hudView.layer.cornerRadius = 10.0;
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicatorView.frame = CGRectMake(65, 40, _activityIndicatorView.bounds.size.width, _activityIndicatorView.bounds.size.height);
        [_hudView addSubview:_activityIndicatorView];
        [_activityIndicatorView startAnimating];
        
        _captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
        _captionLabel.backgroundColor = [UIColor clearColor];
        _captionLabel.textColor = [UIColor whiteColor];
        _captionLabel.adjustsFontSizeToFitWidth = YES;
        _captionLabel.textAlignment = UITextAlignmentCenter;
        _captionLabel.text = @"Loading...";
        [_hudView addSubview:_captionLabel];
        
        [self.view addSubview:_hudView];


    }
    return self;
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
//    twitterData_ = [[JSONDataFetcher alloc] init];
//    [self.twitterData addObserver:self forKeyPath:@"loadingStatus" options:NSKeyValueObservingOptionNew context:NULL];
}

-(void)viewDidAppear:(BOOL)animated
{
    twitterData_ = [[JSONDataFetcher alloc] init];
    [self.twitterData addObserver:self forKeyPath:@"loadingStatus" options:NSKeyValueObservingOptionNew context:NULL];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if ([twitterData_.allTweets count] == 0)
        return 1;
    else
    {
        noTweetsPresent_ = NO;
        return [twitterData_.allTweets count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    //NSLog(@"all tweets is %@", localTweets_);
    if (noTweetsPresent_)
        cell.textLabel.text = @"No upcoming activities";
    else
    {
        NSDictionary *aTweet = [localTweets_ objectAtIndex:[indexPath row]];
        
        NSLog(@"index path is %@ and tweet is %@", indexPath, aTweet);
        
        cell.textLabel.text = [aTweet objectForKey:@"text"];
        // here we need to search for an url
        // lets split the string
        NSArray *lookForUrl = [[NSArray alloc] initWithArray:[cell.textLabel.text componentsSeparatedByString:@" "]];
        //NSLog(@"split strings is %@", lookForUrl);
        // now lets search for http://
        NSRange textRange;
        BOOL found = NO;
        for (int i= 0; i < [lookForUrl count]; i++)
        {
            textRange =[[lookForUrl objectAtIndex:i] rangeOfString:@"http://"];
            
            if(textRange.location != NSNotFound)
            {
                //Does contain the substring
                NSLog(@"the url is %@", [lookForUrl objectAtIndex:i]);
                [listOfUrls_ addObject:[lookForUrl objectAtIndex:i]];
                found = YES;
                break;
            }
        }
        if (found == NO)
            [listOfUrls_ addObject:@""];
        else
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.minimumScaleFactor = 0.5;
        cell.textLabel.numberOfLines = 4;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        cell.detailTextLabel.text = [aTweet objectForKey:@"from_user"];
        if (found)
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        NSURL *url = [NSURL URLWithString:[aTweet objectForKey:@"profile_image_url"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        cell.imageView.image = [UIImage imageWithData:data];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"cell data is%@", cell.textLabel.text);
    }
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
    if (noTweetsPresent_ == NO)
    {
        NSString *web = [listOfUrls_ objectAtIndex:indexPath.row];
        if ([web isEqualToString:@""])
            NSLog(@"No url to link to");
        else
        {
            WebViewController *detailedTweet = [[WebViewController alloc] initWithWebAddress:[listOfUrls_ objectAtIndex:indexPath.row]];
            NSLog(@"list of urls %@", listOfUrls_);
    
            NSLog(@"web address is %@", [listOfUrls_ objectAtIndex:indexPath.row]);
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailedTweet];
            UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss"
                                                                           style:UIBarButtonItemStylePlain target:self action:@selector(buttonPressed:)];
            detailedTweet.navigationItem.leftBarButtonItem = backButton;
            [self presentViewController:navController animated:YES completion:nil];
        }
    }
}

-(void)buttonPressed:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // data finished loading right here
    //NSLog(@"array is %@", twitterData_.allTweets);
    localTweets_ = [[NSArray alloc] initWithArray:twitterData_.allTweets];
    [_activityIndicatorView stopAnimating];
    [_hudView removeFromSuperview];

    [tableView_ reloadData];
}

@end
