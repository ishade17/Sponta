//
//  ExploreMapViewController.m
//  Sponta
//
//  Created by Isaac Schaider on 7/21/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "ExploreMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Post.h"
#import <Parse/Parse.h>
#import "ExploreTripsViewController.h"

@interface ExploreMapViewController () <MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (nonatomic, strong) NSMutableArray *publicPostsArray;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSMutableArray<Post *> *selectedPosts;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableArray<Post *> *> *pinToPost;

@end

@implementation ExploreMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.map.delegate = self;
    self.map.showsUserLocation = YES;
    [self.map setShowsUserLocation:YES];
    [self.map setCenterCoordinate:self.map.userLocation.location.coordinate animated:YES];
    
    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.4419, -122.1430), MKCoordinateSpanMake(0.3, 0.3));
    [self.map setRegion:region animated:false];
        
    if ([CLLocationManager locationServicesEnabled]) {
        if (self.locationManager == nil) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.distanceFilter = kCLDistanceFilterNone;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                [self.locationManager requestWhenInUseAuthorization];
            }
        }
        [self.locationManager startUpdatingLocation];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.pinToPost = [NSMutableDictionary new];
    
    // construct query
   PFQuery *query = [PFQuery queryWithClassName:@"Post"];
   [query includeKey:@"author"];
   [query whereKey:@"publicTrip" equalTo:@YES];
   [query orderByDescending:@"createdAt"];

   // fetch data asynchronously
   [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
       if (posts != nil) {
           /* complex algorithm:
                n = number of public trips
                m = number of unique public trip locations
                time complexity = O(n + m)
            */
           self.publicPostsArray = (NSMutableArray *)posts;
           
           for (Post *post in self.publicPostsArray) {
               NSString *latLong = [NSString stringWithFormat:@"%.04f %.04f", post.latitude.floatValue, post.longitude.floatValue];
               if ([self.pinToPost objectForKey:latLong]) {
                   // existing location
                   NSMutableArray *postArray = [self.pinToPost objectForKey:latLong];
                   [postArray addObject:post];
                   [self.pinToPost setObject:postArray forKey:latLong];
               } else {
                   // new location
                   NSMutableArray *postArray = [NSMutableArray new];
                   [postArray addObject:post];
                   [self.pinToPost setObject:postArray forKey:latLong];
               }
           }
           
           for (NSString *key in self.pinToPost) {
               MKPointAnnotation *annotation = [MKPointAnnotation new];
               Post *post = [self.pinToPost objectForKey:key][0];
               if ([self.pinToPost objectForKey:key].count > 1) {
                   CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(post.latitude.floatValue, post.longitude.floatValue);
                   annotation.coordinate = coordinate;
                   annotation.title = [NSString stringWithFormat:@"%lu Different Trips", (unsigned long)[self.pinToPost objectForKey:key].count];
                   annotation.subtitle = @"Select a Trip";
               } else {
                   CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(post.latitude.floatValue, post.longitude.floatValue);
                   annotation.coordinate = coordinate;
                   annotation.title = post.title;
                   annotation.subtitle = post.author.username;
               }
               [self.map addAnnotation:annotation];
           }
       } else {
           NSLog(@"%@", error.localizedDescription);
       }
   }];
    
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
     UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];

     resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
     resizeImageView.image = image;

     UIGraphicsBeginImageContext(size);
     [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
     UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();

     return newImage;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        annotationView.canShowCallout = true;
        annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
       
        for (NSString *key in self.pinToPost) {
            if ([key isEqualToString:[NSString stringWithFormat:@"%.04f %.04f", annotationView.annotation.coordinate.latitude, annotationView.annotation.coordinate.longitude]]) {
                NSMutableArray *postArray = [self.pinToPost objectForKey:key];
                Post *post = postArray[0];
                [post.previewImage getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                    UIImage *annotationImage = [UIImage imageWithData:data];
                    UIImageView *imageView = (UIImageView*)annotationView.leftCalloutAccessoryView;
                    imageView.image = [self resizeImage:annotationImage withSize:CGSizeMake(50.0, 50.0)];
                    annotationView.leftCalloutAccessoryView = imageView;
                    
                }];
            }
        }
    }
    return annotationView;
}

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSString *latLong = [NSString stringWithFormat:@"%.04f %.04f", view.annotation.coordinate.latitude, view.annotation.coordinate.longitude];
    NSMutableArray *pinnedPosts = [self.pinToPost objectForKey:latLong];
    self.selectedPosts = pinnedPosts;
    [self performSegueWithIdentifier:@"toExploreTripsDetails" sender:self];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

if ([segue.identifier isEqual:@"toExploreTripsDetails"]) {
        ExploreTripsViewController *exploreTripsViewController = [segue destinationViewController];
        exploreTripsViewController.postsArray = self.selectedPosts;
    }
    
}


@end
