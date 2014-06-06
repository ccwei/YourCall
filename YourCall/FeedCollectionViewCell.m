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
        [self updateFeedItemViews:feed];
    }
}

- (void)updateFeedItemViews: (Feed *)feed
{
    for (int i = 0; i < feed.feedItems.count; i++) {
        FeedItem *feedItem = [feed.feedItems objectAtIndex:i];
        FeedItemView *feedItemView = [self.feedItemViews objectAtIndex:i];
        [feedItemView.activityIndicator startAnimating];
        feedItemView.imageView.image = nil;
        [feedItem getImage:^(UIImage* image) {
            feedItemView.imageView.image = image;
            [self setNeedsDisplay];
            [feedItemView.activityIndicator stopAnimating];
        }];
        feedItemView.descriptionTextView.text = feedItem.description;
    }
}

- (void)setupFeedItemViews
{
    NSArray *bundleObjects;
    FeedItemView *feedItemView;
    NSMutableArray *tempViews = [NSMutableArray arrayWithCapacity:self.feedItemViews.count];
    int index = 0;
    for (UIView *currentWrapperView in self.feedItemViews) {
        bundleObjects = [[NSBundle mainBundle] loadNibNamed:@"FeedItemView" owner:self options:nil];
        for (id object in bundleObjects) {
            if ([object isKindOfClass:[FeedItemView class]]){
                feedItemView = (FeedItemView *)object;
                break;
            }
        }
        feedItemView.descriptionTextView.textColor = [UIColor whiteColor];
        feedItemView.descriptionTextView.backgroundColor = [UIColor clearColor];
        feedItemView.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [feedItemView addGestureRecognizer:tapGR];
        
        [currentWrapperView addSubview:feedItemView];
        
        [tempViews addObject:feedItemView];
        index++;
    }
    self.feedItemViews = tempViews;
}

- (void)setupVoteImageView
{
    self.voteImageView.hidden = YES;
    
    if (self.feedItemIndex == First) {
        self.voteImageView.frame = CGRectMake(0, 0, 50, 50);
    } else if (self.feedItemIndex == Second){
        self.voteImageView.frame = CGRectMake(0, 220, 50, 50);
    }
}

- (void)awakeFromNib
{
    [self setupFeedItemViews];
    [self setupVoteImageView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)tapped:(UITapGestureRecognizer *)recognizer
{
    [self.delegate tapped:recognizer];
}

@end
