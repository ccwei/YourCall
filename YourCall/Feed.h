//
//  Feed.h
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/3/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedService.h"

@interface Feed : NSObject
typedef enum {None, First, Second} VoteItem;

@property (nonatomic, strong) NSString* imageUrlFirst;
@property (nonatomic, strong) UIImage* imageFirst;
@property (nonatomic, strong) NSString* descriptionFirst;
@property (nonatomic, strong) NSString* imageUrlSecond;
@property (nonatomic, strong) UIImage* imageSecond;
@property (nonatomic, strong) NSString* descriptionSecond;
@property int numberOfVoteFirst;
@property int numberOfVoteSecond;
@property VoteItem votedItem;
@property int feedId;

- (void) getImageFirst:(void(^)(UIImage*))completionBlock;
- (void) getImageSecond:(void(^)(UIImage*))completionBlock;
- (BOOL) voteFirst;
- (BOOL) voteSecond;
- (void) save;
@end
