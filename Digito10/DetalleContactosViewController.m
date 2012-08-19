//
//  DetalleContactosViewController.m
//  Digito10
//
//  Created by Kleber Ayala Leon on 8/12/12.
//  Copyright (c) 2012 Kleber Ayala Leon. All rights reserved.
//

#import "DetalleContactosViewController.h"

@interface DetalleContactosViewController ()

@end

@implementation DetalleContactosViewController
@synthesize contacto;

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

@end
