//
//  WebView.h
//  27C3
//
//  Created by Philip Brechler on 08.12.10.
//  Copyright 2010 TimeCoast Communications. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebView : UIViewController <UIWebViewDelegate>{
	
	IBOutlet UIWebView *webView;
	NSString *urlToOpen;

}

@property (nonatomic,retain) NSString *urlToOpen;

@end
