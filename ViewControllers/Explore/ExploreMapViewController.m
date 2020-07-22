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
//#import "PhotoAnnotation.h"

@interface ExploreMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (nonatomic, strong) NSMutableArray *publicPostsArray;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation* currentLocation;

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
 
    /*
    if ([CLLocationManager locationServicesEnabled]) {
        if (self.locationManager == nil) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.distanceFilter = kCLDistanceFilterNone;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    //        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
    //            [self.locationManager requestWhenInUseAuthorization];
    //        }
        }
        [self.locationManager startUpdatingLocation];
    }*/
}

-(void)viewWillAppear:(BOOL)animated {
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
               NSLog(@"%f", post.latitude.floatValue);
               NSLog(@"%f", post.longitude.floatValue);
               MKPointAnnotation *annotation = [MKPointAnnotation new];
               annotation.coordinate = coordinate;
               annotation.title = post.title;
               [self.map addAnnotation:annotation];
           }
       } else {
           NSLog(@"%@", error.localizedDescription);
       }
   }];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
