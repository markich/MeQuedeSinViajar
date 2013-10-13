//
//  NotificationViewController.h
//  MeQuedeSinViajar
//
//  Created by Marcos Jesús Vivar on 10/12/13.
//  Copyright (c) 2013 m4rk1ch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *aceptButton;

- (IBAction)doAcceptTriggered:(id)sender;

@end
