//
//  EditProfileViewController.m
//  Sponta
//
//  Created by Isaac Schaider on 7/28/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "EditProfileViewController.h"
#import "Post.h"
#import <Parse/Parse.h>

@interface EditProfileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addProfileImageButton;
@property (weak, nonatomic) IBOutlet UIButton *captureProfileImageButton;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFUser *currentUser = [PFUser currentUser];
    self.usernameTextField.text = currentUser.username;
    
    [self configureProfilePicView:currentUser];
    [self configureName:currentUser];
    [self configureBio:currentUser];
}

- (void)configureProfilePicView:(PFUser *)currentUser {
    self.profilePicView.layer.cornerRadius = self.profilePicView.frame.size.height / 2;
    [self.profilePicView.layer setBorderColor: [[UIColor blueColor] CGColor]];
    [self.profilePicView.layer setBorderWidth: 1.0];
    
    if ([currentUser objectForKey:@"profileImage"]) {
        self.profilePicView.file = [currentUser objectForKey:@"profileImage"];
        [self.profilePicView loadInBackground];
    }
}

- (void)configureName:(PFUser *)currentUser {
    if ([currentUser objectForKey:@"name"]) {
        self.nameTextField.text = [currentUser objectForKey:@"name"];
    }
}

- (void)configureBio:(PFUser *)currentUser {
    if ([currentUser objectForKey:@"bio"]) {
        self.bioTextField.text = [currentUser objectForKey:@"bio"];
    }
}

    
- (IBAction)tappedAddProfileImage:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}
- (IBAction)tappedCaptureProfileImage:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerCameraDeviceFront;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    // Do something with the images (based on your use case)
    self.profilePicView.image = originalImage;
    
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"profileImage"] = [Post getPFFileFromImage:[self resizeImage:self.profilePicView.image withSize:CGSizeMake(100, 100)]];
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Profile picture updated");
        } else {
            NSLog(@"Error updating profile picture: %@", error.localizedDescription);
        }
    }];
    
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

- (IBAction)tappedEditNameField:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"name"] = self.nameTextField.text;
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Name updated");
        } else {
            NSLog(@"Error updating name: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)tappedEditUsername:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    currentUser.username = self.usernameTextField.text;
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"username updated");
        } else {
            NSLog(@"Error updating username: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)tappedEditBio:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"bio"] = self.bioTextField.text;
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Bio updated");
        } else {
            NSLog(@"Error updating bio: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)tappedUpdate:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
