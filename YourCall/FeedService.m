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
    return @"3gfIRm1hycgekWIIMLamHBo_RQ14hK4toUnEr1-LH3KvDd6hHPjPvQfjARBcoP7ZXzVNP9Mj_6ScGFDcxCQ7R17g8CaARsEB0aQeC60ltccRXV_TUHXZrImtw-02nt8PfD9gwFuQ_QtnavQHlWsk_XKWCE7kVcUdS7TvlLP4F4pW6mxHErVJHWTPQcKRQJKJ3WPb4Z1PXGJeA0cpvyp9JSAShMbYVMou2Myf-vz-u1WWVDdfoWJbMeFvckYGwqz8LVQvRE6hOx_dICuK3aLyGGTiSJYnKdlUIo27ZuZjHVjUXjaiMdpTImSuBTZ7_pKRFYFhnNtC8WH50RdyFmo3hFjN7DSdr8hdWTk5bDFClrrUR_z6q77fPtNURZtV-eR2qMm4yvbgj7CTmFSEtd2vVTgZV0NPNoRy3qj0MPStqcdzRl0cQ8UEjaC1Xhz5_kKUF4iqR6YJHgnKc8PULoirmx50dxV5_-grLRlkCer22_Y";
}

+ (NSString *)hostName
{
    return @"http://thisisyourcall.azurewebsites.net";
}

+ (void) getAllFeeds: (void (^)(NSArray *))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/FeedsApi", self.hostName]]];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    
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
                                   [feeds addObject: feed];
                               }
                              if (completionBlock) {
                                   [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                                       completionBlock(feeds);
                                   }];
                               }
                           }];
}

+ (void)voteFeed:(int)feedId withItem:(VoteItem)item isUnvote:(BOOL)unvote
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
                                   NSLog(@"%@", data);
                               }];
    });
    
}

+ (void)voteFirst: (int) feedId
{
    [self voteFeed:feedId withItem:First isUnvote:NO];
}

+ (void)voteSecond: (int) feedId
{
    [self voteFeed:feedId withItem:Second isUnvote:NO];
}

+ (void)unvoteFirst: (int) feedId
{
    [self voteFeed:feedId withItem:First isUnvote:YES];
}

+ (void)unvoteSecond: (int) feedId
{
    [self voteFeed:feedId withItem:First isUnvote:YES];
}

@end
