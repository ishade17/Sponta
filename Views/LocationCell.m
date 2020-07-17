//
//  LocationCell.m
//  Sponta
//
//  Created by Isaac Schaider on 7/15/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "LocationCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIImageView+AFNetworking.h"

@interface LocationCell()

@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) NSDictionary *location;

@end

@implementation LocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithLocation:(NSDictionary *)location {

    // GOOGLE API
    self.nameLabel.text = location[@"name"];
    self.addressLabel.text = [location valueForKeyPath:@"formatted_address"];

    NSURL *url = [NSURL URLWithString:location[@"icon"]];
    [self.categoryImageView setImageWithURL:url];
    
}

@end
