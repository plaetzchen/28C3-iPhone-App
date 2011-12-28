//
//  Book.h
//  XML
//
//  Created by iPhone SDK Articles on 11/23/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>


@interface Event : NSObject {
	
	NSInteger eventID;
	NSString *title;	//Same name as the Entity Name.
	NSString *room;	//Same name as the Entity Name.
	NSString *abstract;	//Same name as the Entity Name.
    NSString *description;
	NSString *subtitle;
	NSString *start;
	NSString *duration;
	NSString *date;
	NSString *language;
	NSString *track;
    
    NSDate *startDate;
    NSDate *realDate;
    
    BOOL reminderSet;
}

@property (nonatomic, readwrite) NSInteger eventID;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *room;
@property (nonatomic, retain) NSString *abstract;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSString *start;
@property (nonatomic, retain) NSString *duration;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *language;
@property (nonatomic, retain) NSString *track;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *realDate;
@property (nonatomic) BOOL reminderSet;
- (BOOL)isAtDate:(NSDate *)_date;

@end
