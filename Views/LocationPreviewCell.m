//
//  LocationPreviewCell.m
//  Sponta
//
//  Created by Isaac Schaider on 7/15/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "LocationPreviewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIImageView+AFNetworking.h"


static NSString * const clientKey = @"AIzaSyDaAdWMOh7uT3UUJpOF23UhY6IEQi6WHCA";


@implementation LocationPreviewCell
/*
// FOURQUARE API
 - (void)updateWithPreview:(NSDictionary *)venueImages {
    
    NSString *urlPrefix = [venueImages valueForKeyPath:@"prefix"];
    NSString *urlSuffix = [venueImages valueForKeyPath:@"suffix"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", urlPrefix, @"202x118", urlSuffix];

    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"url: %@", url);
    [self.previewImage setImageWithURL:url];
     
    
    
}
*/
    // GOOGLE API
- (void)updateWithPreview:(NSDictionary *)photoObject {
    NSLog(@"%@", photoObject);
    NSString *baseURLString = @"https://maps.googleapis.com/maps/api/place/photo?";
    NSString *queryString = [NSString stringWithFormat:@"maxwidth=500&maxheight=500&photoreference=%@&key=%@", [photoObject valueForKeyPath:@"photo_reference"], clientKey];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSLog(@"%@", url);
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
//            NSLog(@"response: %@", response);
//            NSLog(@"%@", [response valueForKeyPath:@"URL"]);

//            NSLog(@"%@", data);
//            self.previewImage.image = [UIImage imageWithData:response];
//
            NSURL *URL = [response valueForKeyPath:@"URL"];
            //NSLog(@"%@", URL); // valid URL
            [self.previewImage setImageWithURL:URL]; // must be something wrong with this method?
            NSLog(@"%@", self.previewImage.image); // shows that image is not being set
        }
    }];
    [task resume];

}


@end
