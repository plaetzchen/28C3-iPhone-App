
#import <UIKit/UIKit.h>

@class Fahrplan28C3AppDelegate, Event;

@interface XMLParser : NSObject <NSXMLParserDelegate> {
	
	NSMutableString *currentElementValue;
	NSString *tempString;
	
	Fahrplan28C3AppDelegate *appDelegate;
	Event *aEvent; 
}

- (XMLParser *) initXMLParser;

@end
