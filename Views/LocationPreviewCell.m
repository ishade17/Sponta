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

    // GOOGLE API
    // Don't need??
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
            [self.previewImage setImageWithURL:URL];
            //NSLog(@"image url: %@", URL);
        }
    }];
    [task resume];

}


@end
