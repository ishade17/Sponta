//
//  SignInViewController.h
//  Sponta
//
//  Created by Isaac Schaider on 7/13/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

