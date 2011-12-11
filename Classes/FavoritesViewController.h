//
//  FavoritesViewController.h
//  28C3
//
//  Created by Philip Brechler on 11.12.11.
//  Copyright (c) 2011 Hoccer GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@class EventDetailView;

@interface FavoritesViewController : UITableViewController {
    
    EventDetailView *edvController;

    
    NSMutableArray *favoritesArray;
    
}

@property (nonatomic, retain) NSMutableArray *favoritesArray;

@end
