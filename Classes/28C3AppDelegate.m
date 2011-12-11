//
//  28C3AppDelegate.m
//  27C3
//
//  Created by Philip Brechler on 08.12.10.
//  Copyright 2010 TimeCoast Communications. All rights reserved.
//

#import "28C3AppDelegate.h"
#import "RootViewController.h"
#import "XMLParser.h"


@implementation Fahrplan28C3AppDelegate

@synthesize window;
@synthesize navigationController, tabBarController, events;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"AlreadyRan"] ) {
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"AlreadyRan"];
        NSFileManager *fmngr = [[NSFileManager alloc] init];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"fahrplan.xml" ofType:nil];
        NSError *error;
        if(![fmngr copyItemAtPath:filePath toPath:[NSString stringWithFormat:@"%@/Documents/fahrplan.xml", NSHomeDirectory()] error:&error]) {
            // handle the error
            NSLog(@"Error creating the database: %@", [error description]);
            
        }
        [fmngr release];
    }
    // Add the navigation controller's view to the window and display.
    [self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];
	
	 application.applicationIconBadgeNumber = 0;
    [self loadXML];

    return YES;
}

-(void)loadXML {
    NSURL *myURL = [NSURL URLWithString:@"http://events.ccc.de/congress/2011/Fahrplan/schedule.en.xml"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    fahrplanData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [fahrplanData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [fahrplanData release];
    [connection release];
    UIAlertView *offlineAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Could not update data. Using last cached data!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [offlineAlert show];
    [offlineAlert release];
    [self parseXML];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    NSLog(@"Succeeded! Received %d bytes of data",[fahrplanData length]);
    NSString *txt = [[[NSString alloc] initWithData:fahrplanData encoding: NSUTF8StringEncoding] autorelease];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/fahrplan.xml", 
                          documentsDirectory];
   
    [txt writeToFile:fileName atomically:NO encoding:NSUTF8StringEncoding error:nil];
    [self parseXML];

    
}

-(void)parseXML {
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/fahrplan.xml", 
                          documentsDirectory];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[[NSURL alloc]initFileURLWithPath:fileName]];
        
		//Initialize the delegate.
		XMLParser *parser = [[XMLParser alloc] initXMLParser];
        
		//Set delegate
		[xmlParser setDelegate:parser];
        
		//Start parsing the XML file.
		BOOL success = [xmlParser parse];
        
    if(success){
			NSLog(@"No Errors");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"xmlParsed" object:self];
    }
		else
			NSLog(@"Error Error Error!!!");
    [parser release];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	application.applicationIconBadgeNumber = 0;

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

- (BOOL) connectedToNetwork
{
 	return ([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.brechler-web.de/text.txt"] encoding:NSUTF8StringEncoding error:nil]!=NULL)?YES:NO;
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[events release];
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

