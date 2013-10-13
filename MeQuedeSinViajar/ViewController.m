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
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

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
         
         [self.resultsTable reloadData];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
