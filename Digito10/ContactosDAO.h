//
//  ContactosDAO.h
//  ContactosEC
//
//  Created by Kleber Ayala Leon on 8/12/12.
//  Copyright (c) 2012 Kleber Ayala Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contacto.h"

@interface ContactosDAO : NSObject


+(ContactosDAO *) singleton;
-(NSArray*)listarContactos;
-(long) contarContactos;
-(BOOL) actualizarPersona:(Contacto *)contacto;

@end

