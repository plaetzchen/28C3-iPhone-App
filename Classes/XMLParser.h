
#import <UIKit/UIKit.h>

@class _7C3AppDelegate, Event;

@interface XMLParser : NSObject <NSXMLParserDelegate> {
	
	NSMutableString *currentElementValue;
	NSString *tempString;
	
	_7C3AppDelegate *appDelegate;
	Event *aEvent; 
}

- (XMLParser *) initXMLParser;

@end
