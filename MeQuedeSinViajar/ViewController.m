//
//  ViewController.m
//  MeQuedeSinViajar
//
//  Created by Marcos Jesús Vivar on 10/12/13.
//  Copyright (c) 2013 m4rk1ch. All rights reserved.
//

#import "ViewController.h"

#import "NotificationViewController.h"

@interface ViewController ()
- (void)sendNotification;
- (void)showNotificationController;
- (void)setMyLocationManager;
@end

@implementation ViewController

@synthesize carpoolingSwitch;
@synthesize facebookButton;
@synthesize twitterButton;
@synthesize notificationButton;
@synthesize badCompanySegmentedControl;

@synthesize mqsvNotification;

@synthesize locationManager;
@synthesize lastCoordinate;
@synthesize isPersonLocated;
@synthesize isFacebookSelected;
@synthesize isTwitterSelected;

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mqsvNotification = [[MQSVNotification alloc] init];
    
    self.isFacebookSelected = NO;
    self.isTwitterSelected = NO;

    [self setMyLocationManager];
}

#pragma mark -
#pragma mark Private Methods

- (void)sendNotification
{
    self.mqsvNotification.notificationCarPooling = (self.carpoolingSwitch.isOn) ? @"YES" : @"NO";
    self.mqsvNotification.notificationCompany = (self.badCompanySegmentedControl.selectedSegmentIndex == 0) ? @"Etacer" : @"Fluviales";
    self.mqsvNotification.notificationLatitude = [NSNumber numberWithDouble:self.lastCoordinate.latitude];
    self.mqsvNotification.notificationLongitude = [NSNumber numberWithDouble:self.lastCoordinate.longitude];
    
    [[APIService sharedService] sendNotificationWith:self.mqsvNotification andCompletionBlock:^(id returnedObject, NSError *error)
     {
         NSLog(@"JSONResponse: %@", returnedObject);
         
         if (!error)
         {
             [SVProgressHUD dismissWithSuccess:@"Done"];
             
             [self showNotificationController];
         }
         else
         {
             [SVProgressHUD dismissWithError:[error localizedDescription]];
         }
     }];
}

- (void)showNotificationController
{
    NotificationViewController *notificationController = [[NotificationViewController alloc] init];
    
    [self presentViewController:notificationController animated:YES completion:nil];
}

- (void)setMyLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
	[self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[self.locationManager setDelegate:(id)self];
    
    self.isPersonLocated = NO;
	
	[self.locationManager startUpdatingLocation];
}

#pragma mark -
#pragma mark IBAction Methods

- (IBAction)facebookSelected:(id)sender
{}

- (IBAction)twitterSelected:(id)sender
{}

- (IBAction)doSendNotification:(id)sender
{
    self.mqsvNotification.notificationCarPooling = (self.carpoolingSwitch.isOn) ? @"YES" : @"NO";
    self.mqsvNotification.notificationCompany = (self.badCompanySegmentedControl.selectedSegmentIndex == 0) ? @"Etacer" : @"Fluviales";
    self.mqsvNotification.notificationLatitude = [NSNumber numberWithDouble:self.lastCoordinate.latitude];
    self.mqsvNotification.notificationLongitude = [NSNumber numberWithDouble:self.lastCoordinate.longitude];
    
    NSString *carpoolingString = (self.carpoolingSwitch.isOn) ? @"Car Pooling: Si!\n" : @"Car Pooling: No!\n";
    NSString *companyString = [NSString stringWithFormat:@"Me dejó un colectivo de: %@!\n",self.mqsvNotification.notificationCompany];
    NSString *geolocationString = [NSString stringWithFormat:@"Geolocalización: Latitude %f\nLongitude %f\n",[self.mqsvNotification.notificationLatitude doubleValue], [self.mqsvNotification.notificationLongitude doubleValue]];
    
    NSString *messageString = [NSString stringWithFormat:@"%@ %@ %@",carpoolingString, companyString, geolocationString];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Me Quedé Sin Viajar" message:[NSString stringWithFormat:@"Desea enviar ésta notificación con la siguiente configuración: \n%@", messageString] delegate:self cancelButtonTitle:@"Review" otherButtonTitles:@"Continue",nil];
    [alert setTag:MQSV_MAIN_ALERT_TAG];
    [alert setDelegate:(id)self];
    [alert show];
}

#pragma mark -
#pragma mark CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	if (self.isPersonLocated == YES)
    {
        return;
    }
	
	self.isPersonLocated = YES;
	
	CLLocationCoordinate2D coordinate = [newLocation coordinate];
	
	self.lastCoordinate = coordinate;
	
	[self.locationManager stopUpdatingLocation];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location failed!"
                                                    message:[error localizedDescription]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert setDelegate:nil];
	[alert show];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark -
#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == MQSV_MAIN_ALERT_TAG)
    {
        switch (buttonIndex)
        {
            case 0:
            {
                NSLog(@"The query is to be reviewed!");
            }
                break;
            case 1:
            {
                [self sendNotification];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
