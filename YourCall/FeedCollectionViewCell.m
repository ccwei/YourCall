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

- (void)awakeFromNib
{
    _textViewFirst.textColor = [UIColor whiteColor];
    _textViewFirst.backgroundColor = [UIColor clearColor];
 
    _textViewSecond.textColor = [UIColor whiteColor];
    _textViewSecond.backgroundColor = [UIColor clearColor];
    
    _imageViewFirst.contentMode = UIViewContentModeScaleAspectFill;
    _imageViewSecond.contentMode = UIViewContentModeScaleAspectFill;
    
    UITapGestureRecognizer *tapFirstGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedFirstImage:)];
    UITapGestureRecognizer *tapSecondGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedSecondImage:)];
    
    [_firstView addGestureRecognizer:tapFirstGR];
    [_secondView addGestureRecognizer:tapSecondGR];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)tappedFirstImage:(UITapGestureRecognizer *)recognizer
{
    [self.delegate tappedFirstImage:recognizer];
}

- (IBAction)tappedSecondImage:(UITapGestureRecognizer *)recognizer
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
