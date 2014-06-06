//
//  CreateNewFeedViewController.m
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/10/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import "CreateNewFeedViewController.h"

@interface CreateNewFeedViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) int currentEditingCompositionViewIndex;
@end

@implementation CreateNewFeedViewController

- (UIImagePickerController *) imagePicker
{
    if(!_imagePicker)
    {
        _imagePicker = [[UIImagePickerController alloc] init];
    }
    return _imagePicker;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)presentImagePicker
{
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    FeedCompositionView *currentView = self.feedCompositionViews[self.currentEditingCompositionViewIndex];
    currentView.image = chosenImage;
    currentView.imageView.image = chosenImage;
    currentView.textColor = [UIColor whiteColor];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)setupFeedCompositionViews
{
    NSArray *bundleObjects;
    FeedCompositionView *feedCompositionView;
    NSMutableArray *tempViews = [NSMutableArray arrayWithCapacity:self.feedCompositionViews.count];
    int index = 0;
    for (UIView *currentWrapperView in self.feedCompositionViews) {
        bundleObjects = [[NSBundle mainBundle] loadNibNamed:@"FeedCompositionView" owner:self options:nil];
        for (id object in bundleObjects) {
            if ([object isKindOfClass:[FeedCompositionView class]]){
                feedCompositionView = (FeedCompositionView *)object;
                break;
            }
        }
        [feedCompositionView.addPictureButton addTarget:self action:@selector(uploadImageClicked:) forControlEvents:UIControlEventTouchUpInside];
        feedCompositionView.addPictureButton.tag = index;
        feedCompositionView.tag = index;
        feedCompositionView.delegate = self;
        [currentWrapperView addSubview:feedCompositionView];
        
        [tempViews addObject:feedCompositionView];
        index++;
    }
    self.feedCompositionViews = tempViews;
}

- (void)setupGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupFeedCompositionViews];
    [self setupGestureRecognizer];
}

- (void)uploadImageClicked: (UIButton *)button
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Take Photo",
                            @"Choose from Library",
                            nil];
    self.currentEditingCompositionViewIndex = button.tag;
    [actionSheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentImagePicker];
            break;
        case 1:
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentImagePicker];
        default:
            break;
    }
}

- (IBAction)cancel
{
    self.isCanceled = YES;
    [self performSegueWithIdentifier:@"UnwindToFeedCVC" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark FeedCompositionViewProtocol

- (FeedCompositionView *)getCurrentTouchedView: (UIPanGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:self.view];
    
    FeedCompositionView *currentView;
    for (FeedCompositionView *feedCompositionView in self.feedCompositionViews) {
        if (CGRectContainsPoint([feedCompositionView getFrameInView:self.view], touchPoint)) {
            currentView = feedCompositionView;
            break;
        }
    }
    return currentView;
}

- (void)pannedHorizontal:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    FeedCompositionView *currentView = [self getCurrentTouchedView:recognizer];
    
    if (translation.x > 0) {
        currentView.blurValue += 1;
    } else {
        currentView.blurValue -= 1;
    }
    
    BOOL hideImageEffectLabel = (recognizer.state == UIGestureRecognizerStateEnded||
                                 recognizer.state == UIGestureRecognizerStateCancelled ||
                                 recognizer.state == UIGestureRecognizerStateFailed);
    [currentView updateImageEffectLabelWithText:[NSString stringWithFormat:@"Blur %d%%",currentView.blurValue * 10] hidden:hideImageEffectLabel];
}

- (void)pannedVertical:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    FeedCompositionView *currentView = [self getCurrentTouchedView:recognizer];
    
    if (translation.y > 0) {
        currentView.darkenValue += 0.05;
    } else {
        currentView.darkenValue -= 0.05;
    }
    int darkenPercentage = [[NSNumber numberWithFloat:currentView.darkenValue * 100] intValue];
    BOOL hideImageEffectLabel = (recognizer.state == UIGestureRecognizerStateEnded||
                                 recognizer.state == UIGestureRecognizerStateCancelled ||
                                 recognizer.state == UIGestureRecognizerStateFailed);
    [currentView updateImageEffectLabelWithText:[NSString stringWithFormat:@"Dim %d%%", darkenPercentage] hidden:hideImageEffectLabel];
}


#pragma mark KeyBoardNotifications
- (void)dismissKeyboard
{
    for (FeedCompositionView *view in self.feedCompositionViews) {
        [view.textView resignFirstResponder];
    }
}

- (void)keyboardWasShown:(NSNotification *)notification {
    
    FeedCompositionView *lowerView = self.feedCompositionViews[1];
    if (![lowerView.textView isFirstResponder]) {
        return;
    }
    
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGPoint scrollPoint = CGPointMake(0.0, keyboardSize.height);
    [self.scrollView setContentOffset:scrollPoint animated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    
}

- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)deregisterFromKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self deregisterFromKeyboardNotifications];
    
    [super viewWillDisappear:animated];
    
}
@end
