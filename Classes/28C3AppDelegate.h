//
//  28C3AppDelegate.h
//  27C3
//
//  Created by Philip Brechler on 08.12.10.
//

#import <UIKit/UIKit.h>

@interface Fahrplan28C3AppDelegate : NSObject <UIApplicationDelegate,UIAlertViewDelegate,NSURLConnectionDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
    UITabBarController *tabBarController;
	
	NSMutableArray *events;
    
    NSMutableData *fahrplanData;
    
    NSURLConnection *connection;
    NSXMLParser *xmlParser;
    
    BOOL usingOfflineData;
    BOOL newFahrplanVersion;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) NSMutableArray *events;

- (BOOL) connectedToNetwork;
- (void) loadXML;
- (void) parseXML;

@end

