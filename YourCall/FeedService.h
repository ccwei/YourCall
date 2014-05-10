//
//  FeedService.h
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/4/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Feed.h"

@interface FeedService : NSObject
+ (void) getAllFeeds: (void (^)(NSArray *))completionBlock;
+ (void)voteFirst: (int) feedId;
+ (void)voteSecond: (int) feedId;
+ (void)unvoteFirst: (int) feedId;
+ (void)unvoteSecond: (int) feedId;
@end
