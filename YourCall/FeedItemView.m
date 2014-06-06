//
//  FeedItemView.m
//  YourCall
//
//  Created by Chih-Chiang Wei on 6/2/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import "FeedItemView.h"

@implementation FeedItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)getFrameInView:(UIView *)view
{
    CGPoint convertedPoint = [self convertPoint:self.frame.origin toView:view];
    return CGRectMake(convertedPoint.x, convertedPoint.y, self.frame.size.width, self.frame.size.height);
}

@end
