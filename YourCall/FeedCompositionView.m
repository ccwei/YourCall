//
//  FeedComposeView.m
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/13/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import "FeedCompositionView.h"

@interface FeedCompositionView() <UITextViewDelegate>

@end

static NSString *placeHolderString = @"Description for this item...";

@implementation FeedCompositionView 
@synthesize textColor = _textColor;
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
        self.maskView.alpha = 0.1f;
    }
}


- (void)awakeFromNib
{
    self.textView.delegate = self;
    self.textView.text = placeHolderString;
    self.textView.textColor =[UIColor lightGrayColor];
    self.textView.backgroundColor = [UIColor clearColor];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.0f;
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
        textView.textColor = self.textColor; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = placeHolderString;
        textView.textColor = [UIColor lightGrayColor]; //optional
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
