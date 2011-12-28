//
//  Book.m
//  XML
//
//  Created by iPhone SDK Articles on 11/23/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "Event.h"


@implementation Event

@synthesize title, room, abstract, description, eventID, subtitle, start, duration,date,language,track,startDate,realDate,reminderSet;

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:title forKey:@"title"];
    [coder encodeObject:room forKey:@"room"];
    [coder encodeObject:abstract forKey:@"abstract"];
    [coder encodeObject:description forKey:@"description"];
    [coder encodeInteger:eventID forKey:@"eventID"]; 
    [coder encodeObject:subtitle forKey:@"subtitle"];
    [coder encodeObject:start forKey:@"start"]; 
    [coder encodeObject:duration forKey:@"duration"];
    [coder encodeObject:date forKey:@"date"];
    [coder encodeObject:language forKey:@"language"];
    [coder encodeObject:track forKey:@"track"];
    [coder encodeObject:startDate forKey:@"startDate"];
    [coder encodeObject:realDate forKey:@"realDate"];
    [coder encodeBool:reminderSet forKey:@"reminderSet"];

}

- (id)initWithCoder:(NSCoder *)coder;
{
    if (self = [super init])
    {
        self.title = [coder decodeObjectForKey:@"title"];
        self.room = [coder decodeObjectForKey:@"room"];
        self.abstract = [coder decodeObjectForKey:@"abstract"];
        self.description = [coder decodeObjectForKey:@"description"];
        self.subtitle = [coder decodeObjectForKey:@"subtitle"];
        self.start = [coder decodeObjectForKey:@"start"];
        self.duration = [coder decodeObjectForKey:@"duration"];
        self.date = [coder decodeObjectForKey:@"date"];
        self.language = [coder decodeObjectForKey:@"language"];
        self.track = [coder decodeObjectForKey:@"track"];
        self.startDate = [coder decodeObjectForKey:@"startDate"];
        self.realDate = [coder decodeObjectForKey:@"realDate"];
        self.reminderSet = [coder decodeBoolForKey:@"reminderSet"];

        self.eventID = [coder decodeIntegerForKey:@"eventID"];
    }   
    return self;
}

- (BOOL)isAtDate:(NSDate *)_date {
    NSArray *durationArray = [self.duration componentsSeparatedByString:@":"];
    double hours = [[durationArray objectAtIndex:0] doubleValue] * 60 * 60;
    double minutes = [[durationArray objectAtIndex:1] doubleValue] * 60;
    NSDate * endDate = [NSDate dateWithTimeInterval:hours+minutes sinceDate:self.startDate];
    
    return [_date compare:self.startDate] == NSOrderedDescending  && [_date compare:endDate] == NSOrderedAscending;
}

- (void) dealloc {
	
	[abstract release];
    [description release];
	[subtitle release];
	[start release];
	[duration release];
	[room release];
	[title release];
	[date release];
	[language release];
	[track release];
    [startDate release];
    [realDate release];
	[super dealloc];
	
}

@end
