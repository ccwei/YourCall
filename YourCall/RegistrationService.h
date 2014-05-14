//
//  RegistrationService.h
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/11/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegistrationService : NSObject
+ (void)signInWithEmail:(NSString *)email withPassword:(NSString *)password completionBlock:(void (^)(NSDictionary *))completionBlock;
+ (void)signUpWithEmail:(NSString *)email withPassword:(NSString *)password completionBlock:(void (^)(NSDictionary *))completionBlock;
+ (void)signOut;
@end
