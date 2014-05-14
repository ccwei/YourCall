//
//  MenuTableViewController.m
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/10/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import "MenuTableViewController.h"
#import "ECSlidingViewController.h"
#import "SignInViewController.h"

@interface MenuTableViewController () <UITableViewDelegate>

@end

@implementation MenuTableViewController

- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue {

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"Sign Out"]) {
        [RegistrationService signOut];
        ECSlidingViewController *svc = (ECSlidingViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
        UINavigationController *controller = (UINavigationController *)[svc topViewController];
        [svc resetTopViewAnimated:YES onComplete:^{
            [controller popToRootViewControllerAnimated:YES];
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *nav = segue.destinationViewController;
    SignInViewController *signInVC = (SignInViewController* )nav.topViewController;
    if ([segue.identifier isEqualToString:@"SideToFeedsSegue"]) {
         signInVC.destinationSegueIdentifier = @"FeedCollectionViewControllerSegue";
    } else if ([segue.identifier isEqualToString:@"SideToMyFeedsSegue"])
    {
        signInVC.destinationSegueIdentifier = @"MyFeedCollectionViewControllerSegue";
    }
}


@end
