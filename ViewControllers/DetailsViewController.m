//
//  DetailsViewController.m
//  Sponta
//
//  Created by Isaac Schaider on 7/20/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "DetailsViewController.h"
#import <MapKit/MapKit.h>

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tripTitleLabel;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UILabel *timePeriodLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationAddress;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UITextField *addCommentTextField;
@property (nonatomic, strong) NSMutableArray *commentsArray;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    myLabel.layer.borderColor = [UIColor greenColor].CGColor
//    myLabel.layer.borderWidth = 3.0
    
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
