//
//  SignUpViewController.m
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/11/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UILabel *errorTextLabel;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@end

@implementation SignUpViewController

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
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signUpButtonClicked:(id)sender {
    
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [RegistrationService signUpWithEmail:self.email.text withPassword:self.password.text completionBlock:^(NSDictionary *response){
        if ([response objectForKey:@"Message"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *modelState = [response objectForKey:@"ModelState"];
                NSString *serverErrorMessage = [modelState objectForKey:@""][0];
                self.errorTextLabel.text = serverErrorMessage;
                self.errorTextLabel.hidden = NO;
            });
            
        } else {
            self.errorTextLabel.hidden = YES;
            
            [RegistrationService signInWithEmail:self.email.text withPassword:self.password.text completionBlock:^(NSDictionary *response) {
                NSLog(@"%@", response);
                if ([response objectForKey:@"access_token"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [userDefaults setObject:[response objectForKey:@"access_token"] forKey:@"accessToken"];
                        [self performSegueWithIdentifier:@"FeedCollectionViewControllerSegue" sender:self];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.password.text = @"";
                    });}
            }];
        }
        NSLog(@"%@", response);
    }];
}


-(void)dismissKeyboard
{
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.password]) {
        //[self signUpButton:nil];
    }
    return YES;
}

- (void)keyboardWasShown:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGPoint buttonOrigin = self.signUpButton.frame.origin;
    buttonOrigin.y = buttonOrigin.y + self.scrollView.frame.origin.y;
    CGFloat buttonHeight = self.signUpButton.frame.size.height;
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
