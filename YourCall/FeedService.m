//
//  FeedService.m
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/4/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import "FeedService.h"

@interface FeedService()
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *hostName;
@end

@implementation FeedService
+ (NSString *)accessToken
{
    //return @"dWnC7jlqltW5nUBlIShUPkjOtBLwJAHXxOwcNSzxLH15L4hi80nhrscwoPQMDMZp-Qx64vbGh5UJllLsUhhC8ASqWFhDiy7WHk31LYO54toTjkGMyfMJKVBc6kpwi16XaBYS-qPCEbt18_uF1zKIHHNEOLo4gn44runcYtA3beVkYrIj-MYmre5yIgb-r_ypruB3I9W2DD6DjHCUUp1Ntyjc1-tR9_uzB59kgbe4nKJjsAIbAD_j086TZh5EevUzyVie8HsbGuNjRHt1Y_ZZmhLHswxU0PezZQs7W3Qb012Ty1dxOR2r0sG8Ykwl1Csw995cJqZUsiv7ojClp7IRe7j1p6ybFP7Gmxnqb4kce5uGBABmBOyVuDPauS-iYbLRwUngxfqzpfEYk2896Krb1HqDI6EzNC5rRsUryk8zid4qSMjz_MUQOQwk_kqQ0RU6Z2kVBJW_QSTM9ypOhM3kgnU5U7nyvQRjsecyL8W5hqc";
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
}

+ (NSString *)hostName
{
    return @"http://thisisyourcall.azurewebsites.net";
}

+ (void) getMyFeeds: (void (^)(NSArray *))completionBlock
{
    [self getFeedsWithUrl:[NSString stringWithFormat:@"%@/api/FeedsApi/me", self.hostName] completionBlock:completionBlock];
}

+ (void) getAllFeeds: (void (^)(NSArray *))completionBlock
{
    [self getFeedsWithUrl:[NSString stringWithFormat:@"%@/api/FeedsApi", self.hostName] completionBlock:completionBlock];
}

+ (void) getFeedsWithUrl: (NSString *)url completionBlock: (void (^)(NSArray *))completionBlock
{
    NSLog(@"Request url = %@", url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSArray *feedsData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                               NSMutableArray *feeds = [[NSMutableArray alloc] init];
                               for (NSObject* feedObj in feedsData) {
                                   Feed *feed = [[Feed alloc] init];
                                   feed.feedId = [[feedObj valueForKeyPath:@"Id"] intValue];
                                   feed.descriptionFirst = [feedObj valueForKeyPath:@"DescriptionFirst"];
                                   feed.imageUrlFirst = [feedObj valueForKeyPath:@"ImageUrlFirst"];
                                   feed.descriptionSecond = [feedObj valueForKeyPath:@"DescriptionSecond"];
                                   feed.imageUrlSecond = [feedObj valueForKeyPath:@"ImageUrlSecond"];
                                   feed.numberOfVoteFirst = ![[feedObj valueForKeyPath:@"VoteFirst"] isEqual: [NSNull null]] ? [[feedObj valueForKeyPath:@"VoteFirst"] intValue] : 0;
                                   feed.numberOfVoteSecond = ![[feedObj valueForKeyPath:@"VoteSecond"] isEqual:[NSNull null]] ? [[feedObj valueForKeyPath:@"VoteSecond"] intValue] : 0;
                                   [feeds addObject: feed];
                               }
                               if (completionBlock) {
                                   [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                                       completionBlock(feeds);
                                   }];
                               }
                           }];
}

+ (void)voteFeed:(int)feedId withItem:(VoteItem)item isUnvote:(BOOL)unvote completionBlock:(void (^)())completionBlock
{
    NSString *voteUrlStr;
    if (!unvote) {
        if (item == First) {
            voteUrlStr = [NSString stringWithFormat:@"%@/api/FeedsApi/%d/votefirst",self.hostName, feedId];
        } else {
            voteUrlStr = [NSString stringWithFormat:@"%@/api/FeedsApi/%d/votesecond",self.hostName, feedId];
        }
    } else {
        if (item == First) {
            voteUrlStr = [NSString stringWithFormat:@"%@/api/FeedsApi/%d/unvotefirst",self.hostName, feedId];
        } else {
            voteUrlStr = [NSString stringWithFormat:@"%@/api/FeedsApi/%d/unvotesecond",self.hostName, feedId];
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:voteUrlStr]];
        [request addValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
        [request setHTTPMethod:@"PUT"];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[[NSOperationQueue alloc] init]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   if (completionBlock) {
                                       completionBlock();
                                   }
                                   NSLog(@"url = %@, data = %@, error = %@", voteUrlStr, data, connectionError);
                               }];
    });
    
}

+ (void)voteFirst: (int) feedId completionBlock:(void (^)())completionBlock
{
    [self voteFeed:feedId withItem:First isUnvote:NO completionBlock:completionBlock];
}

+ (void)voteSecond: (int) feedId completionBlock:(void (^)())completionBlock
{
    [self voteFeed:feedId withItem:Second isUnvote:NO completionBlock:completionBlock];
}

+ (void)unvoteFirst: (int) feedId completionBlock:(void (^)())completionBlock
{
    [self voteFeed:feedId withItem:First isUnvote:YES completionBlock:completionBlock];
}

+ (void)unvoteSecond: (int) feedId completionBlock:(void (^)())completionBlock
{
    [self voteFeed:feedId withItem:Second isUnvote:YES completionBlock:completionBlock];
}

+ (void)createFeed:(Feed *)feed
{
    NSDictionary *dict = @{
                           @"Feed": @{
                                     @"DescriptionFirst": feed.descriptionFirst,
                                     @"DescriptionSecond": feed.descriptionSecond
                                     },
                           @"imageFirstBase64": [UIImageJPEGRepresentation(feed.imageFirst, 1.0) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength],
                           @"imageSecondBase64": [UIImageJPEGRepresentation(feed.imageSecond, 1.0) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]
                          };
 
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSLog(@"data = %@", [NSString stringWithUTF8String:[jsonData bytes]]);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/FeedsApi", self.hostName]]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: jsonData];
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSLog(@"error = %@", connectionError);
                           }];
    });
}

/*
+ (void)createFeed:(Feed *) feed
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/FeedsApi", self.hostName]]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
 
    NSString* boundary = @"1QQS23testAA";
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[@"Test1", @"Test2"]
                                                       forKeys:@[@"DescriptionFirst", @"DescriptionFirst"]];
    
    // add params (all params are strings)
    for (NSString *param in params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    // add image data
    NSData *imageData = UIImageJPEGRepresentation(feed.imageFirst, 1.0);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"image1.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    // add image data
    imageData = UIImageJPEGRepresentation(feed.imageSecond, 1.0);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"image2.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[[NSOperationQueue alloc] init]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   NSLog(@"data = %@, error = %@", [NSString stringWithUTF8String:[data bytes]], connectionError);
                               }];
    });
}
*/
@end
