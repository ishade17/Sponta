//
//  SearchLocationsViewController.m
//  Sponta
//
//  Created by Isaac Schaider on 7/15/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "SearchLocationsViewController.h"
#import "LocationCell.h"
#import "SelectPreviewViewController.h"

static NSString * const clientKey = @"AIzaSyDaAdWMOh7uT3UUJpOF23UhY6IEQi6WHCA";

@interface SearchLocationsViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SelectPreviewViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *results;

@end

@implementation SearchLocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
    self.tableView.rowHeight = 68;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    [cell updateWithLocation:self.results[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *venue = self.results[indexPath.row];
    self.previewID = [venue valueForKeyPath:@"place_id"];
    [self performSegueWithIdentifier:@"toPreviewSelectorView" sender:self];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newText = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    [self fetchLocationsWithQuery:newText nearCity:@"San Francisco"];
    return true;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self fetchLocationsWithQuery:searchBar.text nearCity:@"San Francisco"];
}

- (void)fetchLocationsWithQuery:(NSString *)query nearCity:(NSString *)city {
    // GOOGLE API
    NSString *baseURLString = @"https://maps.googleapis.com/maps/api/place/textsearch/json?";
    NSString *queryString = [NSString stringWithFormat:@"query=%@&key=%@", query, clientKey];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.results = [responseDictionary valueForKeyPath:@"results"];
            [self.tableView reloadData];
        }
    }];
    [task resume];
    
}

- (void)passPreview:(nonnull UIImage *)preview {
    [self.delegate didSelectPreview:preview];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"toPreviewSelectorView"]) {
        SelectPreviewViewController *selectPreviewViewController = [segue destinationViewController];
        selectPreviewViewController.previewID = self.previewID;
        selectPreviewViewController.delegate = self;
    }
}




@end
