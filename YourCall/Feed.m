//
//  Feed.m
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/3/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import "Feed.h"
@interface Feed ()
@property (nonatomic, strong) NSMutableArray *feedItemsArray;
@end
@implementation Feed

- (id) init {
    if (self = [super init]) {
        self.votedFeedItemIndex = None;
    }
    return self;
}

- (NSMutableArray *)feedItemsArray
{
    if (!_feedItemsArray) {
        _feedItemsArray = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _feedItemsArray;
}

- (NSArray *)feedItems
{
    return [self.feedItemsArray copy];
}

- (void) addFeedItem:(FeedItem *)feedItem
{
    [self.feedItemsArray addObject:feedItem];
}

+ (Feed *)createFeed:(NSDictionary *)feedData
{
    Feed *feed = [[Feed alloc] init];
    feed.feedId = [[feedData valueForKeyPath:@"Id"] intValue];
    NSArray *feedItemsData = [feedData valueForKeyPath:@"FeedItems"];
    for (NSDictionary *feedItemData in feedItemsData) {
        FeedItem *feedItem = [FeedItem createFeedItem:feedItemData];
        [feed addFeedItem:feedItem];
    }
    
    return feed;
}

- (void)vote:(FeedItemIndices)feedItemIndex completionBlock:(void (^)())completionBlock
{
    if (feedItemIndex == self.votedFeedItemIndex) {
        return;
    }
    switch (feedItemIndex) {
        case First:
            [FeedService voteFirst: self.feedId completionBlock:completionBlock];
            self.votedFeedItemIndex = First;
            break;
        case Second:
            [FeedService voteSecond: self.feedId completionBlock:completionBlock];
            self.votedFeedItemIndex = Second;
            break;
        default:
            break;
    }
}

- (void)unvote:(FeedItemIndices)feedItemIndex completionBlock:(void (^)())completionBlock
{
    if (feedItemIndex != self.votedFeedItemIndex) {
        return;
    }
    switch (feedItemIndex) {
        case First:
            [FeedService unvoteFirst: self.feedId completionBlock:completionBlock];
            break;
        case Second:
            [FeedService unvoteSecond: self.feedId completionBlock:completionBlock];
            break;
        default:
            break;
    }
    self.votedFeedItemIndex = None;
}

- (FeedItemIndices) getToggledIndex:(FeedItemIndices)index
{
    FeedItemIndices result = None;

    if (index == First) {
        result = Second;
    }
    if (index == Second) {
        result = First;
    }
    return result;
}

- (void)save
{
    [FeedService postFeed:self];
}
@end
