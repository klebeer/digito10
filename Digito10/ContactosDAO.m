//
//  ContactosDAO.m
//  ContactosEC
//
//  Created by Kleber Ayala Leon on 8/12/12.
//  Copyright (c) 2012 Kleber Ayala Leon. All rights reserved.
//

#import "ContactosDAO.h"
#import <AddressBook/AddressBook.h>
#import <QuartzCore/QuartzCore.h>
#import "Contacto.h"



@implementation ContactosDAO
{
    NSArray *contactosOrdenados;
    CFArrayRef allPeople;
}
static ContactosDAO* _sharedContactosDao = nil;

+(ContactosDAO *) singleton
{
    @synchronized(self)
    {
        if (!_sharedContactosDao)
        {
            _sharedContactosDao = [[self alloc] init];
        }
    }
    return _sharedContactosDao;
}

-(NSArray*)listarContactos
{
    
    
    if(contactosOrdenados==nil){
        ABAddressBookRef addressBook = ABAddressBookCreate();
        NSMutableArray *contactos = [[NSMutableArray alloc] init];
        NSMutableArray *listaMoviles=nil;
        __block BOOL accessGranted = NO;
        
        if (ABAddressBookRequestAccessWithCompletion != NULL) { //  iOS6
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                accessGranted = granted;
                dispatch_semaphore_signal(sema);
            });
            
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            dispatch_release(sema);
            
        }
        else {
            accessGranted = YES;
        }
        if (accessGranted) {
            NSArray *thePeople = (NSArray*)CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
            allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
            
            for (int x = 0; x < [thePeople count]; x++) {
                
                Contacto *contacto=[[Contacto alloc] init];
                contacto.indicePersona=x;
                ABRecordRef persona = CFArrayGetValueAtIndex(allPeople, x);
                
                ABMultiValueRef telefonos =ABRecordCopyValue(persona, kABPersonPhoneProperty);
                contacto.nombre= ( NSString *)CFBridgingRelease(ABRecordCopyValue(persona,kABPersonFirstNameProperty));
                NSString* mobile=@"";
                NSString* mobileLabel;
                listaMoviles=[[NSMutableArray alloc] init];
                
                for(CFIndex i = 0; i < ABMultiValueGetCount(telefonos); i++) {
                    mobileLabel = ( NSString*)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(telefonos, i));
                    if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
                    {
                        mobile = ( NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(telefonos, i));
                        [listaMoviles addObject:mobile];
                        
                        
                    }
                    else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
                    {
                        mobile = (  NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(telefonos, i));
                        [listaMoviles addObject:mobile];
                        
                    }
                }
                if (telefonos)
                {
                    CFRelease(telefonos);
                }
                if(contacto.nombre != nil && [listaMoviles count]>0){
                    contacto.apellido= (NSString *)CFBridgingRelease(ABRecordCopyValue(persona, kABPersonLastNameProperty))==nil? @"":(NSString *)CFBridgingRelease(ABRecordCopyValue(persona, kABPersonLastNameProperty));
                    contacto.celulares=listaMoviles;
                    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:listaMoviles
                                                                           forKeys:listaMoviles];
                    contacto.dictionarioCelulares=dictionary;
                    [contactos addObject:contacto];
                }
            }
            CFRelease(allPeople);
            CFRelease(addressBook);
            contactosOrdenados=[contactos sortedArrayUsingSelector:@selector(ordenar:)];
            contactos=nil;
            
        }
        
        
        
    }
    return contactosOrdenados;
}


-(BOOL) actualizarTelefono:(Contacto *)contacto
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
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
    CFRelease(addressBook);
    return FALSE;
}


+(id)alloc
{
    @synchronized([ContactosDAO class])
    {
        NSAssert(_sharedContactosDao == nil, @"Intento de instanciar otro objeto.");
        _sharedContactosDao = [super alloc];
        return _sharedContactosDao;
    }
    
    return nil;
}



@end
