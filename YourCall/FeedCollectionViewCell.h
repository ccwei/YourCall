//
//  FeedCollectionViewCell.h
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/3/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"
#import "FeedService.h"
#import "UIImage+ImageEffects.h"
#import "FeedItemView.h"

@protocol FeedCollectionViewCellProtocol <NSObject>
- (void)tapped:(UITapGestureRecognizer *)recognizer;
@end

@interface FeedCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *feedItemViews;

@property (nonatomic, weak) IBOutlet UIImageView *imageViewFirst;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewSecond;
@property (nonatomic, weak) IBOutlet UITextView *textViewFirst;
@property (nonatomic, weak) IBOutlet UITextView *textViewSecond;
@property (weak, nonatomic) IBOutlet UIImageView *voteImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorFirst;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorSecond;
@property (nonatomic) FeedItemIndices feedItemIndex;
@property (nonatomic, strong) Feed *feed;
@property (nonatomic, assign) id<FeedCollectionViewCellProtocol> delegate;
@end
