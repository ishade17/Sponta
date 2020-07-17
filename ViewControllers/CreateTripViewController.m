//
//  CreateTripViewController.m
//  Sponta
//
//  Created by Isaac Schaider on 7/15/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "CreateTripViewController.h"

@interface CreateTripViewController ()

@property (weak, nonatomic) IBOutlet UILabel *uploadImageLabel;

@end

@implementation CreateTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    CreateTripViewController *createView = [[CreateTripViewController alloc]initWithNibName:Nil bundle:Nil];
//    [self presentViewController:createView animated:NO completion:nil];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:createView];
//    [self.navigationController pushViewController:navigationController animated:YES];
    
    [self.selectedImage.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.selectedImage.layer setBorderWidth: 0.5];
    self.selectedImage.image = nil;
    self.uploadImageLabel.alpha = 1;
    
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
    // UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
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

- (IBAction)tappedPost:(id)sender {
    /*
    if (self.selectedImage.image != nil) {
    [Post postUserImage:self.selectedImage.image withCaption:self.captionTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Successful post!");
            self.tabBarController.selectedIndex = 0;
            self.captionTextView.text = @"";
            self.selectedImage.image = nil;
            self.uploadImageLabel.alpha = 1;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        }];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error with post"
               message:@"Please select a photo and caption"
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
    }*/
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
