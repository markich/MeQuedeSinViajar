//
//  ViewController.m
//  MeQuedeSinViajar
//
//  Created by Marcos Jesús Vivar on 10/12/13.
//  Copyright (c) 2013 m4rk1ch. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (void)sendNotification;
- (void)showGreetingsController;
@end

@implementation ViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

}

#pragma mark -
#pragma mark Private Methods

- (void)sendNotification
{
    [[APIService sharedService] sendNotificationWith:self.mqsvNotification andCompletionBlock:^(id returnedObject, NSError *error)
     {
         NSLog(@"JSONResponse: %@", returnedObject);
         
         if (!error)
         {
             [SVProgressHUD dismissWithSuccess:@"Done"];
         }
         else
         {
             [SVProgressHUD dismissWithError:[error localizedDescription]];
         }
         
         [self showGreetingsController];
     }];
}

- (void)showGreetingsController
{
    
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
