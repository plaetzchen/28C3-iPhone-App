//
//  StreamsViewController.h
//  28C3
//
//  Created by Philip Brechler on 11.12.11.
//  Copyright (c) 2011 Hoccer GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreamsViewController : UIViewController <UIWebViewDelegate> {
    
    IBOutlet UIWebView *streamWebView;
}

@property (nonatomic,retain) UIWebView *streamWebView;

@end
