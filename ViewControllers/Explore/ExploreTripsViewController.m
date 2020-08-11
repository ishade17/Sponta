//
//  ExploreTripsViewController.m
//  Sponta
//
//  Created by Isaac Schaider on 7/25/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "ExploreTripsViewController.h"
#import "ExploreTripsCell.h"
#import "Post.h"
#import "JoinLeaveTrip.h"
#import "GuestProfilePicCell.h"
#import "NonCurrentProfileViewController.h"

@interface ExploreTripsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ExploreTripsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postsArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ExploreTripsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ExploreTripsCell"];
    Post *post = self.postsArray[indexPath.row];
    cell.post = post;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    [cell updateCollectionView];
    [self configureEasyCellFields:cell withPost:post];
    [self configureCellProfilePic:cell withPost:post];
    [self configureCellDate:cell withPost:post];
    [self configureCellAddress:cell withPost:post];
    [self configureCellButton:cell withPost:post];
    
    [cell.addGuestButton addTarget:self action:@selector(joinLeaveTrip:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)configureEasyCellFields:(ExploreTripsCell *)cell withPost:(Post *)post {
    cell.tripTitleLabel.text = post.title;
    [cell.usernameLabel setTitle:post.author.username forState:UIControlStateNormal];
    cell.descriptionLabel.text = post.tripDescription;
    cell.spotsFilledLabel.text = [NSString stringWithFormat:@"%lu / %@", (unsigned long)post.guestList.count, post.spots];
    [post.previewImage getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        cell.previewImageView.image = [UIImage imageWithData:data];
    }];
}

- (void)configureCellProfilePic:(ExploreTripsCell *)cell withPost:(Post *)post {
    cell.profilePicImageView.layer.cornerRadius = cell.profilePicImageView.frame.size.height / 2;
    [cell.profilePicImageView.layer setBorderColor: [[UIColor systemBlueColor] CGColor]];
    [cell.profilePicImageView.layer setBorderWidth: 1.0];
    cell.profilePicImageView.file = [post.author objectForKey:@"profileImage"];
    [cell.profilePicImageView loadInBackground];
}

- (void)configureCellDate:(ExploreTripsCell *)cell withPost:(Post *)post {
    NSArray *daysOfWeek = @[@"",@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
    NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:post.tripDate];
    cell.timeDateLabel.text = [NSString stringWithFormat:@"%@ – %@ on %@", post.startTime, post.endTime, [daysOfWeek objectAtIndex:weekday]];
}

- (void)configureCellAddress:(ExploreTripsCell *)cell withPost:(Post *)post {
    NSArray *chunks = [post.address componentsSeparatedByString: @", "];
    [(NSMutableArray *)chunks removeObjectAtIndex: chunks.count - 1];
    NSString *addressTitle = [chunks componentsJoinedByString:@", "];
    cell.addressLabel.text = [[NSString stringWithFormat:@"%@", addressTitle] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)configureCellButton:(ExploreTripsCell *)cell withPost:(Post *)post {
    cell.addGuestButton.titleLabel.textColor = [UIColor whiteColor];
    cell.addGuestButton.backgroundColor = [UIColor systemBlueColor];
    [cell.addGuestButton setTitle:@"Join Trip" forState:UIControlStateNormal];
    cell.spotsFilledIcon.tintColor = [UIColor systemGrayColor];
    cell.spotsFilledLabel.textColor = [UIColor systemGrayColor];
    for (PFUser *guest in post.guestList) {
        if ([guest.objectId isEqual:PFUser.currentUser.objectId]) {
            cell.addGuestButton.backgroundColor = [UIColor whiteColor];
            cell.addGuestButton.layer.borderColor = [[UIColor systemGrayColor] CGColor];
            cell.addGuestButton.layer.borderWidth = 1.0;
            [cell.addGuestButton setTitleColor:[UIColor systemGrayColor] forState:UIControlStateNormal];
            [cell.addGuestButton setTitle:@"Leave Trip" forState:UIControlStateNormal];
            [cell.spotsFilledIcon setBackgroundImage:[UIImage systemImageNamed:@"person.3.fill"] forState:UIControlStateNormal];
            cell.spotsFilledIcon.tintColor = [UIColor systemBlueColor];
            cell.spotsFilledLabel.textColor = [UIColor systemBlueColor];
        }
    }
}

- (IBAction)joinLeaveTrip:(id)sender {
    UIButton *button = (UIButton *)sender;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil) {
        Post *post = self.postsArray[indexPath.row];
        ExploreTripsCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [JoinLeaveTrip joinLeaveTrip:post withLabel:cell.spotsFilledLabel withButton:button withIcon:cell.spotsFilledIcon];
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toNonCurrentProfile"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.postsArray[indexPath.row];
        
        NonCurrentProfileViewController *nonCurrentProfileViewController = [segue destinationViewController];
        nonCurrentProfileViewController.profUser = post.author;
    }
}



@end
