//
//  FeedComposeView.h
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/13/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ImageEffects.h"

@protocol FeedCompositionViewProtocol <NSObject>
- (void)pannedVertical:(UIPanGestureRecognizer *)recognizer;
- (void)pannedHorizontal:(UIPanGestureRecognizer *)recognizer;
@end

@interface FeedCompositionView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UIButton *addPictureButton;
@property (weak, nonatomic) IBOutlet UILabel *imageEffectLabel;
@property (nonatomic) float darkenValue;
@property (nonatomic) int blurValue;
@property (assign, nonatomic) id<FeedCompositionViewProtocol> delegate;

- (CGRect) getFrameInView: (UIView *)view;
- (void) updateImageEffectLabelWithText: (NSString *)text hidden: (BOOL)hidden;
@end
