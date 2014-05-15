//
//  CreateNewFeedViewController.h
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/10/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"

@interface CreateNewFeedViewController : UIViewController
@property BOOL isCanceled;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *feedCompositionViews;
@end
