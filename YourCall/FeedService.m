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
                               for (NSDictionary* feedData in feedsData) {
                                   Feed *feed = [Feed createFeed:feedData];
                                   [feeds addObject: feed];
                               }
                               if (completionBlock) {
                                   [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                                       completionBlock(feeds);
                                   }];
                               }
                           }];
}

+ (void)voteFeed:(int)feedId withItem:(FeedItemIndices)item isUnvote:(BOOL)unvote completionBlock:(void (^)())completionBlock
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

+ (void)postFeed:(Feed *)feed
{
    FeedItem *firstItem = [feed.feedItems firstObject];
    FeedItem *secondItem = [feed.feedItems lastObject];
   NSDictionary *dict = @{
                           @"Feed": @{
                                     @"DescriptionFirst": firstItem.description,
                                     @"DescriptionSecond": secondItem.description
                                     },
                           @"imageFirstBase64": [UIImageJPEGRepresentation(firstItem.image, 1.0) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength],
                           @"imageSecondBase64": [UIImageJPEGRepresentation(secondItem.image, 1.0) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]
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
@end
