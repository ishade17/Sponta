//
//  ExploreTripsCell.m
//  Sponta
//
//  Created by Isaac Schaider on 7/25/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "ExploreTripsCell.h"
#import "JoinLeaveTrip.h"
#import "UpcomingTrip.h"

@implementation ExploreTripsCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


/*
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.itemSize = CGSizeMake(44, 44);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[AFIndexedCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.collectionView];

    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.contentView.bounds;
}

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath {
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.indexPath = indexPath;
    [self.collectionView setContentOffset:self.collectionView.contentOffset animated:NO];
    
    [self.collectionView reloadData];
}*/

/*
 
- (void)configureCollectionView {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat itemWidth = self.collectionView.frame.size.width / 3.4;
    CGFloat itemHeight = self.collectionView.frame.size.height;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)fetchGuests:(Post *)post {
    PFQuery *query = [PFQuery queryWithClassName:@"UpcomingTrip"];
    [query includeKey:@"trip"];
    [query includeKey:@"guest"];
    [query whereKey:@"trip" equalTo:post];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *tripGuests, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            self.guestsArray = (NSMutableArray *)tripGuests;
            [self.collectionView reloadData];
        }
    }];
}

- (void)configureCollectionView {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat itemWidth = self.collectionView.frame.size.width / 3.4;
    CGFloat itemHeight = self.collectionView.frame.size.height;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    GuestProfilePicCell *guestProfilePicCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GuestProfilePicCell" forIndexPath:indexPath];
    if (indexPath.row < self.guestsArray.count) {
        UpcomingTrip *upcomingTrip = self.guestsArray[indexPath.row];
        
        [self configureGuestProfilePic:guestProfilePicCell withUpcomingTrip:upcomingTrip];
        guestProfilePicCell.guestUsername.text = upcomingTrip.guest.username;
    } else {
        guestProfilePicCell.guestProfilePic.layer.cornerRadius = guestProfilePicCell.guestProfilePic.frame.size.height / 2;
        [guestProfilePicCell.guestProfilePic.layer setBorderColor: [[UIColor blueColor] CGColor]];
        [guestProfilePicCell.guestProfilePic.layer setBorderWidth: 0.5];
        guestProfilePicCell.guestUsername.text = @"Open";
    }
    
    return guestProfilePicCell;
}

- (void)configureGuestProfilePic:(GuestProfilePicCell *)guestProfilePicCell withUpcomingTrip:(UpcomingTrip *)upcomingTrip {
    guestProfilePicCell.guestProfilePic.file = [upcomingTrip.guest objectForKey:@"profileImage"];
    [guestProfilePicCell.guestProfilePic loadInBackground];
    guestProfilePicCell.guestProfilePic.layer.cornerRadius = guestProfilePicCell.guestProfilePic.frame.size.height / 2;
    [guestProfilePicCell.guestProfilePic.layer setBorderColor: [[UIColor blueColor] CGColor]];
    [guestProfilePicCell.guestProfilePic.layer setBorderWidth: 1.0];
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return self.guestsArray.count;
    return [self.post.spots integerValue];
}
 */


@end
