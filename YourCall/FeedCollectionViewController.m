//
//  FeedCollectionViewController.m
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/3/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import "FeedCollectionViewController.h"
#import "FeedCompositionView.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MEZoomAnimationController.h"

@interface FeedCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray *feeds;
@property (nonatomic, strong) MEZoomAnimationController *zoomAnimationController;
@end

@implementation FeedCollectionViewController

- (MEZoomAnimationController *)zoomAnimationController
{
    if (!_zoomAnimationController) {
        _zoomAnimationController = [[MEZoomAnimationController alloc] init];
    }
    return _zoomAnimationController;
}

- (void) awakeFromNib
{
    [[DataRepository getInstance] allFeeds: ^(NSArray *feeds) {
        self.feeds = feeds;
        [self.collectionView reloadData];
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)registerCollectionViewCell
{
    UINib *cellNib = [UINib nibWithNibName:@"CollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"Cell"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerCollectionViewCell];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.slidingViewController.delegate = self.zoomAnimationController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.feeds count];
}

- (FeedCollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FeedCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.feed = self.feeds[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.delegate = self;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.collectionView.frame.size;
}

- (void)tapped:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    FeedCollectionViewCell *selectedCell = (FeedCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    FeedItemView *selectedView;
    for (FeedItemView *feedItemView in selectedCell.feedItemViews) {
        if (CGRectContainsPoint([feedItemView getFrameInView:self.collectionView], location)) {
            selectedView = feedItemView;
            break;
        }
    }
    
    int selectedFeedItemIndex = [selectedCell.feedItemViews indexOfObject:selectedView];
    
    if (selectedCell.feed.votedFeedItemIndex == None) {
        [selectedCell.feed vote:selectedFeedItemIndex completionBlock:^{
            [self updateVoteImage:selectedCell];
        }];
    } else {
        if (selectedCell.feed.votedFeedItemIndex == selectedFeedItemIndex) {
            [selectedCell.feed unvote:selectedFeedItemIndex completionBlock:^{
                [self updateVoteImage:selectedCell];
            }];
        } else {
            [selectedCell.feed unvote:[selectedCell.feed getToggledIndex:selectedFeedItemIndex] completionBlock:^{
                [selectedCell.feed vote:selectedFeedItemIndex completionBlock:^{
                    [self updateVoteImage:selectedCell];
                }];
            }];
        }
    }
}

- (void) updateVoteImage: (FeedCollectionViewCell *)selectedCell
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (selectedCell.feed.votedFeedItemIndex == None) {
            selectedCell.voteImageView.hidden = YES;
            return;
        }
        
        FeedItemView *votedView = [selectedCell.feedItemViews objectAtIndex:selectedCell.feed.votedFeedItemIndex];
        CGPoint origin = [votedView getFrameInView:self.view].origin;
        [UIView animateWithDuration:1.0f
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             selectedCell.voteImageView.hidden = NO;
                             selectedCell.voteImageView.frame = CGRectMake(origin.x, origin.y, 50, 50);
                         }
                         completion:nil];
        
    });
}

- (IBAction)unwindToFeedCollectionViewController:(UIStoryboardSegue *)unwindSegue
{
    UIViewController* sourceViewController = unwindSegue.sourceViewController;

    if ([sourceViewController isKindOfClass:[CreateNewFeedViewController class]]) {
        CreateNewFeedViewController *vc = (CreateNewFeedViewController *)sourceViewController;
        if (vc.isCanceled) {
            return;
        }
        Feed *feed = [[Feed alloc] init];
        
        for (FeedCompositionView *compositionView in vc.feedCompositionViews) {
            FeedItem *feedItem = [[FeedItem alloc] init];
            feedItem.image = compositionView.imageView.image;
            feedItem.description = compositionView.textView.text;
            [feed addFeedItem:feedItem];
        }
        [feed save];
    }
}

- (IBAction)refresh:(id)sender {
    [[DataRepository getInstance] allFeeds: ^(NSArray *feeds) {
        [self.collectionView reloadData];
    }];
}

@end
