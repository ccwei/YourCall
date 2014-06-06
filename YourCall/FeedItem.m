//
//  FeedItem.m
//  YourCall
//
//  Created by Chih-Chiang Wei on 6/1/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import "FeedItem.h"

@implementation FeedItem
- (void)getImage:(void(^)(UIImage*))completionBlock
{
    if (!_image) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]]];
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(_image);
                });
            }
        });
    } else {
        if (completionBlock) {
            completionBlock(_image);
        }
    }
}

+ (FeedItem *)createFeedItem: (NSDictionary *)feedItemData
{
    FeedItem *feedItem = [[FeedItem alloc] init];
    feedItem.description = [feedItemData valueForKeyPath:@"Description"];
    feedItem.feedId = [[feedItemData valueForKeyPath:@"FeedId"] intValue];
    feedItem.imageUrl = [feedItemData valueForKeyPath:@"ImageUrl"];
    feedItem.index = [[feedItemData valueForKeyPath:@"Index"] intValue];
    feedItem.feedItemId = [[feedItemData valueForKeyPath:@"Id"] intValue];
    id vote = [feedItemData valueForKeyPath:@"Vote"];
    feedItem.vote = ![vote isEqual: [NSNull null]] ? [vote intValue] : 0;
    
    return feedItem;
}
@end
