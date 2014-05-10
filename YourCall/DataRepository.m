//
//  DataRepository.m
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/3/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import "DataRepository.h"

@interface DataRepository()
@end

@implementation DataRepository

-(NSArray *)feeds
{
    if (!_feeds) {
        _feeds = [[NSArray alloc] init];
    }
    return _feeds;
}

- (void) allFeeds: (void (^)(NSArray *))completionBlock
{
    [FeedService getAllFeeds:^(NSArray *feeds) {
        self.feeds = feeds;
        completionBlock(feeds);
    }];
}

@end
