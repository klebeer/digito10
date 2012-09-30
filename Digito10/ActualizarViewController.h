//
//  ActualizarViewController.h
//  Digito10
//
//  Created by Kleber Ayala Leon on 8/19/12.
//  Copyright (c) 2012 Kleber Ayala Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contacto.h"
@class ADVPopoverProgressBar;

@interface ActualizarViewController : UIViewController
@property (nonatomic, strong) ADVPopoverProgressBar* progressBar;
@property (nonatomic,strong ) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *contactos;
@property (nonatomic) int numeroContactos;
@property (nonatomic) NSDecimalNumber *incremento;
@property (nonatomic) int indice;
@property (nonatomic,retain) IBOutlet UILabel *label;
@property (nonatomic,retain) IBOutlet UILabel *nombreContacto;
@property (nonatomic,retain) IBOutlet UILabel *numeroNuevo;

@end

