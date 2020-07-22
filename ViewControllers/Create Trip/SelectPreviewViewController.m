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
#import "UIImageView+AFNetworking.h"

static NSString * const clientKey = @"AIzaSyDaAdWMOh7uT3UUJpOF23UhY6IEQi6WHCA";


@interface SelectPreviewViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *photoReferences;
@property (nonatomic, strong) NSMutableArray *photoArray;

@end

@implementation SelectPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    SelectPreviewViewController *SPViewController = [SelectPreviewViewController new];
//    SPViewController.delegate = self;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 224;
    
    self.photoArray = [NSMutableArray new];
    
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
            
            NSLog(@"PHOTO REFS: %@", self.photoReferences);
            for (NSDictionary *photoObject in self.photoReferences) {
                NSLog(@"PHOTO OBJECT: %@", photoObject);
                [self updateWithPreview: photoObject];
            }
            [self.tableView reloadData];
        }
    }];
    
    [task resume];
}

- (void)updateWithPreview:(NSDictionary *)photoObject {
    //NSLog(@"%@", photoObject[@"html_attributions"]);
    NSString *baseURLString = @"https://maps.googleapis.com/maps/api/place/photo?";
    NSString *queryString = [NSString stringWithFormat:@"maxwidth=500&maxheight=500&photoreference=%@&key=%@", [photoObject valueForKeyPath:@"photo_reference"], clientKey];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
    //NSLog(@"query url: %@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSURL *URL = [response valueForKeyPath:@"URL"];
            NSLog(@"%@", URL);
            NSData *imageData = (NSData *)[NSData dataWithContentsOfURL:URL];
            NSLog(@"DATA: %@", imageData);
            UIImage *image = [UIImage imageWithData:imageData];
            NSLog(@"IMAGE: %@", image);
            [self.photoArray addObject:image];
            NSLog(@"PHOTO ARRAY: %@", self.photoArray);
            [self.tableView reloadData];
        }
    }];
    [task resume];

}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LocationPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationPreviewCell"];
    //[self updateWithPreview:self.photoReferences[indexPath.row]];
    cell.previewImage.image = self.photoArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"%lu", (unsigned long)self.photoReferences.count);
    return self.photoArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"index path: %ld", (long)indexPath.row);
    LocationPreviewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //NSLog(@"dequeue cell: %@", cell.previewImage.image);
    //NSLog(@"selected object: %@", self.photoReferences[indexPath.row]);
    [self.delegate passPreview:self.photoArray[indexPath.row]];
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
