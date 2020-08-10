//
//  ProfileViewController.m
//  Sponta
//
//  Created by Isaac Schaider on 7/27/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "ProfileViewController.h"
#import "PFImageView.h"
#import <Parse/Parse.h>
#import "ProfilePostCell.h"
#import "Post.h"
#import "ProfilePostDetailsViewController.h"
#import "SignInViewController.h"
#import "SceneDelegate.h"
#import "BookmarkedTripsViewController.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *friendsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripsHostedLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (weak, nonatomic) IBOutlet UIButton *bookmarksButton;
@property (nonatomic, strong) NSArray *userPosts;
@property (nonatomic, strong) NSMutableArray *bookmarkedTrips;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self configureEditButton];
    
    [self configureCollectionView];
    
    [self configureFriendCount];
    
    [self configureBookmarkCount];
}

- (void)viewWillAppear:(BOOL)animated {
    [self styleProfilePicture];
        
    [self configureUserFields];
    
    [self fetchUserPosts];
}

- (void)configureCollectionView {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = self.collectionView.frame.size.width / postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)styleProfilePicture {
    self.profilePicImageView.layer.cornerRadius = self.profilePicImageView.frame.size.height / 2;
    [self.profilePicImageView.layer setBorderColor: [[UIColor blueColor] CGColor]];
    [self.profilePicImageView.layer setBorderWidth: 1.0];
}

- (void)configureUserFields {
    PFUser *currentUser = [PFUser currentUser];
    self.usernameLabel.text = [currentUser objectForKey:@"username"];
    self.bioLabel.text = [currentUser objectForKey:@"bio"];
    self.nameLabel.text = [currentUser objectForKey:@"name"];
    self.profilePicImageView.file = [currentUser objectForKey:@"profileImage"];
    [self.profilePicImageView loadInBackground];
}

- (void)configureEditButton {
    self.editProfileButton.layer.borderWidth = 0.5;
    self.editProfileButton.layer.cornerRadius = 15;
    self.editProfileButton.layer.borderColor = [[UIColor blueColor] CGColor];
}

- (void)configureFriendCount {
    PFQuery *query = [PFQuery queryWithClassName:@"FriendsList"];
    [query includeKey:@"user"];
    [query includeKey:@"friendsList"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable friendsList, NSError * _Nullable error) {
        if (friendsList.count == 1) {
            NSArray *currUserFriendsList = [friendsList[0] objectForKey:@"friendsList"];
            self.friendsCountLabel.text = [NSString stringWithFormat:@"%lu Friends", (unsigned long)currUserFriendsList.count];
        } else if (error) {
            NSLog(@"Error retreiving profUser's friendships: %@", error.localizedDescription);
        }
    }];
    
}

- (void)fetchUserPosts {
    // construct PFQuery
      PFQuery *postQuery = [Post query];
      [postQuery whereKey:@"author" equalTo:[PFUser currentUser]];
      [postQuery orderByDescending:@"createdAt"];
      [postQuery includeKey:@"author"];

      // fetch data asynchronously
      [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
          if (posts) {
              // do something with the data fetched
              self.userPosts = [NSMutableArray arrayWithArray:posts];
              [self.collectionView reloadData];
          }
          else {
              // handle error
              NSLog(@"Error getting home timeline: %@", error.localizedDescription);
          }
      }];
}

- (void)configureBookmarkCount {
    PFQuery *query = [PFQuery queryWithClassName:@"BookmarkedTrip"];
    [query includeKey:@"trip"];
    [query includeKey:@"user"];
    [query includeKey:@"host"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *bookmarkedTrips, NSError *error) {
        if (!error) {
            self.bookmarkedTrips = (NSMutableArray *)bookmarkedTrips;
            [self.bookmarksButton setTitle:[NSString stringWithFormat:@"%lu Bookmarks", (unsigned long)self.bookmarkedTrips.count] forState:UIControlStateNormal];
            
        }
    }];
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProfilePostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfilePostCell" forIndexPath:indexPath];
    Post *post = self.userPosts[indexPath.row];
    cell.postImage.file = post.previewImage;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.tripsHostedLabel.text = [NSString stringWithFormat:@"%lu Trips Hosted", (unsigned long)self.userPosts.count];
    return self.userPosts.count;
}

- (IBAction)tappedLogout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignInViewController *signInViewController = [storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
    sceneDelegate.window.rootViewController = signInViewController;
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toProfilePostDetails"]) {
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        Post *post = self.userPosts[indexPath.row];
        
        ProfilePostDetailsViewController *profilePostDetailsViewController = [segue destinationViewController];
        profilePostDetailsViewController.post = post;
    } else if ([segue.identifier isEqualToString:@"toBookmarksFromProfileView"]) {
        BookmarkedTripsViewController *bookmarkedTripsViewController = [segue destinationViewController];
        bookmarkedTripsViewController.bookmarkedTrips = self.bookmarkedTrips;
    }
}


@end
