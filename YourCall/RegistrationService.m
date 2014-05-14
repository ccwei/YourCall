//
//  RegistrationService.m
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/11/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import "RegistrationService.h"

@implementation RegistrationService
+ (NSString *)hostName
{
    return @"http://thisisyourcall.azurewebsites.net";
}

+ (void)signUpWithEmail:(NSString *)email withPassword:(NSString *)password completionBlock:(void (^)(NSDictionary *))completionBlock
{
    NSString *queryString = [NSString stringWithFormat:@"email=%@&password=%@&confirmpassword=%@", email, password, password];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/account/register", self.hostName]]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: [queryString dataUsingEncoding:NSUTF8StringEncoding]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[[NSOperationQueue alloc] init]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   if (completionBlock) {
                                       completionBlock([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
                                   }
                                   /*NSLog(@"response = %@, error = %@", [NSString stringWithUTF8String:[data bytes]], connectionError);*/
                               }];
    });
}

+ (void)signInWithEmail:(NSString *)email withPassword:(NSString *)password completionBlock:(void (^)(NSDictionary *))completionBlock
{
    NSString *queryString = [NSString stringWithFormat:@"grant_type=password&username=%@&password=%@", email, password];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Token", self.hostName]]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: [queryString dataUsingEncoding:NSUTF8StringEncoding]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[[NSOperationQueue alloc] init]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   if (completionBlock) {
                                       completionBlock([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
                                   }
                                   /*NSLog(@"response = %@, error = %@", [NSString stringWithUTF8String:[data bytes]], connectionError);*/
                               }];
    });
}

+ (void)signOut
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"accessToken"];
}
@end
