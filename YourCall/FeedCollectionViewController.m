//
//  FeedCollectionViewController.m
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/3/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import "FeedCollectionViewController.h"
#import "FeedCompositionView.h"

@interface FeedCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray *feeds;
@end

@implementation FeedCollectionViewController

- (void) awakeFromNib
{
    [[DataRepository sharedManager] allFeeds: ^(NSArray *feeds) {
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[FeedCollectionViewCell class] forCellWithReuseIdentifier:@"FeedCell"];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.feeds count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FeedCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FeedCell" forIndexPath:indexPath];
    cell.feed = self.feeds[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Deselect item
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.collectionView.frame.size;
}


- (void)tappedFirstImage:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    FeedCollectionViewCell *selectedCell = (FeedCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    if ([selectedCell.feed voteFirst]) {
        selectedCell.imageViewFirst.layer.masksToBounds = YES;
        [selectedCell.imageViewFirst.layer setBackgroundColor:[[UIColor redColor] CGColor]];
        [selectedCell.imageViewFirst.layer setBorderWidth:4.0];
        [selectedCell.imageViewSecond.layer setBorderWidth:0];
    } else {
        [selectedCell.imageViewFirst.layer setBorderWidth:0];
    }
}

- (void)tappedSecondImage:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    FeedCollectionViewCell *selectedCell = (FeedCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if ([selectedCell.feed voteSecond]) {
        selectedCell.imageViewSecond.layer.masksToBounds = YES;
        [selectedCell.imageViewSecond.layer setBackgroundColor:[[UIColor redColor] CGColor]];
        [selectedCell.imageViewSecond.layer setBorderWidth:4.0];
        [selectedCell.imageViewFirst.layer setBorderWidth:0];
    } else {
        [selectedCell.imageViewSecond.layer setBorderWidth:0];
    }
}

- (IBAction)unwindToFeedCollectionViewController:(UIStoryboardSegue *)unwindSegue
{
    UIViewController* sourceViewController = unwindSegue.sourceViewController;

    if ([sourceViewController isKindOfClass:[CreateNewViewController class]]) {
        CreateNewViewController *vc = (CreateNewViewController *)sourceViewController;
        if (vc.isCanceled) {
            return;
        }
        FeedCompositionView *firstView = vc.feedCompositionViews[0];
        FeedCompositionView *secondView = vc.feedCompositionViews[1];
        
        Feed *feed = [[Feed alloc] init];
        feed.imageFirst = firstView.imageView.image;
        feed.imageSecond = secondView.imageView.image;
        feed.descriptionFirst = firstView.textView.text;
        feed.descriptionSecond = secondView.textView.text;
        [feed save];
    }
    
}
- (IBAction)refresh:(id)sender {
    [[DataRepository sharedManager] allFeeds: ^(NSArray *feeds) {
        [self.collectionView reloadData];
    }];
}

@end
