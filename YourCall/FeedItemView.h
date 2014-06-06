//
//  FeedItemView.h
//  YourCall
//
//  Created by Chih-Chiang Wei on 6/2/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedItemView : UIView
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (CGRect) getFrameInView: (UIView *)view;
@end
