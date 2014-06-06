//
//  FeedItem.h
//  YourCall
//
//  Created by Chih-Chiang Wei on 6/1/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedItem : NSObject
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) int feedId;
@property (nonatomic) int feedItemId;
@property (nonatomic) int index;
@property (nonatomic) int vote;
@property (nonatomic, strong) NSArray *voters;
+ (FeedItem *)createFeedItem: (NSDictionary *)feedItemData;
- (void)getImage:(void(^)(UIImage*))completionBlock;
@end
