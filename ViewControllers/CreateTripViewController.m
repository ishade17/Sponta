//
//  CreateTripViewController.m
//  Sponta
//
//  Created by Isaac Schaider on 7/15/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "CreateTripViewController.h"
#import "SelectPreviewViewController.h"
#import "SearchLocationsViewController.h"
#import <Parse/Parse.h>
#import "PFImageView.h"
#import "Post.h"

@interface CreateTripViewController () <SearchLocationsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *uploadImageLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *tripNameTextView;
@property (weak, nonatomic) IBOutlet UITextField *addressTextView;
@property (weak, nonatomic) IBOutlet UITextField *startTimeTextView;
@property (weak, nonatomic) IBOutlet UITextField *endTimeTextView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionHeaderLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionBodyTextView;
@property (weak, nonatomic) IBOutlet UILabel *dashLabel;
@property (weak, nonatomic) IBOutlet UITextField *tripDateTextView;
@property (weak, nonatomic) IBOutlet UITextField *numSpotsTextView;

@end

@implementation CreateTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    CreateTripViewController *createView = [[CreateTripViewController alloc]initWithNibName:Nil bundle:Nil];
//    [self presentViewController:createView animated:NO completion:nil];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:createView];
//    [self.navigationController pushViewController:navigationController animated:YES];
    
    [self.selectedImage.layer setBorderColor: [[UIColor blueColor] CGColor]];
    [self.selectedImage.layer setBorderWidth: 0.5];
    self.selectedImage.image = nil;
    self.uploadImageLabel.alpha = 1;
    
    self.descriptionTextView.layer.borderWidth = 0.5f;
    self.descriptionTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    
}

- (IBAction)tappedSelectImage:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    self.selectedImage.image = [self resizeImage:editedImage withSize:CGSizeMake(345, 202)];
    self.uploadImageLabel.alpha = 0;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)didSelectPreview:(nonnull UIImage *)preview {
    self.selectedImage.image = preview;
    self.uploadImageLabel.alpha = 0;
    NSLog(@"test");
}



- (IBAction)tappedPost:(id)sender {
    if (self.selectedImage.image == nil) NSLog(@"shucks!");
    if (self.selectedImage.image != nil && ![self.addressTextView.text isEqual: @""] && ![self.tripNameTextView.text isEqual: @""] && ![self.startTimeTextView.text isEqual: @""] && ![self.endTimeTextView.text isEqual: @""] && ![self.descriptionBodyTextView.text isEqual: @""]) {
        
        [Post postUserTrip:self.tripNameTextView.text withDescription:self.descriptionBodyTextView.text withImage:self.selectedImage.image withAddress:self.addressTextView.text withTripDate:self.tripDateTextView.text withStartTime:self.startTimeTextView.text withEndTime:self.endTimeTextView.text withSpots:self.numSpotsTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Successful post!");
            self.tabBarController.selectedIndex = 0;
            self.tripNameTextView.text = @"";
            self.descriptionBodyTextView.text = @"";
            self.selectedImage.image = nil;
            self.uploadImageLabel.alpha = 1;
            self.addressTextView.text = @"";
            self.tripDateTextView.text = @"";
            self.startTimeTextView.text = @"";
            self.endTimeTextView.text = @"";
            self.numSpotsTextView.text = @"";
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        }];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error with post"
               message:@"Please fill out all fields"
        preferredStyle:(UIAlertControllerStyleAlert)];

        // create an OK action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle response here.
                                                         }];
        // add the OK action to the alert controller
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"toSearchSegue"]) {
        SearchLocationsViewController *searchLocationsViewController = [segue destinationViewController];
        searchLocationsViewController.delegate = self;
    }
}


@end
