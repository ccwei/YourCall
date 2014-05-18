//
//  DirectionalPanGestureRecognizer.m
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/18/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import "DirectionalPanGestureRecognizer.h"

@interface DirectionalPanGestureRecognizer()
@property (nonatomic) int moveX;
@property (nonatomic) int moveY;
@property (nonatomic) BOOL drag;
@end

int const static kDirectionPanThreshold = 5;

@implementation DirectionalPanGestureRecognizer

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) return;
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    self.moveX += prevPoint.x - nowPoint.x;
    self.moveY += prevPoint.y - nowPoint.y;
    if (!self.drag) {
        if (abs(self.moveX) > kDirectionPanThreshold) {
            if (self.direciton == DirectionalPanGestureRecognizerVertical) {
                self.state = UIGestureRecognizerStateFailed;
            }else {
                self.drag = YES;
                self.state = UIGestureRecognizerStateChanged;
            }
        }else if (abs(self.moveY) > kDirectionPanThreshold) {
            if (self.direciton == DirectionalPanGestureRecognizerHorizontal) {
                self.state = UIGestureRecognizerStateFailed;
            }else {
                self.drag = YES;
                self.state = UIGestureRecognizerStateChanged;
            }
        }
    }
}

- (void)reset {
    [super reset];
    self.drag = NO;
    self.moveX = 0;
    self.moveY = 0;
}

@end
