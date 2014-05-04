//
//  DataRepository.h
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/3/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Feed.h"

@interface DataRepository : NSObject
@property (nonatomic, strong) NSMutableArray *feeds;
- (void) getAllFeeds: (void (^)(NSArray *))completionBlock;
@end
