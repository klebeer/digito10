//
//  ActualizarViewController.m
//  Digito10
//
//  Created by Kleber Ayala Leon on 8/19/12.
//  Copyright (c) 2012 Kleber Ayala Leon. All rights reserved.
//

#import "ActualizarViewController.h"
#import "ADVPopoverProgressBar.h"
#import "ContactosDAO.h"


@interface ActualizarViewController ()
{
    CFArrayRef allPeople;
    ABAddressBookRef addressBook;
}

@end

@implementation ActualizarViewController

@synthesize progressBar,scrollView,contactos,numeroContactos,incremento,indice,nombreContacto;

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
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat height = CGRectGetHeight(screen);
    self.contactos=[NSMutableArray arrayWithArray: [[ContactosDAO singleton] listarContactos]];
    self.numeroContactos=[contactos count];
    self.incremento=[[NSDecimalNumber alloc] initWithDouble:(double)1/(double)numeroContactos];
    self.progressBar = [[ADVPopoverProgressBar alloc] initWithFrame:CGRectMake(10, (height/2)-30, 292, 28)];
    [progressBar setProgress:0.0];
    self.indice=0;
    [self.scrollView addSubview:progressBar];
    addressBook = ABAddressBookCreate();
    allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    self.label.text=@"Actualizando...";
    [self performSelectorOnMainThread:@selector(actualizarContactos) withObject:nil waitUntilDone:NO];
    
    
}

-(void) respaldarContactos

{
    
    NSDecimalNumber *actual = [[NSDecimalNumber alloc] initWithDouble:[progressBar progress]];
    
    if (indice<numeroContactos) {
        if (indice==numeroContactos-1) {
            progressBar.progress=1;
        }
        else
        {
            progressBar.progress=[[actual decimalNumberByAdding:incremento] doubleValue];
        }
        
        Contacto *contacto=[contactos objectAtIndex:indice];
        [self.nombreContacto setText:contacto.nombreCompleto];
        [self respaldar:contacto];
        indice++;
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(respaldarContactos) userInfo:nil repeats:NO];
        
    }
    else{
        
        self.label.text=@"Actualizando...";
        progressBar.progress=0.0;
        self.indice=0;
        [self.nombreContacto setText:@""];
        [self performSelectorOnMainThread:@selector(actualizarContactos) withObject:nil waitUntilDone:NO];
    }
    
}


-(void) respaldar:(Contacto *) contacto
{
    
    NSMutableDictionary *jsonC = [[NSMutableDictionary alloc] init] ;
    [jsonC setObject: [NSString stringWithFormat:@"%d", contacto.indicePersona] forKey: @"indice"];
    [jsonC setObject: [contacto celulares] forKey: @"celulares"];
    //[jsonC setObject: [contacto labels] forKey: @"labels"];
    
    // NSString *jAnswersJSONFormat = [jContactos JSONString];
    // NSLog(@"JSON: %@",jAnswersJSONFormat);
    
}

-(void) actualizarContactos
{
    
    NSDecimalNumber *actual = [[NSDecimalNumber alloc] initWithDouble:[progressBar progress]];
    
    if (indice<numeroContactos) {
        if (indice==numeroContactos-1) {
            progressBar.progress=1;
        }
        else
        {
            progressBar.progress=[[actual decimalNumberByAdding:incremento] doubleValue];
        }
        
        Contacto *contacto=[contactos objectAtIndex:indice];
        [self.nombreContacto setText:contacto.nombreCompleto];
        [self.numeroNuevo setText:[self actualizarTelefono:contacto]];
        indice++;
        
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(actualizarContactos) userInfo:nil repeats:NO];
        
    }
    else{
        
        self.label.text=@"Listo!!!!...";
        [self.nombreContacto setText:@""];
        [self.numeroNuevo setText:@""];
        CFRelease(allPeople);
        CFRelease(addressBook);
        
    }
    
}

-(NSString*) actualizarTelefono:(Contacto *)contacto
{
    ABRecordRef persona = CFArrayGetValueAtIndex(allPeople, [contacto indicePersona]);
    ABMultiValueRef telefonos =ABRecordCopyValue(persona, kABPersonPhoneProperty);
    NSString* mobile=@"";
    NSString* mobileActualizado=@"";
    CFErrorRef error = NULL;
    
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutableCopy(telefonos);
    for(CFIndex i = 0; i < ABMultiValueGetCount(telefonos); i++) {
        mobile = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(telefonos, i));
        
        //actualizo solo los celulares
        if([[contacto dictionarioCelulares] objectForKey:mobile])
        {
            mobileActualizado=[contacto  generarNumeroNuevo:mobile];
            ABMultiValueReplaceValueAtIndex(multiPhone, (__bridge CFTypeRef)(mobileActualizado), i);
            ABRecordSetValue(persona, kABPersonPhoneProperty, multiPhone,nil);
            
        }
        
    }
    ABAddressBookSave(addressBook, &error);
    CFRelease(multiPhone);
    CFRelease(telefonos);
    return mobileActualizado;
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
