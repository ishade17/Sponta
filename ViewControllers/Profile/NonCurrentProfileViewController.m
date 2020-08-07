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
#import "FriendRequest.h"
#import "FriendsList.h"
#import "Notifications.h"

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
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSMutableArray<NSString *> *currFriendsList;
@property (nonatomic, strong) NSMutableArray<NSString *> *profFriendsList;
@property (nonatomic) BOOL friends; // indicates if currUser and profUser are friends
@property (nonatomic) BOOL requested; // indicates if profUser sent a request to currUser
@property (nonatomic) BOOL sentRequest; // indicates if currUser sent a request to profUser

@end

@implementation NonCurrentProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
        
    [self configureCollectionView];
    
    [self configureFriendship];
}

- (void)viewWillAppear:(BOOL)animated {
    [self styleProfilePicture];
        
    [self configureUserFields];
    
    [self fetchUserPosts];
    
}

- (void)configureFriendship {
    self.currentUser = [PFUser currentUser];
    self.currFriendsList = [self.currentUser objectForKey:@"friendsList"];
    self.profFriendsList = [self.profUser objectForKey:@"friendsList"];
    self.friends = FALSE;
    self.requested = FALSE;
    self.sentRequest = FALSE;
    
    // check if currUser and profUser are friends
    for (NSString *friendUsername in self.currFriendsList) {
        if ([friendUsername isEqualToString:self.profUser.username]) {
            [self.addFriendButton setBackgroundColor:[UIColor systemGreenColor]];
            [self.addFriendButton setTitle:@"Friends" forState:UIControlStateNormal];
            self.addFriendButton.titleLabel.textColor = [UIColor whiteColor];
            self.friends = TRUE;
            return;
        }
    }
    // if not friends, check if profUser sent a request to currUser
    if (self.friends == FALSE) {
        PFQuery *query = [FriendRequest query];
        [query includeKey:@"receiver"];
        [query includeKey:@"sender"];
        [query whereKey:@"receiver" equalTo:self.currentUser];
        [query whereKey:@"sender" equalTo:self.profUser];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable requests, NSError * _Nullable error) {
            if (requests.count > 0) {
                [self.addFriendButton setBackgroundColor:[UIColor whiteColor]];
                self.addFriendButton.layer.borderWidth = 1.0;
                self.addFriendButton.layer.borderColor = [[UIColor systemBlueColor] CGColor];
                [self.addFriendButton setTitle:@"Accept Request?" forState:UIControlStateNormal];
                [self.addFriendButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
                self.requested = TRUE;
                return;
            }
        }];
    }
    // if not friends and profUser didn't send a request to currUser, check if currUser sent a request to profUser
    if (self.friends == FALSE && self.requested == FALSE) {
        PFQuery *query = [FriendRequest query];
        [query includeKey:@"receiver"];
        [query includeKey:@"sender"];
        [query whereKey:@"receiver" equalTo:self.profUser];
        [query whereKey:@"sender" equalTo:self.currentUser];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable requests, NSError * _Nullable error) {
            if (requests.count > 0) {
                [self.addFriendButton setBackgroundColor:[UIColor whiteColor]];
                self.addFriendButton.layer.borderWidth = 1.0;
                self.addFriendButton.layer.borderColor = [[UIColor systemBlueColor] CGColor];
                [self.addFriendButton setTitle:@"Request Sent" forState:UIControlStateNormal];
                [self.addFriendButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
                self.sentRequest = TRUE;
                return;
            }
        }];
    }
    // if not friend and no one has sent a request, then configure button to default state
    if (self.friends == FALSE && self.requested == FALSE && self.sentRequest == FALSE) {
        [self.addFriendButton setBackgroundColor:[UIColor systemBlueColor]];
        [self.addFriendButton setTitle:@"Add Friend" forState:UIControlStateNormal];
        self.addFriendButton.titleLabel.textColor = [UIColor whiteColor];
    }
}


