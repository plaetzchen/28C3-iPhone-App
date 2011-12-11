//
//  Book.m
//  XML
//
//  Created by iPhone SDK Articles on 11/23/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "Event.h"


@implementation Event

@synthesize title, room, abstract, eventID, subtitle, start, duration,date,language,track,startDate,realDate;

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:title forKey:@"title"];
    [coder encodeObject:room forKey:@"room"];
    [coder encodeObject:abstract forKey:@"abstract"];
    [coder encodeInteger:eventID forKey:@"eventID"]; 
    [coder encodeObject:subtitle forKey:@"subtitle"];
    [coder encodeObject:start forKey:@"start"]; 
    [coder encodeObject:duration forKey:@"duration"];
    [coder encodeObject:date forKey:@"date"];
    [coder encodeObject:language forKey:@"language"];
    [coder encodeObject:track forKey:@"track"];
    [coder encodeObject:startDate forKey:@"startDate"];
    [coder encodeObject:realDate forKey:@"realDate"];

}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[Event alloc] init];
    if (self != nil)
    {
        title = [[coder decodeObjectForKey:@"title"] retain];
        room = [[coder decodeObjectForKey:@"room"] retain];
        abstract = [[coder decodeObjectForKey:@"abstract"] retain];
        subtitle = [[coder decodeObjectForKey:@"subtitle"] retain];
        start = [[coder decodeObjectForKey:@"start"] retain];
        duration = [[coder decodeObjectForKey:@"duration"] retain];
        date = [[coder decodeObjectForKey:@"date"] retain];
        language = [[coder decodeObjectForKey:@"language"] retain];
        track = [[coder decodeObjectForKey:@"track"] retain];
        startDate = [[coder decodeObjectForKey:@"startDate"] retain];
        realDate = [[coder decodeObjectForKey:@"realDate"] retain];

        eventID = [coder decodeIntegerForKey:@"eventID"];
    }   
    return self;
}


- (void) dealloc {
	
	[abstract release];
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
