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

#define MIN_DARK 0.0f
#define MAX_DARK 1.0f
- (void)setDarkenValue:(float)darkenValue
{
    if (darkenValue >= MIN_DARK && darkenValue <= MAX_DARK) {
        _darkenValue = darkenValue;
        [self updateImageView];
    }
}

#define MIN_BLUR 0
#define MAX_BLUR 10
- (void)setBlurValue:(int)blurValue
{
    if (blurValue >= MIN_BLUR && blurValue <= MAX_BLUR) {
        _blurValue = blurValue;
        [self updateImageView];
    }
}

#define DEFAULT_DESCRIPTION_TEXT_COLOR [UIColor lightGrayColor]
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

- (void)initialSetup
{
    [self setupTextView];
    [self setupImageEffectLabel];
    [self setupGestureRecognizer];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialSetup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initialSetup];
}

- (void)setupTextView
{
    self.textView.delegate = self;
    self.textView.text = placeHolderString;
    self.textView.textColor =[UIColor lightGrayColor];
    self.textView.backgroundColor = [UIColor clearColor];
}

- (void)setupImageEffectLabel
{
    [self.imageEffectLabel setFont:[UIFont fontWithName:@"SegoeUI-Semilight" size:14.0]];
    self.imageEffectLabel.textColor = [UIColor whiteColor];
    self.imageEffectLabel.backgroundColor = [UIColor lightGrayColor];
    self.imageEffectLabel.hidden = YES;
}

- (void)setupGestureRecognizer
{
    DirectionalPanGestureRecognizer *panGRVertical = [[DirectionalPanGestureRecognizer alloc] initWithTarget:self action:@selector(pannedVertical:)];
    panGRVertical.direciton = DirectionalPanGestureRecognizerVertical;
    
    DirectionalPanGestureRecognizer *panGRHorizontal = [[DirectionalPanGestureRecognizer alloc] initWithTarget:self action:@selector(pannedHorizontal:)];
    panGRHorizontal.direciton = DirectionalPanGestureRecognizerHorizontal;
    [self.backgroundView addGestureRecognizer:panGRVertical];
    [self.backgroundView addGestureRecognizer:panGRHorizontal];
}

- (void)pannedVertical: (UIPanGestureRecognizer *)recognizer
{
    [self.delegate pannedVertical:recognizer];
}

- (void)pannedHorizontal: (UIPanGestureRecognizer *)recognizer
{
    [self.delegate pannedHorizontal:recognizer];
}

- (void)updateImageView
{
    self.imageView.image = [self.image applyBlurWithRadius:2.0 iterationsCount:self.blurValue tintColor:[UIColor colorWithWhite:0.11 alpha:self.darkenValue] saturationDeltaFactor:1.8 maskImage:nil];
}

- (CGRect)getFrameInView:(UIView *)view
{
    CGPoint convertedPoint = [self convertPoint:self.frame.origin toView:view];
    return CGRectMake(convertedPoint.x, convertedPoint.y, self.frame.size.width, self.frame.size.height);
}

- (void) updateImageEffectLabelWithText: (NSString *)text hidden: (BOOL)hidden
{
    self.imageEffectLabel.text = text;
    self.imageEffectLabel.hidden = hidden;
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
