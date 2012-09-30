//
//  PrincipalViewController.m
//  Digito10
//
//  Created by Kleber Ayala Leon on 8/13/12.
//  Copyright (c) 2012 Kleber Ayala Leon. All rights reserved.
//

#import "PrincipalViewController.h"
#import "ContactosDAO.h"
#import "ContactosViewController.h"
#import "ActualizarViewController.h"

@interface PrincipalViewController ()


@end

@implementation PrincipalViewController

@synthesize numeroContactos, listarContactosButton,actualizarContactosButton,logoLabel,contactos;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    
    contactos=[[ContactosDAO singleton]  listarContactos];
    
    NSMutableString *numeroContactosLabel=[[NSMutableString alloc] init];
    [numeroContactosLabel appendString: [numeroContactos text]];
    [numeroContactosLabel appendString:@" : "];

    [numeroContactosLabel  appendString:[[NSNumber numberWithInteger:[contactos count]] stringValue]];
    numeroContactos.text=numeroContactosLabel;
    
    logoLabel.gradientStartColor = [UIColor colorWithRed:163.0/255 green:203.0/255 blue:222.0/255 alpha:1.0];
    logoLabel.gradientEndColor = [UIColor whiteColor];
    
    logoLabel.shadowColor = [UIColor blackColor];
    logoLabel.shadowOffset = CGSizeMake(0, 1);
    logoLabel.shadowBlur = 0.5;
    
    [listarContactosButton addTarget:self action:@selector(listarContactosMoviles) forControlEvents:UIControlEventTouchUpInside];
    [actualizarContactosButton addTarget:self action:@selector(actualizarContactos) forControlEvents:UIControlEventTouchUpInside];
    
    
    [super viewDidLoad];
	
}

-(void) listarContactosMoviles
{
    
    
}
-(void)actualizarContactos
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Actualizar Contactos"
                                                    message:@"Se van actualizar los números celulares de sus contactos agregando un dígito más."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancelar"
                                          otherButtonTitles:@"Aceptar", nil];
    
    [alert show];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Aceptar"] && [contactos count]>0)
	{
        ActualizarViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ActualizarViewController"];
        [self.navigationController pushViewController:vc animated:YES];
	}
}

@end
