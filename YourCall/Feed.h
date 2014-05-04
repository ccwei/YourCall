//
//  Feed.h
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/3/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feed : NSObject
@property (nonatomic, strong) NSString* imageUrl;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong) NSString* description;
@property int like;
@property int dislike;
@property int feedId;
@end
