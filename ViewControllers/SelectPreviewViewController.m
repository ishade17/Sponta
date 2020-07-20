//
//  SelectPreviewViewController.m
//  Sponta
//
//  Created by Isaac Schaider on 7/15/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "SelectPreviewViewController.h"
#import "LocationPreviewCell.h"
#import <Parse/Parse.h>
#import "PFImageView.h"

static NSString * const clientKey = @"AIzaSyDaAdWMOh7uT3UUJpOF23UhY6IEQi6WHCA";

@interface SelectPreviewViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *photoReferences;

@end

@implementation SelectPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    SelectPreviewViewController *SPViewController = [SelectPreviewViewController new];
//    SPViewController.delegate = self;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
     
    self.tableView.rowHeight = 224;
    
    [self fetchPreviews];
}

- (void)fetchPreviews {
    
    // GOOGLE API
    NSString *baseURLString = @"https://maps.googleapis.com/maps/api/place/details/json?";
    NSString *queryString = [NSString stringWithFormat:@"place_id=%@&key=%@", self.previewID, clientKey];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.photoReferences = [responseDictionary valueForKeyPath:@"result.photos"];
            [self.tableView reloadData];
        }
    }];
    [task resume];
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LocationPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationPreviewCell"];
    [cell updateWithPreview:self.photoReferences[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photoReferences.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationPreviewCell"];
    NSLog(@"%@", self.delegate);
    [self.delegate didSelectPreview:cell.previewImage.image];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
}
*/

@end
