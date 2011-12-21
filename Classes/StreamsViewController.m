//
//  StreamsViewController.m
//  28C3
//
//  Created by Philip Brechler on 11.12.11.
//  Copyright (c) 2011 Hoccer GmbH. All rights reserved.
//

#import "StreamsViewController.h"

@implementation StreamsViewController
@synthesize streamWebView;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"28c3_background_long"]];
    streamWebView.opaque = NO;
    streamWebView.backgroundColor = [UIColor clearColor];
    if([navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        [navigationBar setBackgroundImage:[UIImage imageNamed:@"28c3_navbar"] forBarMetrics:UIBarMetricsDefault];
    }
  
}

- (void)viewDidAppear:(BOOL)animated {
      [self.streamWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.call-a-nerd.de/28C3/streams.html"]]];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (error){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"You need to be online to view the streams" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
