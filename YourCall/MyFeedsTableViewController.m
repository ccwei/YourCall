//
//  MyFeedsTableViewController.m
//  YourCall
//
//  Created by Chih-Chiang Wei on 5/10/14.
//  Copyright (c) 2014 Chih-Chiang Wei. All rights reserved.
//

#import "MyFeedsTableViewController.h"

@interface MyFeedsTableViewController ()
@property (nonatomic, strong) NSArray *feeds;
@end

@implementation MyFeedsTableViewController

- (void) awakeFromNib
{
    [[DataRepository sharedManager] myFeeds: ^(NSArray *feeds) {
        self.feeds = feeds;
        [self.tableView reloadData];
    }];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.feeds count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedTableViewCell" forIndexPath:indexPath];
    UIImageView *firstImageView, *secondImageView;
    UILabel *voteFirstLabel, *voteSecondLabel;
    
    Feed *selectedFeed = self.feeds[indexPath.row];
    firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(150, 0, 100, 100)];
    
    voteFirstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 100, 100)];
    voteSecondLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 80, 100, 100)];
    
    voteFirstLabel.text = [NSString stringWithFormat:@"%d", selectedFeed.numberOfVoteFirst];
    voteSecondLabel.text = [NSString stringWithFormat:@"%d", selectedFeed.numberOfVoteSecond];
    
    [selectedFeed getImageFirst:^(UIImage* image) {
        firstImageView.image = image;
        [cell setNeedsDisplay];
    }];
    
    [selectedFeed getImageSecond:^(UIImage* image) {
        secondImageView.image = image;
        [cell setNeedsDisplay];
    }];
    
    [cell.contentView addSubview:firstImageView];
    [cell.contentView addSubview:secondImageView];
    [cell.contentView addSubview:voteFirstLabel];
    [cell.contentView addSubview:voteSecondLabel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.0;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
