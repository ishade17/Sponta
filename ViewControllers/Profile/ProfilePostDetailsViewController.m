//
//  ProfilePostDetailsViewController.m
//  Sponta
//
//  Created by Isaac Schaider on 7/29/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "ProfilePostDetailsViewController.h"
#import "PFImageView.h"
#import "Comment.h"
#import "CommentCell.h"
#import "Notifications.h"

@interface ProfilePostDetailsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *tripTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *spotsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationAddress;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet PFImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UITextField *commentMessageField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) NSMutableArray *commentsArray;

@end

@implementation ProfilePostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.commentsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tripTitleLabel.text = self.post.title;
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateStyle:NSDateFormatterLongStyle]; // day, Full month and year
    [df setTimeStyle:NSDateFormatterNoStyle];  // nothing
    self.dateLabel.text = [df stringFromDate:self.post.tripDate];
    
    NSArray *chunks = [self.post.address componentsSeparatedByString: @", "];
    [(NSMutableArray *)chunks removeObjectAtIndex: chunks.count - 1];
    NSString *addressTitle = [chunks componentsJoinedByString:@", "];
    self.destinationAddress.text = [[NSString stringWithFormat:@"%@", addressTitle] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    self.descriptionLabel.text = self.post.tripDescription;
    
    if (self.post.guestList.count == 1) {
        self.spotsCountLabel.text = [NSString stringWithFormat:@"%lu Guest", (unsigned long)self.post.guestList.count];
    } else {
        self.spotsCountLabel.text = [NSString stringWithFormat:@"%lu Guests", (unsigned long)self.post.guestList.count];
    }
    self.spotsCountLabel.textColor = [UIColor blueColor];
    
    [self.post.previewImage getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        self.previewImageView.image = [UIImage imageWithData:data];
    }];
    
    self.commentsTableView.delegate = self;
    self.commentsTableView.dataSource = self;
    
    [self fetchComments];
    
}


- (void)fetchComments {
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Comment"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"post"];
    [postQuery whereKey:@"post" equalTo:self.post];
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable comments, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            self.commentsArray = (NSMutableArray *)comments;
            [self.commentsTableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    Comment *comment = self.commentsArray[indexPath.row];
    cell.commentLabel.text = comment.caption;
    cell.commentUserLabel.text = comment.author.username;
        
    return cell;
}

- (IBAction)tappedPostComment:(id)sender {
    [Comment postComments:self.commentMessageField.text onPost:self.post withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
    if (succeeded) {
        self.commentMessageField.text = @"";
        [Notifications sendNotification:[PFUser currentUser] withReceiver:self.post.author withPost:self.post withType:@"comment"];
        [self fetchComments];
    } else {
        NSLog(@"%@", error.localizedDescription);
    }
    }];
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
