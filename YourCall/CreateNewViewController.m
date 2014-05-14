//
//  CreateNewViewController.m
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/10/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import "CreateNewViewController.h"
#import "FeedCompositionView.h"

@interface CreateNewViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) UIImagePickerController *picker;
@property int currentImageIndex;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation CreateNewViewController


- (UIImagePickerController *) picker
{
    if(!_picker)
    {
        _picker = [[UIImagePickerController alloc] init];
    }
    
    return _picker;
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
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;
    [self presentViewController:self.picker animated:YES completion:NULL];
}

- (IBAction)firstImageClicked:(UITapGestureRecognizer *)sender {
 
    [self presentImagePicker];
    
}

- (IBAction)secondImageClicked:(UITapGestureRecognizer *)sender {
    [self presentImagePicker];
    self.currentImageIndex = 1;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    FeedCompositionView *currentView = self.feedCompositionViews[self.currentImageIndex];
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
    popup.tag = 1;
    self.currentImageIndex = button.tag;
    [popup showInView:self.view];
}


- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentImagePicker];
            break;
        case 1:
            self.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
