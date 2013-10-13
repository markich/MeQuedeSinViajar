//
//  ViewController.h
//  MeQuedeSinViajar
//
//  Created by Marcos Jesús Vivar on 10/12/13.
//  Copyright (c) 2013 m4rk1ch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "MQSVNotification.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UISwitch *carpoolingSwitch;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIButton *notificationButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *badCompanySegmentedControl;

@property (strong, nonatomic) MQSVNotification *mqsvNotification;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) CLLocationCoordinate2D lastCoordinate;
@property (assign, nonatomic) BOOL isPersonLocated;
@property (assign, nonatomic) BOOL isFacebookSelected;
@property (assign, nonatomic) BOOL isTwitterSelected;

- (IBAction)facebookSelected:(id)sender;
- (IBAction)twitterSelected:(id)sender;

- (IBAction)doSendNotification:(id)sender;

@end
