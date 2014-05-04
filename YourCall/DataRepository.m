//
//  DataRepository.m
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/3/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import "DataRepository.h"

@interface DataRepository()
@end

@implementation DataRepository

-(NSArray *)feeds
{
    if (!_feeds) {
        _feeds = [[NSMutableArray alloc] init];
    }
    return _feeds;
}

- (void) getAllFeeds: (void (^)(NSArray *))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://thisisyourcall.azurewebsites.net/api/FeedsApi"]];
    [request addValue:@"Bearer qlE9vh3K1qfj8I6ZlqpZQ-3sH0S6O5r6SBWkYNDxnY5hpkbiMy5AlYKndnVK9TAZRgqeRN01h95bkCtrTITOgZNRvouqUTuaS-YQi0ttCU-S_2gw8Pn1eb_f10lgLdJ_2YJa_QPmQLxqp3Q8AfBUzCjRjjLiTEGUcSVjZbagvAB_96rWcgdguHhQr2Tx5QQh1rR_t5AZIgSFvUDrvvPoaoNUd8RvS_x04P77j0RiC1Roe0lTkszv4YgTaLgOE0kSQoqZYMWS-pPGbuPMHQZaBl-wIw9ClXQNOeC1qGco5zbc7G6rgXOf49OEyO9tJz5KpWen1iOdprLgZAlH7jMiKREkLcV3uYL4EIzDaEozwM1NuhdRP_MEXvK-EUuhckRCIbRBUF4w3Rl5-HcBvGIEFy2l-50e-Kg_QK_3ah9HDWgapt-xPxuDPNs4-nd31Il4KnnA_VCailMm78lvtIAkR7Mmesxbk45ddTe2UhhftgE" forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSArray *feeds = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                               
                               
                               for (NSObject* feedObj in feeds) {
                                   Feed *feed = [[Feed alloc] init];
                                   feed.feedId = [[feedObj valueForKeyPath:@"Id"] intValue];
                                   feed.description = [feedObj valueForKeyPath:@"Description"];
                                   feed.imageUrl = [feedObj valueForKeyPath:@"ImageUrl"];
                                   feed.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:feed.imageUrl]]];
                                   [self.feeds addObject: feed];
                               }
                               NSLog(@"%@", self.feeds);
                               if (completionBlock) {
                                   [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                                       completionBlock(self.feeds);
                                   }];
                               }
                           }];
}
@end
