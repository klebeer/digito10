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
    NSMutableDictionary *imagesDic ;
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
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
        NSMutableArray *contactos = [[NSMutableArray alloc] init];
        NSMutableArray *listaMoviles=nil;
        NSMutableArray *listaLabels=nil;

        
        for (int x = 0; x < nPeople; x++) {
            Contacto *contacto=[[Contacto alloc] init];
            contacto.indicePersona=x;
            ABRecordRef persona = CFArrayGetValueAtIndex(allPeople, x);
            
            ABMultiValueRef telefonos =ABRecordCopyValue(persona, kABPersonPhoneProperty);
            contacto.nombre= ( NSString *)CFBridgingRelease(ABRecordCopyValue(persona,kABPersonFirstNameProperty));
            NSString* mobile=@"";
            NSString* mobileLabel;
            listaMoviles=[[NSMutableArray alloc] init];
            listaLabels=[[NSMutableArray alloc] init];
            for(CFIndex i = 0; i < ABMultiValueGetCount(telefonos); i++) {
                mobileLabel = ( NSString*)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(telefonos, i));
                if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
                {
                    mobile = ( NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(telefonos, i));
                    [listaMoviles addObject:mobile];
                    [listaLabels addObject:@"mobile"];
                    
                }
                else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
                {
                    mobile = (  NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(telefonos, i));
                    [listaMoviles addObject:mobile];
                    [listaLabels addObject:@"iPhone"];
                    
                }
            }
            if (telefonos)
            {
                CFRelease(telefonos);
            }
            if(contacto.nombre != nil && [listaMoviles count]>0){
                contacto.apellido= (NSString *)CFBridgingRelease(ABRecordCopyValue(persona, kABPersonLastNameProperty))==nil? @"":(NSString *)CFBridgingRelease(ABRecordCopyValue(persona, kABPersonLastNameProperty));
                contacto.celulares=listaMoviles;
                [contactos addObject:contacto];
            }
        }
        CFRelease(allPeople);
        CFRelease(addressBook);
        contactosOrdenados=[contactos sortedArrayUsingSelector:@selector(ordenar:)];
        contactos=nil;
    }
    return contactosOrdenados;
}

-(long) contarContactos
{
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSUInteger nPeople = ABAddressBookGetPersonCount(addressBook);
    CFRelease(allPeople);
    CFRelease(addressBook);
    return nPeople;
}



-(BOOL) actualizarPersona:(Contacto *)contacto
{

//    ABAddressBookRef addressBook = ABAddressBookCreate();
//    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
//    
//    ABRecordRef persona = CFArrayGetValueAtIndex(allPeople, contacto.indicePersona);
//    //primero borro los anteriores
//    
//    
//    ABMutableMultiValueRef listaTelefonos = ABMultiValueCreateMutableCopy (ABRecordCopyValue(persona, kABPersonPhoneProperty));
//    
//    ABMultiValueAddValueAndLabel(listaTelefonos, (__bridge CFTypeRef)_phoneNumber, kABPersonPhoneOtherFAXLabel, NULL);
//    ABRecordSetValue(persona, kABPersonPhoneProperty, listaTelefonos,nil);
//    
//    ABAddressBookRef ab = peoplePicker.addressBook;
//    CFErrorRef* error = NULL;
//    ABAddressBookSave(ab, error);
//    CFRelease(listaTelefonos);
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
