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

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *friendsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripsHostedLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (nonatomic, strong) NSArray *userPosts;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.profilePicImageView.layer.cornerRadius = self.profilePicImageView.frame.size.height / 2;
    [self.profilePicImageView.layer setBorderColor: [[UIColor blueColor] CGColor]];
    [self.profilePicImageView.layer setBorderWidth: 1.0];
    
    self.editProfileButton.layer.borderWidth = 0.5;
    self.editProfileButton.layer.cornerRadius = 2;
    self.editProfileButton.layer.borderColor = UIColor.darkGrayColor.CGColor;
    
    PFUser *currentUser = [PFUser currentUser];
    self.usernameLabel.text = [currentUser objectForKey:@"username"];
    self.bioLabel.text = [currentUser objectForKey:@"bio"];
    self.profilePicImageView.file = [currentUser objectForKey:@"profilePicture"];
    [self.profilePicImageView loadInBackground];

    [self fetchUserPosts];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    CGFloat postersPerLine = 3;
    //CGFloat itemWidth = (self.collectionsView.frame.size.width - (layout.minimumInteritemSpacing + 28)* (postersPerLine - 1)) / postersPerLine;
    CGFloat itemWidth = self.collectionView.frame.size.width / postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)viewWillAppear:(BOOL)animated {
    self.profilePicImageView.layer.cornerRadius = self.profilePicImageView.frame.size.height / 2;
    self.editProfileButton.layer.borderWidth = 0.5;
    self.editProfileButton.layer.cornerRadius = 2;
    self.editProfileButton.layer.borderColor = [[UIColor blueColor] CGColor];
    
    PFUser *currentUser = [PFUser currentUser];
    self.usernameLabel.text = [currentUser objectForKey:@"username"];
    self.bioLabel.text = [currentUser objectForKey:@"bio"];
    self.profilePicImageView.file = [currentUser objectForKey:@"profilePicture"];
    [self.profilePicImageView loadInBackground];
}

- (void) fetchUserPosts {
    // construct PFQuery
      PFQuery *postQuery = [Post query];
      [postQuery whereKey:@"author" equalTo:[PFUser currentUser]];
      [postQuery orderByDescending:@"createdAt"];
      [postQuery includeKey:@"author"];
      //postQuery.limit = 20;

      // fetch data asynchronously
      [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
          if (posts) {
              // do something with the data fetched
              self.userPosts = [NSMutableArray arrayWithArray:posts];
              [self.collectionView reloadData];
              //NSLog(@"%lu", posts.count);
          }
          else {
              // handle error
              NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
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
    return self.userPosts.count;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
