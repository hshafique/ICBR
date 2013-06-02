//
//  ICBRImageScrollViewController.m
//  IslamicCenterOfBocaRaton
//
//  Created by Hashim Shafique on 4/4/11.
//  Copyright 2011 Siemens Enterprise. All rights reserved.
//

#import "ICBRImageScrollViewController.h"
#import "ICBRImagesViewController.h"
#import "ICBRImages.h"

@interface ICBRImageScrollViewController (PrivateMethods)

- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end


@implementation ICBRImageScrollViewController
@synthesize scrollView = scrollView_;
@synthesize viewControllers = viewControllers_;
@synthesize imageList = imageList_;

-(id) init
{
    UITabBarItem *tbi = [self tabBarItem];
    //[tbi setTitle:@"Pictures"];
    [tbi setImage:[UIImage imageNamed:@"Upcoming Activities and Pictures.png"]];
    CGRect myImageRect = CGRectMake(0, 380, 320, 20);
    pageControl_ = [[UIPageControl alloc] initWithFrame:myImageRect]; // set in header
    
    imageList_ = [[ICBRImages alloc] init];
    numberOfPages_ = [imageList_.imageList count];
    [pageControl_ setNumberOfPages:numberOfPages_];
    [pageControl_ setCurrentPage:0];
    [pageControl_ setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:pageControl_];

    return self;
}

- (id)initWithNibName: (NSString *) bundle: (NSBundle *) nibBundleOrNil
{
    self = [super initWithNibName:@"ICBRImageScrollViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [pageControl_ release];
    [imageList_ release];
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
	
	// view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < numberOfPages_; i++) {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    [controllers release];
	
    // a page is the width of the scroll view
    scrollView_.pagingEnabled = YES;
    scrollView_.contentSize = CGSizeMake(scrollView_.frame.size.width * numberOfPages_, scrollView_.frame.size.height);
    scrollView_.showsHorizontalScrollIndicator = NO;
    scrollView_.showsVerticalScrollIndicator = NO;
    scrollView_.scrollsToTop = NO;
    scrollView_.delegate = self;
	
    pageControl_.numberOfPages = numberOfPages_;
    pageControl_.currentPage = 0;
    [pageControl_ setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:pageControl_];
	
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (IBAction)changePage:(id)sender {
    int page = pageControl_.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView_.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView_ scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= numberOfPages_) return;
	
    // replace the placeholder if necessary
    ICBRImagesViewController *controller = [viewControllers_ objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
        controller = [[ICBRImagesViewController alloc] init];
        [controller setPageNumber:page];
        [viewControllers_ replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
	
    // add the controller's view to the scroll view
    if (nil == controller.view.superview) {
        CGRect frame = scrollView_.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView_ addSubview:controller.view];
        if (objectDidEnterForeground)
        {
            [controller reloadData];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView_.frame.size.width;
    int page = floor((scrollView_.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl_.currentPage = page;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

-(void)reloadImages
{
    objectDidEnterForeground = YES;
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < numberOfPages_; i++) {
        [controllers addObject:[NSNull null]];
    }
    
    self.viewControllers = controllers;
    [controllers release];
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];

}
@end
