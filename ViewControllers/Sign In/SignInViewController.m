//
//  SignInViewController.m
//  Sponta
//
//  Created by Isaac Schaider on 7/13/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "SignInViewController.h"
#import <Parse/Parse.h>
#import "Post.h"
#import "FriendsList.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)tappedLogin:(id)sender {
    [self loginUser];
}

- (void)loginUser {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            //NSLog(@"User log in failed: %@", error.localizedDescription);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error with login"
                   message:@"Please try logging in again"
            preferredStyle:(UIAlertControllerStyleAlert)];

            // create an OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                     // handle response here.
                                                             }];
            // add the OK action to the alert controller
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:^{
            }];
        } else {
            NSLog(@"User logged in successfully");
            NSLog(@"current: %@", [PFUser currentUser]);
            // display view controller that needs to shown after successful login
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (IBAction)tappedSignUp:(id)sender {
    [self registerUser];
}


- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameTextField.text;
    newUser.password = self.passwordTextField.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if ([self.usernameTextField.text isEqual:@""] || [self.passwordTextField.text isEqual:@""]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Empty username or password"
                   message:@"Please make sure both the username and password are entered"
            preferredStyle:(UIAlertControllerStyleAlert)];

            // create an OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // handle response here.
            }];
            // add the OK action to the alert controller
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
        } else if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error with sign up"
                   message:@"Please try signing in again"
            preferredStyle:(UIAlertControllerStyleAlert)];

            // create an OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                     // handle response here.
                                                             }];
            // add the OK action to the alert controller
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
        } else {
            NSLog(@"User registered successfully");
            // manually segue to logged in view
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"User registered successfully");
                    [FriendsList createFriendsList:newUser withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                        if (succeeded) {
                            NSLog(@"Successfully created newUser's friend list!");
                        } else {
                            NSLog(@"Error creating newUser's friend list: %@", error.localizedDescription);
                        }
                    }];
                } else {
                    NSLog(@"Error registering user: %@", error.localizedDescription);
                }
            }];
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

@end
