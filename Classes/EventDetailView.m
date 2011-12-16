//
//  EventDetailView.m
//  27C3
//
//  Created by Philip Brechler on 08.12.10.
//  Copyright 2010 TimeCoast Communications. All rights reserved.
//

#import "EventDetailView.h"
#import "Event.h"
#import <EventKit/EventKit.h>


@implementation EventDetailView

@synthesize aEvent,fromFavorites;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"Details";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"28c3_navbar"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonPressed:)] autorelease];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"28c3_background"]];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	NSString *theLanguage = @"unknown";
	
	abstractText.font = [UIFont fontWithName:@"Courier" size:15];
	abstractText.textColor = [UIColor whiteColor];
	
	titleLabel.text = aEvent.title;
	subtitleLabel.text = aEvent.subtitle;
	abstractText.text = ([aEvent.abstract length] > [aEvent.description length]) ? aEvent.abstract : aEvent.description;
	roomLabel.text = [@"Room: " stringByAppendingString:aEvent.room];
    trackLabel.text = [@"Track: " stringByAppendingString:aEvent.track];

	startLabel.text = [[@"Start: " stringByAppendingString:aEvent.start] stringByAppendingString:@"h"];
	durationLabel.text = [[@"Duration: " stringByAppendingString:aEvent.duration] stringByAppendingString:@"h"];
	idLabel.text = [@"Date: " stringByAppendingFormat:@"%@",aEvent.date];
	if ([aEvent.language isEqualToString:@"de"]){
		theLanguage = @"German";
	}
	else if ([aEvent.language isEqualToString:@"en"]) {
		theLanguage = @"English";
	}
				 
	languageLabel.text = [@"Language: " stringByAppendingString:theLanguage];

    CGRect frame = abstractText.frame;
    frame.size.height =  abstractText.contentSize.height;
    abstractText.frame = frame;
    abstractText.contentInset = UIEdgeInsetsZero;
    abstractText.contentOffset = CGPointMake(0, 0);
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, abstractText.frame.size.height+image.frame.size.height)];
}

- (void)viewDidAppear:(BOOL)animated {
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES]; 
}

