//
//  FeedCollectionViewCell.m
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/3/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import "FeedCollectionViewCell.h"

@implementation FeedCollectionViewCell

- (void) setFeed:(Feed *)feed
{
    if (_feed != feed) {
        _feed = feed;
    }
    if (!feed.image) {
        feed.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:feed.imageUrl]]];
    }
    self.imageView.image = feed.image;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
