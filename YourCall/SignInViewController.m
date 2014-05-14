//
//  SignInViewController.m
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/11/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *errorSignIn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@end

@implementation SignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"accessToken"]) {
        NSString* destination = self.destinationSegueIdentifier ? self.destinationSegueIdentifier : @"FeedCollectionViewControllerSegue";
        [self performSegueWithIdentifier:destination sender:self];
    }
    
    self.email.delegate = self;
    self.password.delegate = self;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}

-(void)dismissKeyboard
{
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signinButtonClicked:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:self.email.text forKey:@"userEmail"];
    
    [RegistrationService signInWithEmail:self.email.text withPassword:self.password.text completionBlock:^(NSDictionary *response) {
        NSLog(@"%@", response);
        if ([response objectForKey:@"access_token"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.errorSignIn.hidden = YES;
                [userDefaults setObject:[response objectForKey:@"access_token"] forKey:@"accessToken"];
                [self performSegueWithIdentifier:@"FeedCollectionViewControllerSegue" sender:self];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.password.text = @"";
                self.errorSignIn.hidden = NO;
            });}
    }];
    [userDefaults synchronize];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.password]) {
        [self signinButtonClicked:nil];
    }
    return YES;
}

- (void)keyboardWasShown:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGPoint buttonOrigin = self.signInButton.frame.origin;
    buttonOrigin.y = buttonOrigin.y + self.scrollView.frame.origin.y;
    CGFloat buttonHeight = self.signInButton.frame.size.height;
    CGRect visibleRect = self.view.frame;
    
    visibleRect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(visibleRect, buttonOrigin)){
        CGPoint scrollPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
    
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

- (IBAction)unwindToSignInController:(UIStoryboardSegue *)segue {
    
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
