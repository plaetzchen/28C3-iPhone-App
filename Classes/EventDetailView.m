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

@synthesize aEvent;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"Details";

}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	NSString *theLanguage = @"unknown";
	
	abstractText.font = [UIFont fontWithName:@"Courier" size:15];
	abstractText.textColor = [UIColor whiteColor];
	
	titleLabel.text = aEvent.title;
	subtitleLabel.text = aEvent.subtitle;
	abstractText.text = aEvent.abstract;
	roomLabel.text = [@"Room: " stringByAppendingString:aEvent.room];
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

}



-(IBAction)actionButtonPressed:(id)sender{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"View in Web",@"Add to Calendar",nil,nil,nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	actionSheet.tag=1;
    [actionSheet showInView:self.view];
    [actionSheet release];
	
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case 0:
			NSLog(@"Web");
			if(wvController == nil)
				wvController = [[WebView alloc] initWithNibName:@"WebView" bundle:[NSBundle mainBundle]];
			
			NSString *theUrl = @"http://events.ccc.de/congress/2011/Fahrplan/events/";
			theUrl = [[theUrl stringByAppendingFormat:@"%i",aEvent.eventID] stringByAppendingString:@".en.html"];
			
			wvController.urlToOpen = theUrl;
			
			[self.navigationController pushViewController:wvController animated:YES];

			break;
		case 1: {
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
            event.endDate   = [[NSDate alloc] initWithTimeInterval:hours+minutes   sinceDate:event.startDate];
            
            [event setCalendar:[eventStore defaultCalendarForNewEvents]];
            NSError *err;
            [eventStore saveEvent:event span:EKSpanThisEvent error:&err]; 
            if (!err){
                UIAlertView *dateAlert = [[UIAlertView alloc]initWithTitle:@"Saved" message:@"The event was saved to your calendar" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [dateAlert show];
                [dateAlert release];
            }
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[aEvent release];
    [super dealloc];
}


@end

