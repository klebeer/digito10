//
//  PrincipalViewController.h
//  Digito10
//
//  Created by Kleber Ayala Leon on 8/13/12.
//  Copyright (c) 2012 Kleber Ayala Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXLabel.h"

@interface PrincipalViewController : UIViewController <UIAlertViewDelegate>

@property (assign) IBOutlet UILabel *numeroContactos;
  
@property (nonatomic, strong) IBOutlet FXLabel *logoLabel;

@property (nonatomic,retain)NSArray *contactos;
@property (nonatomic, strong) IBOutlet UIButton *listarContactosButton;

@property (nonatomic, strong) IBOutlet UIButton *actualizarContactosButton;

@end
