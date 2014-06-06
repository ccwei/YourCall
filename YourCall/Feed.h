//
//  Feed.h
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/3/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedService.h"
#import "FeedItem.h"

@interface Feed : NSObject
typedef enum {First, Second, None} FeedItemIndices;

@property (nonatomic, strong, readonly) NSArray* feedItems;
@property FeedItemIndices votedFeedItemIndex;
@property int feedId;

+ (Feed *)createFeed:(NSDictionary *)feedData;

- (FeedItemIndices) getToggledIndex: (FeedItemIndices) index;
- (void) addFeedItem: (FeedItem *)feedItem;
- (void) vote: (FeedItemIndices) feedItemIndex completionBlock:(void (^)())completionBlock;
- (void) unvote: (FeedItemIndices) feedItemIndex completionBlock:(void (^)())completionBlock;
- (void) save;
@end
