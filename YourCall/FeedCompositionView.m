//
//  FeedComposeView.m
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/13/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import "FeedCompositionView.h"
#import "DirectionalPanGestureRecognizer.h"

@interface FeedCompositionView() <UITextViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@end

static NSString *placeHolderString = @"Description for this item";

@implementation FeedCompositionView 
@synthesize textColor = _textColor;

- (void)setDarkenValue:(float)darkenValue
{
    if (darkenValue >= 0.0f && darkenValue <= 1.0f) {
        _darkenValue = darkenValue;
    }
}

- (void)setBlurValue:(int)blurValue
{
    if (blurValue >= 0 && blurValue <= 10) {
        _blurValue = blurValue;
    }
}

- (UIColor *)textColor
{
    if (!_textColor) {
        _textColor = [UIColor blackColor];
    }
    return _textColor;
}

- (void)setTextColor:(UIColor *)textColor
{
    if (![_textColor isEqual:textColor]) {
        _textColor = textColor;
        self.textView.textColor = textColor;
    }
}

- (void)awakeFromNib
{
    self.textView.delegate = self;
    self.textView.text = placeHolderString;
    self.textView.textColor =[UIColor lightGrayColor];
    self.textView.backgroundColor = [UIColor clearColor];
    
    [self.imageEffectLabel setFont:[UIFont fontWithName:@"SegoeUI-Semilight" size:14.0]];
    self.imageEffectLabel.textColor = [UIColor whiteColor];
    self.imageEffectLabel.backgroundColor = [UIColor lightGrayColor];
    self.imageEffectLabel.hidden = YES;
    
    DirectionalPanGestureRecognizer *panGRVertical = [[DirectionalPanGestureRecognizer alloc] initWithTarget:self action:@selector(pannedVertical:)];
    panGRVertical.direciton = DirectionalPanGestureRecognizerVertical;
    panGRVertical.delegate = self;
    
    DirectionalPanGestureRecognizer *panGRHorizontal = [[DirectionalPanGestureRecognizer alloc] initWithTarget:self action:@selector(pannedHorizontal:)];
    panGRHorizontal.direciton = DirectionalPanGestureRecognizerHorizontal;
    panGRHorizontal.delegate = self;
    [self.backgroundView addGestureRecognizer:panGRVertical];
    [self.backgroundView addGestureRecognizer:panGRHorizontal];
    
}

/*
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
*/
/*
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint velocity = [panGestureRecognizer velocityInView:self];
    return fabs(velocity.y) > fabs(velocity.x);
}*/

- (void)pannedVertical: (UIPanGestureRecognizer *)recognizer
{
    [self.delegate pannedVertical:recognizer];
}

- (void)pannedHorizontal: (UIPanGestureRecognizer *)recognizer
{
    [self.delegate pannedHorizontal:recognizer];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
     }
    return self;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:placeHolderString]) {
        textView.text = @"";
        textView.textColor = self.textColor;
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = placeHolderString;
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

- (BOOL) textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    static const NSUInteger MAX_NUMBER_OF_LINES_ALLOWED = 5;
    
    NSMutableString *t = [NSMutableString stringWithString:
                          self.textView.text];
    [t replaceCharactersInRange: range withString: text];
    
    NSUInteger numberOfLines = 0;
    for (NSUInteger i = 0; i < t.length; i++) {
        if ([[NSCharacterSet newlineCharacterSet]
             characterIsMember: [t characterAtIndex: i]]) {
            numberOfLines++;
        }
    }
    
    return (numberOfLines < MAX_NUMBER_OF_LINES_ALLOWED);
}
@end