- (IBAction)tappedFriendButton:(id)sender {
    // if current user is the same as the profile user, then don't allow friending
    if ([self.profUser.username isEqualToString:self.currentUser.username]) return;
    
    if (self.friends == TRUE) { // if friends, then unfriend
        // remove profile user from current user friend list
        [FriendsList removeFriend:self.profUser fromUser:self.currentUser withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"Friendship removed!");
            } else {
                NSLog(@"Error removing friendship: %@", error.localizedDescription);
            }
        }];
        
        // remove current user from profile user friend list
        [FriendsList removeFriend:self.currentUser fromUser:self.profUser withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"Friendship removed!");
            } else {
                NSLog(@"Error removing friendship: %@", error.localizedDescription);
            }
        }];
        
        // change button to default state
        [self.addFriendButton setBackgroundColor:[UIColor systemBlueColor]];
        [self.addFriendButton setTitle:@"Add Friend" forState:UIControlStateNormal];
        [self.addFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.friends = FALSE;
        
    } else if (self.requested == TRUE) { // if received a request, confirm request
        // add profile user to current user friend list
        [FriendsList addFriend:self.profUser toUser:self.currentUser withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"Friend request approved!");
            } else {
                NSLog(@"Error approving friend request: %@", error.localizedDescription);
            }
        }];
        
        // add current user to profile user friend list
        [FriendsList addFriend:self.currentUser toUser:self.profUser withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"Friend request approved!");
            } else {
                NSLog(@"Error approving friend request: %@", error.localizedDescription);
            }
        }];
        
        // change button to friends state
        [self.addFriendButton setBackgroundColor:[UIColor systemGreenColor]];
        self.addFriendButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        [self.addFriendButton setTitle:@"Friends" forState:UIControlStateNormal];
        [self.addFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        // delete the request
        PFQuery *query = [FriendRequest query];
        [query includeKey:@"receiver"];
        [query includeKey:@"sender"];
        [query whereKey:@"receiver" equalTo:self.currentUser];
        [query whereKey:@"sender" equalTo:self.profUser];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable requests, NSError * _Nullable error) {
            for (FriendRequest *request in requests) {
                [request deleteInBackground];
            }
        }];
        
        self.requested = FALSE;
        self.friends = TRUE;
        
    } else if (self.sentRequest == TRUE) { // if sent a request, delete request
        // change button to default state
        [self.addFriendButton setBackgroundColor:[UIColor systemBlueColor]];
        [self.addFriendButton setTitle:@"Add Friend" forState:UIControlStateNormal];
        [self.addFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        // delete the request
        PFQuery *query = [FriendRequest query];
        [query includeKey:@"receiver"];
        [query includeKey:@"sender"];
        [query whereKey:@"receiver" equalTo:self.profUser];
        [query whereKey:@"sender" equalTo:self.currentUser];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable requests, NSError * _Nullable error) {
            for (FriendRequest *request in requests) {
                [request deleteInBackground];
            }
        }];
        
        self.sentRequest = FALSE;
        
    } else { // if none of the above, send a request
        [FriendRequest makeFriendRequest:self.currentUser withReceiver:self.profUser withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                // if request is made, configure the button to request state
                [self.addFriendButton setBackgroundColor:[UIColor whiteColor]];
                self.addFriendButton.layer.borderWidth = 1.0;
                self.addFriendButton.layer.borderColor = [[UIColor systemBlueColor] CGColor];
                [self.addFriendButton setTitle:@"Request Sent" forState:UIControlStateNormal];
                [self.addFriendButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
                

                [Notifications sendNotification:self.currentUser withReceiver:self.profUser withPost:self.userPosts[0] withType:@"friend request"];
            } else {
                NSLog(@"Error sending friend request: %@", error.localizedDescription);
            }
        }];
        
        self.sentRequest = TRUE;
    }
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
    [self.profilePicImageView.layer setBorderColor: [[UIColor systemBlueColor] CGColor]];
    [self.profilePicImageView.layer setBorderWidth: 1.0];
}

- (void)configureUserFields {
    PFUser *profileUser = self.profUser;
    self.usernameLabel.text = [profileUser objectForKey:@"username"];
    self.bioLabel.text = [profileUser objectForKey:@"bio"];
    self.nameLabel.text = [profileUser objectForKey:@"name"];
    self.profilePicImageView.file = [profileUser objectForKey:@"profileImage"];
    [self.profilePicImageView loadInBackground];
}

- (void)fetchUserPosts {
    // construct PFQuery
    PFQuery *postQuery = [Post query];
    [postQuery whereKey:@"author" equalTo:self.profUser];
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
