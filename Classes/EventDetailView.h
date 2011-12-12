//
//  EventDetailView.h
//  27C3
//
//  Created by Philip Brechler on 08.12.10.
//  Copyright 2010 TimeCoast Communications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebView.h"

@class Event, WebView, ReminderView;

@interface EventDetailView : UIViewController <UIActionSheetDelegate, UIAlertViewDelegate> {

	Event *aEvent;
	WebView *wvController;
	ReminderView *rvController;
    
    BOOL fromFavorites;
	
	IBOutlet UITextView *abstractText;
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *roomLabel;
	IBOutlet UILabel *startLabel;
	IBOutlet UILabel *durationLabel;
	IBOutlet UILabel *subtitleLabel;
	IBOutlet UILabel *idLabel;
	IBOutlet UILabel *languageLabel;	
    IBOutlet UILabel *trackLabel;

	
	

}

@property (nonatomic, retain) Event *aEvent;
@property (nonatomic) BOOL fromFavorites;

-(IBAction)actionButtonPressed:(id)sender;
- (BOOL) date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;


@end
