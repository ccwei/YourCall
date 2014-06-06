//
//  DataRepository.h
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/3/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Feed.h"
#import "FeedService.h"

@interface DataRepository : NSObject
@property (nonatomic, strong) NSArray *allFeeds;
@property (nonatomic, strong) NSArray *myFeeds;
- (void) allFeeds: (void (^)(NSArray *))completionBlock;
- (void) myFeeds: (void (^)(NSArray *))completionBlock;
+ (DataRepository *)getInstance;
@end
