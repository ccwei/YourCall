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

- (id)init {
    if (self = [super init]) {
        _allFeeds = [[NSArray alloc] init];
    }
    return self;
}

+ (DataRepository *)getInstance
{
    static DataRepository *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void) allFeeds: (void (^)(NSArray *))completionBlock
{
    [FeedService getAllFeeds:^(NSArray *feeds) {
        self.allFeeds = feeds;
        completionBlock(feeds);
    }];
}

- (void) myFeeds: (void (^)(NSArray *))completionBlock
{
    [FeedService getMyFeeds:^(NSArray *feeds) {
        self.myFeeds = feeds;
        completionBlock(feeds);
    }];
}

@end
