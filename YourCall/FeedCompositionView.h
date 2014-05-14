//
//  FeedComposeView.h
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/13/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedCompositionView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *addPictureButton;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (strong, nonatomic) UIColor *textColor;
@end
