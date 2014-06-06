//
//  FeedService.h
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/4/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Feed.h"
@class Feed;

@interface FeedService : NSObject
+ (void)getAllFeeds: (void (^)(NSArray *))completionBlock;
+ (void)getMyFeeds: (void (^)(NSArray *))completionBlock;
+ (void)voteFirst: (int) feedId completionBlock:(void (^)())completionBlock;
+ (void)voteSecond: (int) feedId completionBlock:(void (^)())completionBlock;
+ (void)unvoteFirst: (int) feedId completionBlock:(void (^)())completionBlock;
+ (void)unvoteSecond: (int) feedId completionBlock:(void (^)())completionBlock;
+ (void)postFeed:(Feed *) feed;
@end
