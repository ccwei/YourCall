//
//  FeedCollectionViewCell.m
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/3/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import "FeedCollectionViewCell.h"

@interface FeedCollectionViewCell ()<UIGestureRecognizerDelegate>
@end

@implementation FeedCollectionViewCell

- (void) setFeed:(Feed *)feed
{
    if (_feed != feed) {
        _feed = feed;
    }
    self.imageViewFirst.image = nil;
    [feed getImageFirst:^(UIImage* image) {
        self.imageViewFirst.image = image;
        [self setNeedsDisplay];
    }];
    
    self.imageViewSecond.image = nil;
    [feed getImageSecond:^(UIImage* image) {
        self.imageViewSecond.image = image;
        [self setNeedsDisplay];
    }];
    
    self.textViewFirst.text = feed.descriptionFirst;
    self.textViewSecond.text = feed.descriptionSecond;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect bounds = self.contentView.bounds;
        _imageViewFirst = [[UIImageView alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y, 200.0f, 200.0f)];
        _imageViewSecond = [[UIImageView alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y + 220, 200.0f, 200.0f)];
        _textViewFirst = [[UITextView alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y, 200.0f, 200.0f)];
        _textViewSecond = [[UITextView alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y + 220, 200.0f, 200.0f)];
        
        UITapGestureRecognizer *tapFirstGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedFirstImage:)];
        UITapGestureRecognizer *tapSecondGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedSecondImage:)];
        
        _imageViewFirst.userInteractionEnabled = YES;
        _imageViewSecond.userInteractionEnabled = YES;
        
        _textViewFirst.editable = NO;
        _textViewFirst.backgroundColor = [UIColor clearColor];
        _textViewSecond.editable = NO;
        _textViewSecond.backgroundColor = [UIColor clearColor];
        
        _imageViewFirst.contentMode = UIViewContentModeScaleToFill;
        _imageViewSecond.contentMode = UIViewContentModeScaleToFill;
        
        [_imageViewFirst addGestureRecognizer:tapFirstGR];
        [_imageViewSecond addGestureRecognizer:tapSecondGR];
        
        [self.contentView addSubview:_imageViewFirst];
        [self.contentView addSubview:_textViewFirst];
        [self.contentView addSubview:_imageViewSecond];
        [self.contentView addSubview:_textViewSecond];
    }
    return self;
}

- (void)tappedFirstImage:(UITapGestureRecognizer *)recognizer
{
    [self.delegate tappedFirstImage:recognizer];
}

- (void)tappedSecondImage:(UITapGestureRecognizer *)recognizer
{
    [self.delegate tappedSecondImage:recognizer];
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