-(IBAction)actionButtonPressed:(id)sender{
	UIActionSheet *actionSheet;
    
    if (!fromFavorites){
    
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"View in Web",@"Add to favorites",@"Add to calendar",nil];
    }
    else {
        if (aEvent.reminderSet){
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"View in Web",@"Remove reminder",@"Add to calendar",nil];
        }
        else {
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"View in Web",@"Set reminder",@"Add to calendar",nil];
        }
    }
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	actionSheet.tag=1;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet release];
	
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!fromFavorites) {
        switch (buttonIndex) {
            case 0:
                if(wvController == nil)
                    wvController = [[WebView alloc] initWithNibName:@"WebView" bundle:[NSBundle mainBundle]];
                
                NSString *theUrl = @"http://events.ccc.de/congress/2011/Fahrplan/events/";
                theUrl = [[theUrl stringByAppendingFormat:@"%i",aEvent.eventID] stringByAppendingString:@".en.html"];
                
                wvController.urlToOpen = theUrl;
                
                [self.navigationController pushViewController:wvController animated:YES];
                
                break;
            case 1: {
                NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
                NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"favorites"];
                NSMutableArray *favoritesArray;
                if (dataRepresentingSavedArray != nil)
                {
                    NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
                    if (oldSavedArray != nil)
                        favoritesArray = [[NSMutableArray alloc] initWithArray:oldSavedArray];
                    else
                        favoritesArray = [[NSMutableArray alloc] init];
                }
                else {
                    favoritesArray = [[NSMutableArray alloc] init];
                }
                
                BOOL isAlreadyFavorite = NO;
                BOOL favoriteAtSameTime = NO;
                NSArray *durationArray = [aEvent.duration componentsSeparatedByString:@":"];
                double hours = [[durationArray objectAtIndex:0] doubleValue] * 60 * 60;
                double minutes = [[durationArray objectAtIndex:1] doubleValue] * 60;

                for (Event *favoriteEvent in favoritesArray) {
                    if (favoriteEvent.eventID == aEvent.eventID){
                        isAlreadyFavorite = YES;
                    }
                    if ([self date:aEvent.realDate isBetweenDate:favoriteEvent.realDate andDate:[NSDate dateWithTimeInterval:hours+minutes sinceDate:favoriteEvent.realDate]]){
                        favoriteAtSameTime = YES;
                    }
                }
                if (!isAlreadyFavorite && ! favoriteAtSameTime)
                    [favoritesArray addObject:aEvent];
                
                if (favoriteAtSameTime && !isAlreadyFavorite) {
                    UIAlertView *sameTimeAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"You allready have a favorite at the same time, add it anyway?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes", @"No", nil];
                    [sameTimeAlert show];
                    sameTimeAlert.tag = 2;
                    [sameTimeAlert release];
                }
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:favoritesArray] forKey:@"favorites"];
                [favoritesArray release];
                break;
            }
        case 2: {
                EKEventStore *eventStore = [[EKEventStore alloc] init];
                
                EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                
                event.title = aEvent.title;
                [event addAlarm:[EKAlarm alarmWithRelativeOffset:-900]];
                event.notes = aEvent.abstract;
                event.location = aEvent.room;
                event.startDate = aEvent.realDate;
                NSArray *durationArray = [aEvent.duration componentsSeparatedByString:@":"];
                double hours = [[durationArray objectAtIndex:0] doubleValue] * 60 * 60;
                double minutes = [[durationArray objectAtIndex:1] doubleValue] * 60;
                event.endDate = [NSDate dateWithTimeInterval:hours+minutes sinceDate:event.startDate];
                
                [event setCalendar:[eventStore defaultCalendarForNewEvents]];

                NSError *err;
                [eventStore saveEvent:event span:EKSpanThisEvent error:&err]; 
                [eventStore release];
                if (!err){
                    UIAlertView *dateAlert = [[UIAlertView alloc]initWithTitle:@"Saved" message:@"The event was saved to your calendar" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [dateAlert show];
                    [dateAlert release];
                }
                break;
            }			
                
        }
    }
    else {
        switch (buttonIndex) {
            case 0:
                if(wvController == nil)
                    wvController = [[WebView alloc] initWithNibName:@"WebView" bundle:[NSBundle mainBundle]];
                
                NSString *theUrl = @"http://events.ccc.de/congress/2011/Fahrplan/events/";
                theUrl = [[theUrl stringByAppendingFormat:@"%i",aEvent.eventID] stringByAppendingString:@".en.html"];
                
                wvController.urlToOpen = theUrl;
                
                [self.navigationController pushViewController:wvController animated:YES];

                break;
                
            case 1:
                if (aEvent.reminderSet){
                    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]){
                        NSDictionary *userInfo = notification.userInfo;
                        NSNumber *version =  [userInfo objectForKey:@"28C3Reminder"];
                        if ([version isEqualToNumber:[NSNumber numberWithInt:aEvent.eventID]]){
                            [[UIApplication sharedApplication] cancelLocalNotification:notification];
                        }
                    }
                    aEvent.reminderSet = NO;
                }
                else {
                    UILocalNotification *reminder = [[UILocalNotification alloc]init];
                    reminder.fireDate = [NSDate dateWithTimeInterval:-900 sinceDate:aEvent.realDate];
                    reminder.timeZone = [NSTimeZone timeZoneWithName:@"Europe/Berlin"];
                    reminder.alertBody = [NSString stringWithFormat:@"Your favorite event %@ will start in 15 minutes",aEvent.title];
                    reminder.alertAction = @"Open";
                    reminder.soundName = @"scifi.caf";
                    reminder.applicationIconBadgeNumber = 1;
                    NSDictionary *userDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:aEvent.eventID] forKey:@"28C3Reminder"];
                    reminder.userInfo = userDict;
                    [[UIApplication sharedApplication] scheduleLocalNotification:reminder];
                    [reminder release];
                    
                    UIAlertView *reminderAlert = [[UIAlertView alloc]initWithTitle:@"Reminder set" message:@"We will buzz your phone 15 minutes before the event" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [reminderAlert show];
                    [reminderAlert release];
                    aEvent.reminderSet = YES;
                }
                
                NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
                NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"favorites"];
                NSMutableArray *favoritesArray = [[NSMutableArray alloc] init];
                                
                if (dataRepresentingSavedArray != nil)
                {
                    NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
                    if (oldSavedArray != nil){
                        [favoritesArray setArray:oldSavedArray];
                    }
                }
                for (int i=0; i < favoritesArray.count; i++){
                    Event *savedEvent = [favoritesArray objectAtIndex:i];
                    if (savedEvent.eventID == aEvent.eventID){
                        [favoritesArray replaceObjectAtIndex:i withObject:aEvent];
                    }
                }
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:favoritesArray] forKey:@"favorites"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [favoritesArray release];
                
                break;
            case 2: {
                EKEventStore *eventStore = [[EKEventStore alloc] init];
                
                EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                
                event.title = aEvent.title;
                [event addAlarm:[EKAlarm alarmWithRelativeOffset:-900]];
                event.notes = aEvent.abstract;
                event.location = aEvent.room;
                event.startDate = aEvent.realDate;
                NSArray *durationArray = [aEvent.duration componentsSeparatedByString:@":"];
                double hours = [[durationArray objectAtIndex:0] doubleValue] * 60 * 60;
                double minutes = [[durationArray objectAtIndex:1] doubleValue] * 60;
                event.endDate = [NSDate dateWithTimeInterval:hours+minutes sinceDate:event.startDate];
                
                [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                NSError *err;
                [eventStore saveEvent:event span:EKSpanThisEvent error:&err]; 

                [eventStore release];

                if (!err){
                    UIAlertView *dateAlert = [[UIAlertView alloc]initWithTitle:@"Saved" message:@"The event was saved to your calendar" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [dateAlert show];
                    [dateAlert release];
                }
                break;
            }
        }			
                
    }
}

- (BOOL) date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate {
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending) 
        return NO;
    
    return YES;
}
	
#pragma mark -
#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 2){
        switch (buttonIndex) {
            case 0: {
                NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
                NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"favorites"];
                NSMutableArray *favoritesArray;
                if (dataRepresentingSavedArray != nil)
                {
                    NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
                    if (oldSavedArray != nil)
                        favoritesArray = [[NSMutableArray alloc] initWithArray:oldSavedArray];
                    else
                        favoritesArray = [[NSMutableArray alloc] init];
                }
                else {
                    favoritesArray = [[NSMutableArray alloc] init];
                }
                
                [favoritesArray addObject:aEvent];

                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:favoritesArray] forKey:@"favorites"];
                [favoritesArray release];
                
                break;
            }
            default:
                break;
        }
    }
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [image release];
    image = nil;
    [scrollView release];
    scrollView = nil;
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[aEvent release];
    [scrollView release];
    [image release];
    [super dealloc];
}


@end

