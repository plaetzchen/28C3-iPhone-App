//
//  RootViewController.m
//  27C3
//
//  Created by Philip Brechler on 08.12.10.
//  Copyright 2010 TimeCoast Communications. All rights reserved.
//

#import "RootViewController.h"
#import "28C3AppDelegate.h"
#import "Event.h"
#import "EventDetailView.h"

@implementation RootViewController

@synthesize firstDayArray,secondDayArray,thirdDayArray,fourthDayArray,firstDayAfterMidnightArray,secondDayAfterMidnightArray,thirdDayAfterMidnightArray,fourthDayAfterMidnightArray;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
		
	appDelegate = (Fahrplan28C3AppDelegate *)[[UIApplication sharedApplication] delegate];
	self.title = @"Fahrplan";
    
    self.firstDayArray = [NSMutableArray arrayWithCapacity:20];
	self.secondDayArray = [NSMutableArray arrayWithCapacity:20];
	self.thirdDayArray = [NSMutableArray arrayWithCapacity:20];
	self.fourthDayArray = [NSMutableArray arrayWithCapacity:20];
    self.firstDayAfterMidnightArray = [NSMutableArray arrayWithCapacity:20];
	self.secondDayAfterMidnightArray = [NSMutableArray arrayWithCapacity:20];
	self.thirdDayAfterMidnightArray = [NSMutableArray arrayWithCapacity:20];
	self.fourthDayAfterMidnightArray = [NSMutableArray arrayWithCapacity:20];
    
    searchAllEvents = [[NSMutableArray alloc]init];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadTheXML)] autorelease];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recieveXMLNotification:) 
                                                 name:@"xmlParsed"
                                               object:nil];
    
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	loadingIndicator.center = CGPointMake(160, 200);
	loadingIndicator.hidesWhenStopped = YES;

    [self.view addSubview:loadingIndicator];
    [loadingIndicator startAnimating];
    
    self.tableView.tableHeaderView = searchBar;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.tintColor = [UIColor blackColor];
    searchBar.backgroundImage = [UIImage imageNamed:@"28c3_navbar"];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"28c3_navbar"] forBarMetrics:UIBarMetricsDefault];
    
    self.tableView.backgroundView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"28c3_background"]] autorelease];
    
    searching = NO;
    letUserSelectRow = YES;
}


- (void) recieveXMLNotification:(NSNotification *) notification
{

    
    if ([[notification name] isEqualToString:@"xmlParsed"]) {
        [loadingIndicator stopAnimating];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        self.navigationItem.rightBarButtonItem.action = @selector(reloadTheXML);
        [self organizeTheData];
    }
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0)
	{
		exit(0);
	}
	
}

- (void)reloadTheXML {
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    self.navigationItem.rightBarButtonItem.action = nil;
    [firstDayArray removeAllObjects];
    [secondDayArray removeAllObjects];
    [thirdDayArray removeAllObjects];
    [fourthDayArray removeAllObjects];
    [firstDayAfterMidnightArray removeAllObjects];
    [secondDayAfterMidnightArray removeAllObjects];
    [thirdDayAfterMidnightArray removeAllObjects];
    [fourthDayAfterMidnightArray removeAllObjects];
    [self.tableView reloadData];
    [loadingIndicator startAnimating];
    [appDelegate loadXML];
}

