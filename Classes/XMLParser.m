//
//  XMLParser.m
//  XML
//
//  Created by iPhone SDK Articles on 11/23/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "XMLParser.h"
#import "28C3AppDelegate.h"
#import "Event.h"

@implementation XMLParser

- (XMLParser *) initXMLParser {
	self = [super init];
	appDelegate = (Fahrplan28C3AppDelegate *)[[UIApplication sharedApplication] delegate];
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"schedule"]) {
		//Empty the array.
        [appDelegate.events removeAllObjects];
	}
	else if([elementName isEqualToString:@"day"]){
		tempString = [attributeDict objectForKey:@"date"];
	}
	else if([elementName isEqualToString:@"event"]) {
		
		//Initialize the event.
		aEvent = [[Event alloc] init];
		
		//Extract the attribute here.
		aEvent.eventID = [[attributeDict objectForKey:@"id"] integerValue];

		//NSLog(@"Reading id value :%i", aEvent.eventID);
	}
	
	
	//NSLog(@"Processing Element: %@", elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
	
	if(!currentElementValue){
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	}
	else{
        [currentElementValue appendString:string];
	}
	
	//NSLog(@"Processing Value: %@", currentElementValue);
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if([elementName isEqualToString:@"schedule"])
		return;
	
	//There is nothing to do if we encounter the Books element here.
	//If we encounter the Book element howevere, we want to add the book object to the array
	// and release the object.
	if([elementName isEqualToString:@"event"]) {
		[appDelegate.events addObject:aEvent];
		[aEvent release];
		aEvent = nil;
	}
	else {
		NSString *cleanerString = [currentElementValue stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		NSString *theCleanestString = [cleanerString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
		theCleanestString = [theCleanestString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

		if ([elementName isEqualToString:@"title"]){
			[aEvent setValue:theCleanestString forKey:elementName];
		}
		if ([elementName isEqualToString:@"subtitle"]){
			[aEvent setValue:theCleanestString forKey:elementName];
		}
		if ([elementName isEqualToString:@"abstract"]){
			[aEvent setValue:theCleanestString forKey:elementName];
		}
		if ([elementName isEqualToString:@"duration"]){
			[aEvent setValue:theCleanestString forKey:elementName];
		}
		if ([elementName isEqualToString:@"start"]){
			[aEvent setValue:theCleanestString forKey:elementName];
		}
		if ([elementName isEqualToString:@"room"]){
			[aEvent setValue:theCleanestString forKey:elementName];
		}
		if ([elementName isEqualToString:@"language"]){
			[aEvent setValue:theCleanestString forKey:elementName];
		}
		if ([elementName isEqualToString:@"track"]){
			[aEvent setValue:theCleanestString forKey:elementName];
		}
		[aEvent setValue:tempString forKey:@"date"];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *myDate = [df dateFromString: [NSString stringWithFormat:@"%@ %@",aEvent.date,aEvent.start]];
        
        [aEvent setStartDate:myDate];
        [df release];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:myDate];
        NSInteger hour = [components hour];
        
        if (hour < 8){
            [aEvent setRealDate:[myDate dateByAddingTimeInterval:86400]];
        }
        else {
            [aEvent setRealDate:myDate];
        }
	
	[currentElementValue release];
	currentElementValue = nil;
	}
	
}

- (void) dealloc {
	[aEvent release];
	[currentElementValue release];
	[super dealloc];
}

@end
