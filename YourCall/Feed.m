//
//  Feed.m
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/3/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import "Feed.h"

@implementation Feed
- (void) getImageFirst:(void(^)(UIImage*))completionBlock
{
    if (!_imageFirst) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _imageFirst = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrlFirst]]];
            CGSize newSize = CGSizeMake(800.0f, 600.0f);
            UIGraphicsBeginImageContext(newSize);
            [_imageFirst drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
            _imageFirst = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(_imageFirst);
                });
            }
        });
    } else {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(_imageFirst);
            });
        }
    }
}

- (void) getImageSecond:(void(^)(UIImage*))completionBlock
{
    if (!_imageSecond) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _imageSecond = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrlSecond]]];
            CGSize newSize = CGSizeMake(800.0f, 600.0f);
            UIGraphicsBeginImageContext(newSize);
            [_imageSecond drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
            _imageSecond = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(_imageSecond);
                }
            });
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(_imageSecond);
            }
        });
    }
}

- (BOOL) voteFirst
{
    switch (self.votedItem) {
        case None:
            [FeedService voteFirst: self.feedId completionBlock:nil];
            self.votedItem = First;
            return YES;
        case First:
            [FeedService unvoteFirst: self.feedId completionBlock:nil];
            self.votedItem = None;
            return NO;
        case Second:
        {
            [FeedService unvoteSecond: self.feedId completionBlock:^{
                [FeedService voteFirst: self.feedId completionBlock: nil];
            }];
            self.votedItem = First;
            return YES;
        }
        default:
            break;
    }
}

- (BOOL) voteSecond
{
    switch (self.votedItem) {
        case None:
            [FeedService voteSecond: self.feedId completionBlock:nil];
            self.votedItem = Second;
            return YES;
        case First:
        {
            [FeedService unvoteFirst: self.feedId completionBlock:^{
                [FeedService voteSecond: self.feedId completionBlock:nil];
            }];
            self.votedItem = Second;
            return YES;
        }
        case Second:
            [FeedService unvoteSecond: self.feedId completionBlock:nil];
            self.votedItem = None;
            return NO;
        default:
            break;
    }
}

- (void)save
{
    [FeedService createFeed:self];
}
@end