-(void)organizeTheData{

    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *firstDay = [df dateFromString:@"2011-12-27"];
    NSDate *secondDay = [df dateFromString:@"2011-12-28"];
    NSDate *thirdDay = [df dateFromString:@"2011-12-29"];
    NSDate *fourthDay = [df dateFromString:@"2011-12-30"];
    
    [df release];
	
	for (int i = 0; i<[appDelegate.events count]; i++) {
		Event *aEvent = [appDelegate.events objectAtIndex:i];

        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:aEvent.startDate];
        NSInteger hour = [components hour];
	
		if ([self isSameDay:firstDay to:aEvent.startDate] && hour > 8){
			[self.firstDayArray addObject:aEvent];
		}
		else if ([self isSameDay:secondDay to:aEvent.startDate] && hour > 8){
			[self.secondDayArray addObject:aEvent];
		}	
		else if ([self isSameDay:thirdDay to:aEvent.startDate] && hour > 8){
			[self.thirdDayArray addObject:aEvent];
		}		
		else if ([self isSameDay:fourthDay to:aEvent.startDate] && hour > 8){
			[self.fourthDayArray addObject:aEvent];
		}
        
		if ([self isSameDay:firstDay to:aEvent.startDate] && hour < 8){
			[self.firstDayAfterMidnightArray addObject:aEvent];
		}
		else if ([self isSameDay:secondDay to:aEvent.startDate] && hour < 8){
			[self.secondDayAfterMidnightArray addObject:aEvent];
		}	
		else if ([self isSameDay:thirdDay to:aEvent.startDate] && hour < 8){
			[self.thirdDayAfterMidnightArray addObject:aEvent];
		}		
		else if ([self isSameDay:fourthDay to:aEvent.startDate] && hour < 8){
			[self.fourthDayAfterMidnightArray addObject:aEvent];
		}
		
	}
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:TRUE];
    [firstDayArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [secondDayArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [thirdDayArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [fourthDayArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [firstDayAfterMidnightArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [secondDayAfterMidnightArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [thirdDayAfterMidnightArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [fourthDayAfterMidnightArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [sortDescriptor release];
    
    [firstDayArray addObjectsFromArray:firstDayAfterMidnightArray];
    [secondDayArray addObjectsFromArray:secondDayAfterMidnightArray];
    [thirdDayArray addObjectsFromArray:thirdDayAfterMidnightArray];
    [fourthDayArray addObjectsFromArray:fourthDayAfterMidnightArray];
    
    [self.tableView reloadData];
}


- (BOOL)isSameDay:(NSDate*)date1 to:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (searching)
        return 1;
    if (self.firstDayArray.count > 0)
        return 4;
    else 
        return 0;
          
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
    if (searching){
        return @"";
    }
    else {
        switch (section) {
            case 0:
                return @"Tuesday";
                break;
            case 1:
                return @"Wednesday";
                break;
            case 2:
                return @"Thurdsay";
                break;
            case 3:
                return @"Friday";
                break;
        }
        return @"";
    }
}

#define SectionHeaderHeight 28


- (CGFloat)tableView:(UITableView *)theTableView heightForHeaderInSection:(NSInteger)section {
    if ([self tableView:theTableView titleForHeaderInSection:section] != nil) {
        return SectionHeaderHeight;
    }
    else {
        // If no section header title, no section header needed
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)theTableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:theTableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
	
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(0, 0, 320, 20);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:0.577 green:0.409 blue:0.065 alpha:1.000];
	label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica" size:14];;
    label.text = sectionTitle;
	
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SectionHeaderHeight)];
    UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, SectionHeaderHeight)];
    backgroundImage.image = [UIImage imageNamed:@"28c3_sectionheader"];
    
    [view autorelease];
    [view addSubview:backgroundImage];
    [view addSubview:label];
    return view;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (searching){
        return [searchAllEvents count];
    }
    else {
        switch (section) {
            case 0:
                return [self.firstDayArray count];
                break;
            case 1:
                return [self.secondDayArray count];
                break;
            case 2:
                return [self.thirdDayArray count];
                break;
            case 3:
                return [self.fourthDayArray count];
                break;
        }
        return 0;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	Event *aEvent;
    if (searching) {
        aEvent = [searchAllEvents objectAtIndex:indexPath.row];
    }
    else {
        switch (indexPath.section) {
            case 0:
                aEvent = [self.firstDayArray objectAtIndex:indexPath.row];
                break;
            case 1:
                aEvent = [self.secondDayArray objectAtIndex:indexPath.row];
                break;
            case 2:
                aEvent = [self.thirdDayArray objectAtIndex:indexPath.row];
                break;
            case 3:
                aEvent = [self.fourthDayArray objectAtIndex:indexPath.row];
                break;
            default:
                return nil;
                
        }
    }
	UIImage *trackColor = [UIImage imageNamed:@"community.png"];
	if ([aEvent.track isEqualToString:@"Culture"]){
		trackColor = [UIImage imageNamed:@"culture.png"];
	}
	else if ([aEvent.track isEqualToString:@"Society and Politics"]){
		trackColor = [UIImage imageNamed:@"society.png"];
	}
	else if ([aEvent.track isEqualToString:@"Hacking"]){
		trackColor = [UIImage imageNamed:@"hacking.png"];
	}
	else if ([aEvent.track isEqualToString:@"Show"]){
		trackColor = [UIImage imageNamed:@"show.png"];
	}
	else if ([aEvent.track isEqualToString:@"Science"]){
		trackColor = [UIImage imageNamed:@"science.png"];
	}
	
	
	
	NSString *detailString;
    if (searching) {
        detailString = [NSString stringWithFormat:@"%@ - Time: %@ - Room: %@",aEvent.date,aEvent.start,aEvent.room];
    }
    else{
        detailString = [NSString stringWithFormat:@"Time: %@ - Room: %@",aEvent.start,aEvent.room];
    }
	cell.textLabel.text = aEvent.title;
	cell.detailTextLabel.text = detailString;
	cell.imageView.image = trackColor;
	cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"28c3_tableview_arrow"]]autorelease];
	cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.000];
	cell.textLabel.textColor = [UIColor lightGrayColor];
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	cell.textLabel.font = [UIFont fontWithName:@"Courier-Bold" size:15];
	cell.detailTextLabel.font = [UIFont fontWithName:@"Courier" size:10];
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(letUserSelectRow)
        return indexPath;
    else
        return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(edvController == nil)
		edvController = [[EventDetailView alloc] initWithNibName:@"EventDetailView" bundle:[NSBundle mainBundle]];
	
	Event *aEvent;
	
    if (searching){
        aEvent = [searchAllEvents objectAtIndex:indexPath.row];
    }
    else {
        switch (indexPath.section) {
            case 0:
                aEvent = [self.firstDayArray objectAtIndex:indexPath.row];
                break;
            case 1:
                aEvent = [self.secondDayArray objectAtIndex:indexPath.row];
                break;
            case 2:
                aEvent = [self.thirdDayArray objectAtIndex:indexPath.row];
                break;
            case 3:
                aEvent = [self.fourthDayArray objectAtIndex:indexPath.row];
                break;
            default:
                aEvent = nil;
                
        }
	}
	edvController.aEvent = aEvent;
	edvController.fromFavorites = NO;
    
	[self.navigationController pushViewController:edvController animated:YES];
}

