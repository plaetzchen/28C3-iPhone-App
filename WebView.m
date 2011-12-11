//
//  WebView.m
//  27C3
//
//  Created by Philip Brechler on 08.12.10.
//  Copyright 2010 TimeCoast Communications. All rights reserved.
//

#import "WebView.h"


@implementation WebView

@synthesize urlToOpen;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	NSURL *url = [NSURL URLWithString:self.urlToOpen];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];

}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
    NSLog (@"webView:didFailLoadWithError");
    if (error != NULL) {
        UIAlertView *errorAlert = [[UIAlertView alloc]
								   initWithTitle: [error localizedDescription]
								   message: [error localizedFailureReason]
								   delegate:nil
								   cancelButtonTitle:@"OK" 
								   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
    }
}

- (void)dealloc {
	[urlToOpen release];
    [super dealloc];
}


@end
