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

static NSString * const clientID = @"D11E2LIRKX0L1OQHSLAHGY0GO2WG4Z3ZNBJNUDKVA2LCIFX5";
static NSString * const clientSecret = @"MTHKEDQ2HZ3G3LK1V4NQEJF3NIXHETYNF3D22K2R5OBZIUQ0";
static NSString * const clientKey = @"AIzaSyDaAdWMOh7uT3UUJpOF23UhY6IEQi6WHCA";

@interface SelectPreviewViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *previewImages;
@property (nonatomic, strong) NSMutableArray *photoReferences;

@end

@implementation SelectPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self fetchPreviews];

    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    CGFloat previewsPerLine = 1;
    CGFloat itemWidth = self.collectionView.frame.size.width / previewsPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(500, 500);
}

- (void)fetchPreviews {
    /*
    // FOURSQUARE API
    NSString *baseURLString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@/photos?", self.previewID];
    NSString *queryString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20200714", clientID, clientSecret];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //NSLog(@"response: %@", responseDictionary);
            self.previewImages = [responseDictionary valueForKeyPath:@"response.photos.items"];
            //NSLog(@"previewImages: %@", self.previewImages);
            [self.collectionView reloadData];
        }
    }];
    [task resume];
     */
    
    
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
            //NSLog(@"response: %@", responseDictionary);
            //NSLog(@"%@", [responseDictionary valueForKeyPath:@"result.photos"]);
            self.photoReferences = [responseDictionary valueForKeyPath:@"result.photos"];
            //NSLog(@"previewImages: %@", self.previewImages);
            [self.collectionView reloadData];
        }
    }];
    [task resume];
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LocationPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LocationPreviewCell" forIndexPath:indexPath];
    
    // FOURSQUARE API
    //[cell updateWithPreview:self.previewImages[indexPath.row]];
    
    // GOOGLE API
    [cell updateWithPreview:self.photoReferences[indexPath.row]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    /*
    // FOURSQUARE API
    NSLog(@"# of Images: %lu",(unsigned long)self.previewImages.count);
    return self.previewImages.count;
    */
    
    // GOOGLE API
    NSLog(@"# of Images: %lu",(unsigned long)self.photoReferences.count);
    return self.photoReferences.count;
     
    
    
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
