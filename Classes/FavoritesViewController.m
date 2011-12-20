//
//  FavoritesViewController.m
//  28C3
//
//  Created by Philip Brechler on 11.12.11.
//  Copyright (c) 2011 Hoccer GmbH. All rights reserved.
//

#import "FavoritesViewController.h"
#import "EventDetailView.h"

@implementation FavoritesViewController

@synthesize favoritesArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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

    self.title = @"Favorites";

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"28c3_navbar"] forBarMetrics:UIBarMetricsDefault];
    }
    
    self.tableView.backgroundView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"28c3_background"]] autorelease];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [favoritesArray release];
    
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"favorites"];
    if (dataRepresentingSavedArray != nil)
    {
        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        if (oldSavedArray != nil)
            favoritesArray = [[NSMutableArray alloc] initWithArray:oldSavedArray];
        else
            favoritesArray = [[NSMutableArray alloc] init];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"realDate" ascending:TRUE];
    [favoritesArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [sortDescriptor release];
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.favoritesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Event *aEvent = [favoritesArray objectAtIndex:indexPath.row];
    
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
    
    cell.textLabel.text = aEvent.title;
    
    NSString *detailString = [NSString stringWithFormat:@"%@ - Time: %@ - Room: %@",aEvent.date,aEvent.start,aEvent.room];

	cell.textLabel.text = aEvent.title;
	cell.detailTextLabel.text = detailString;
	cell.imageView.image = trackColor;
	cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"28c3_tableview_arrow"]]autorelease];
    
    if ([aEvent.realDate compare:[NSDate date]] == NSOrderedAscending){
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    else {
        cell.textLabel.textColor = [UIColor lightGrayColor];
	}
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.000];
	cell.textLabel.font = [UIFont fontWithName:@"Courier-Bold" size:15];
	cell.detailTextLabel.font = [UIFont fontWithName:@"Courier" size:10];
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        
        [favoritesArray removeObjectAtIndex:indexPath.row];

        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:favoritesArray] forKey:@"favorites"];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(edvController == nil)
        edvController = [[EventDetailView alloc] initWithNibName:@"EventDetailView" bundle:[NSBundle mainBundle]];
	
	Event *aEvent = [favoritesArray objectAtIndex:indexPath.row];
	
    edvController.aEvent = aEvent;
    edvController.fromFavorites = YES;
	
	[self.navigationController pushViewController:edvController animated:YES];
}


@end
