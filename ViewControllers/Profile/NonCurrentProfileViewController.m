//
//  NonCurrentProfileViewController.m
//  Sponta
//
//  Created by Isaac Schaider on 8/5/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "NonCurrentProfileViewController.h"
#import "PFImageView.h"
#import <Parse/Parse.h>
#import "ProfilePostCell.h"
#import "Post.h"
#import "ProfilePostDetailsViewController.h"

@interface NonCurrentProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *profilePicImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripsHostedLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;
@property (nonatomic, strong) NSArray *userPosts;

@end

@implementation NonCurrentProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self configureAddFriendButton];
    
    [self configureCollectionView];
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
    PFUser *profileUser = self.user;
    self.usernameLabel.text = [profileUser objectForKey:@"username"];
    self.bioLabel.text = [profileUser objectForKey:@"bio"];
    self.nameLabel.text = [profileUser objectForKey:@"name"];
    self.profilePicImageView.file = [profileUser objectForKey:@"profileImage"];
    [self.profilePicImageView loadInBackground];
}

- (void)configureAddFriendButton {
    
}

- (void)fetchUserPosts {
    // construct PFQuery
      PFQuery *postQuery = [Post query];
    [postQuery whereKey:@"author" equalTo:self.user];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toDetailsFromNonCurrentProfile"]) {
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        Post *post = self.userPosts[indexPath.row];
        
        ProfilePostDetailsViewController *profilePostDetailsViewController = [segue destinationViewController];
        profilePostDetailsViewController.post = post;
    }
    
}


@end
