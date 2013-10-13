//
//  ViewController.h
//  MeQuedeSinViajar
//
//  Created by Marcos Jesús Vivar on 10/12/13.
//  Copyright (c) 2013 m4rk1ch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) UISwitch *carpoolingSwitch;
@property (strong, nonatomic) UIButton *facebookButton;
@property (strong, nonatomic) UIButton *twitterButton;
@property (strong, nonatomic) UIButton *notificationButton;
@property (strong, nonatomic) UISegmentedControl *badCompanySegmentedControl;

@end
