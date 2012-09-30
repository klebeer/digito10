//
//  Contacto.h
//  ContactosEC
//
//  Created by Kleber Ayala Leon on 8/11/12.
//  Copyright (c) 2012 Kleber Ayala Leon. All rights reserved.
//

#import <AddressBook/AddressBook.h>

@interface Contacto : NSObject

@property (nonatomic, retain) NSString *nombre;
@property (nonatomic, retain) NSString *apellido;
@property (nonatomic, retain) NSMutableArray *celulares;
@property (nonatomic, retain) NSDictionary *dictionarioCelulares;
@property (nonatomic) int indicePersona;
@property (nonatomic, retain) UIImage *avatar;


-(NSString *)nombreCompleto;

-(NSComparisonResult)ordenar:(Contacto *)otherObject;

-(long ) contarMoviles;

-(NSString *) generarNumeroNuevo:(NSString *)numero;

@end
