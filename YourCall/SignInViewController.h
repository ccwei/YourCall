//
//  SignInViewController.h
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/11/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistrationService.h"

@interface SignInViewController : UIViewController
@property (nonatomic, strong) NSString* destinationSegueIdentifier;
- (IBAction)unwindToSignInController:(UIStoryboardSegue *)segue;
@end
