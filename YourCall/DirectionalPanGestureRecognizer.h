//
//  DirectionalPanGestureRecognizer.h
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/18/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

typedef enum {
    DirectionalPanGestureRecognizerVertical,
    DirectionalPanGestureRecognizerHorizontal
} DirectionalPanGestureRecognizerDirection;

@interface DirectionalPanGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic) DirectionalPanGestureRecognizerDirection direciton;
@end
