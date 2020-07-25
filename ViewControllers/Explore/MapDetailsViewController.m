//
//  MapDetailsViewController.m
//  Sponta
//
//  Created by Isaac Schaider on 7/22/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "MapDetailsViewController.h"
#import <Parse/Parse.h>
#import "PFImageView.h"

@interface MapDetailsViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *profilePicImageView;
@property (weak, nonatomic) IBOutlet UILabel *tripTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *spotsFilledLabel;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation MapDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tripTitleLabel.text = self.post.title;
    self.usernameLabel.text = self.post.author.username;
    self.profilePicImageView.layer.cornerRadius = self.profilePicImageView.frame.size.height /2;
    [self.profilePicImageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.profilePicImageView.layer setBorderWidth: 0.5];
    NSArray *daysOfWeek = @[@"",@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
    NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:self.post.tripDate];
    self.timeDateLabel.text = [NSString stringWithFormat:@"%@ – %@ on %@", self.post.startTime, self.post.endTime, [daysOfWeek objectAtIndex:weekday]];
    self.addressLabel.text = self.post.address;
    self.descriptionLabel.text = self.post.tripDescription;
    self.spotsFilledLabel.text = [NSString stringWithFormat:@"Spots filled: %lu / %@", (unsigned long)self.post.guestList.count, self.post.spots];
    [self.post.previewImage getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        self.previewImageView.image = [UIImage imageWithData:data];
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