#pragma mark -
#pragma mark UISearchBar Stuff

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    
    searching = YES;
    letUserSelectRow = NO;
    self.tableView.scrollEnabled = NO;
    
    //Add the done button.
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                               target:self action:@selector(doneSearching_Clicked:)] autorelease];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
    //Remove all objects first.
    [searchAllEvents removeAllObjects];
    
    if([searchText length] > 0) {
        
        searching = YES;
        letUserSelectRow = YES;
        self.tableView.scrollEnabled = YES;
        [self searchTableView];
    }
    else {
        
        searching = NO;
        letUserSelectRow = NO;
        self.tableView.scrollEnabled = NO;
    }
    
    [self.tableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    
    [self searchTableView];
}

- (void) searchTableView {
    
    NSString *searchText = searchBar.text;
    
    for (Event *aEvent in appDelegate.events)
    {
        NSRange titleResultsRange = [aEvent.title rangeOfString:searchText options:NSCaseInsensitiveSearch];
        NSRange subtitleResultsRange = [aEvent.subtitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
        NSRange abstractResultsRange = [aEvent.abstract rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (titleResultsRange.length > 0 || subtitleResultsRange.length >0 || abstractResultsRange.length > 0)
            [searchAllEvents addObject:aEvent];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"realDate" ascending:TRUE];
    [searchAllEvents sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [sortDescriptor release];

}

- (void) doneSearching_Clicked:(id)sender {
    
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    
    letUserSelectRow = YES;
    searching = NO;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadTheXML)] autorelease];
    self.tableView.scrollEnabled = YES;
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[firstDayArray release];
	[secondDayArray release];
	[thirdDayArray release];
	[fourthDayArray release];
    [firstDayAfterMidnightArray release];
	[secondDayAfterMidnightArray release];
	[thirdDayAfterMidnightArray release];
	[fourthDayAfterMidnightArray release];
	[appDelegate release];
    [super dealloc];
}


@end

