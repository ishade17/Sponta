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
#import "MapDetailsViewController.h"
#import <Parse/Parse.h>

@interface ExploreMapViewController () <MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (nonatomic, strong) NSMutableArray *publicPostsArray;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation* currentLocation;
@property (nonatomic, strong) NSMutableDictionary<MKPointAnnotation *, NSString *> *postsToPins;

@end

@implementation ExploreMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.map.delegate = self;
    self.map.showsUserLocation = YES;
    [self.map setShowsUserLocation:YES];
    [self.map setCenterCoordinate:self.map.userLocation.location.coordinate animated:YES];
    
    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.3, 0.3));
    [self.map setRegion:region animated:false];
    
    self.postsToPins = [NSMutableDictionary new];
 
    /*
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
    }*/
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // construct query
   PFQuery *query = [PFQuery queryWithClassName:@"Post"];
   [query includeKey:@"author"];
   [query whereKey:@"publicTrip" equalTo:@YES];
   [query orderByDescending:@"createdAt"];

   // fetch data asynchronously
   [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
       if (posts != nil) {
           self.publicPostsArray = (NSMutableArray *)posts;
           for (Post *post in self.publicPostsArray) {
               CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(post.latitude.floatValue, post.longitude.floatValue);
               MKPointAnnotation *annotation = [MKPointAnnotation new];
               annotation.coordinate = coordinate;
               annotation.title = post.title;
               annotation.subtitle = post.author.username;
               //[self.postsToPins setObject:post.objectId forKey:annotation];
               [self.map addAnnotation:annotation];
               
               NSLog(@"P2P: %@", self.postsToPins);
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
        
        //NSString *postId = self.postsToPins[annotation]; //fix
        
        for (Post *post in self.publicPostsArray) {
            if ([post.title isEqualToString:annotation.title] && [post.author.username isEqualToString:annotation.subtitle]) {
                [post.previewImage getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                    UIImage *annotationImage = [UIImage imageWithData:data];
                    UIImageView *imageView = (UIImageView*)annotationView.leftCalloutAccessoryView;
                    imageView.image = [self resizeImage:annotationImage withSize:CGSizeMake(50.0, 50.0)];
                    annotationView.leftCalloutAccessoryView = imageView;
                }];
            }
        }
//        annotationView.image = [self resizeImage:post[@"image"] withSize:CGSizeMake(50.0, 50.0)];
//        UIImageView *imageView = (UIImageView*)annotationView.leftCalloutAccessoryView;
//        imageView.image = post[@"image"];
        
    }
    return annotationView;
}

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:@"toMapDetails" sender:self];
}

/*
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.currentLocation = [locations lastObject];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        annotationView.canShowCallout = true;
    }
    
    return annotationView;
}*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([segue.identifier isEqual:@"toMapDetails"]) {
        MapDetailsViewController *mapDetailsViewController = [segue destinationViewController];
        //mapDetailsViewController.post = self.post;
    }
}


@end
