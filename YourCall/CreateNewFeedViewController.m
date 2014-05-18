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

- (void)presentImagePicker{
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}

- (IBAction)firstImageClicked:(UITapGestureRecognizer *)sender {
 
    [self presentImagePicker];
    
}

- (IBAction)secondImageClicked:(UITapGestureRecognizer *)sender {
    [self presentImagePicker];
    self.currentEditingCompositionViewIndex = 1;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    FeedCompositionView *currentView = self.feedCompositionViews[self.currentEditingCompositionViewIndex];
    currentView.image = chosenImage;
    currentView.imageView.image = chosenImage;
    currentView.textColor = [UIColor whiteColor];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *bundleObjects;
    FeedCompositionView *currView;
    NSMutableArray *myViews = [NSMutableArray arrayWithCapacity:self.feedCompositionViews.count];
    int index = 0;
    for (UIView *currWrapperView in self.feedCompositionViews) {
        bundleObjects = [[NSBundle mainBundle] loadNibNamed:@"FeedCompositionView" owner:self options:nil];
        for (id object in bundleObjects) {
            if ([object isKindOfClass:[FeedCompositionView class]]){
                currView = (FeedCompositionView *)object;
                break;
            }
        }
        [currView.addPictureButton addTarget:self action:@selector(uploadImageClicked:) forControlEvents:UIControlEventTouchUpInside];
        currView.addPictureButton.tag = index;
        currView.tag = index;
        currView.delegate = self;
        [currWrapperView addSubview:currView];
        
        [myViews addObject:currView];
        index++;
    }
    self.feedCompositionViews = myViews;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view.
}

- (void)dismissKeyboard
{
    for (FeedCompositionView *view in self.feedCompositionViews) {
        [view.textView resignFirstResponder];
    }
}

- (void)uploadImageClicked: (UIButton *)button
{
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Take Photo",
                            @"Choose from Library",
                            nil];
    self.currentEditingCompositionViewIndex = button.tag;
    [popup showInView:self.view];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel
{
    self.isCanceled = YES;
    [self performSegueWithIdentifier:@"UnwindToFeedCVC" sender:self];
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

- (void)pannedHorizontal:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    FeedCompositionView *currentView = [self getCurrentTouchedView:recognizer];
    
    if (translation.x > 0) {
        currentView.blurValue += 1;
    } else {
        currentView.blurValue -= 1;
    }
    currentView.imageEffectLabel.text = [NSString stringWithFormat:@"Blur %d%%",currentView.blurValue * 10];
    
    [self applyImageEffect:recognizer];
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
    NSNumber *darkenPercentage = [NSNumber numberWithFloat:currentView.darkenValue * 100];
    currentView.imageEffectLabel.text = [NSString stringWithFormat:@"Dim %d%%", [darkenPercentage intValue]];
    [self applyImageEffect:recognizer];
}

- (void)applyImageEffect: (UIPanGestureRecognizer*)recognizer
{
    FeedCompositionView *currentView = [self getCurrentTouchedView:recognizer];
    
    if (recognizer.state == UIGestureRecognizerStateEnded||
        recognizer.state == UIGestureRecognizerStateCancelled ||
        recognizer.state == UIGestureRecognizerStateFailed) {
        currentView.imageEffectLabel.hidden = YES;
    } else {
        currentView.imageEffectLabel.hidden = NO;
    }
    
    currentView.imageView.image = [currentView.image applyBlurWithRadius:2.0 iterationsCount:currentView.blurValue tintColor:[UIColor colorWithWhite:0.11 alpha:currentView.darkenValue] saturationDeltaFactor:1.8 maskImage:nil];
}

- (FeedCompositionView *)getCurrentTouchedView: (UIPanGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:self.view];
    
    FeedCompositionView *firstView = self.feedCompositionViews[0];
    FeedCompositionView *secondView = self.feedCompositionViews[1];
    FeedCompositionView *currentView;
    
    if (CGRectContainsPoint(firstView.frame, touchPoint)) {
        currentView = firstView;
    } else {
        currentView = secondView;
    }
    
    return currentView;
}

@end
