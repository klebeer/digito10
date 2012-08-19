//
//  Contacto.m
//  ContactosEC
//
//  Created by Kleber Ayala Leon on 8/11/12.
//  Copyright (c) 2012 Kleber Ayala Leon. All rights reserved.
//

#import "Contacto.h"

@implementation Contacto
{
    NSMutableArray *listaMoviles;
    
}
@synthesize nombre,apellido, celulares,indicePersona,labels,avatar;

-(NSString *)nombreCompleto
{
    NSMutableString* nombreCompleto = [NSMutableString string];
    [nombreCompleto appendString:self.nombre];
    [nombreCompleto appendString:@" "];
    [nombreCompleto appendString:self.apellido];
	
    return nombreCompleto;
}

- (NSComparisonResult)ordenar:(Contacto *)otherObject
{
    return [self.nombre compare:otherObject.nombre];
}

-(NSString *) generarNumero:(NSString *)numero

{
    
    NSMutableString *nuevoNumero = [[NSMutableString alloc] init];
    numero = [numero stringByReplacingOccurrencesOfString:@" " withString:@""];
    numero = [numero stringByReplacingOccurrencesOfString:@"(" withString:@""];
    numero = [numero stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    if([numero hasPrefix:@"+"] && [[numero substringWithRange:NSMakeRange(0, 4)]isEqualToString: @"+593"])
    {
        //solo los que empiezan con +593
        [nuevoNumero appendString:[numero substringWithRange:NSMakeRange(0, 4)]];
        [nuevoNumero appendString:@"9"];
        if([[numero substringWithRange:NSMakeRange(4,1)] isEqual:@"0"])
        {
            [nuevoNumero appendString:[numero substringFromIndex:5]];
        }else
        {
            [nuevoNumero appendString:[numero substringFromIndex:4]];
        }
        
    }else
        if([[numero substringWithRange:NSMakeRange(0, 3)]isEqualToString: @"593"])
        {
            //solo los que empiezan con +593
            [nuevoNumero appendString:[numero substringWithRange:NSMakeRange(0, 3)]];
            [nuevoNumero appendString:@"9"];
            if([[numero substringWithRange:NSMakeRange(3,1)] isEqual:@"0"])
            {
                [nuevoNumero appendString:[numero substringFromIndex:4]];
            }else
            {
                [nuevoNumero appendString:[numero substringFromIndex:3]];
            }
            
        }else
            if([numero hasPrefix:@"0"])
            {
                [nuevoNumero appendString:@"09"];
                [nuevoNumero appendString:[numero substringFromIndex:1]];
                
            }else
            {
                [nuevoNumero appendString:numero];
            }
    return [nuevoNumero description];
}

-(NSMutableArray *) listarCelularesActualizados
{
    listaMoviles=  [NSMutableArray arrayWithCapacity:[celulares count]];
    for(int i=0;i<[celulares count];i++)
    {
        [listaMoviles addObject:  [self generarNumero:[celulares objectAtIndex:i]]];
    }
    
    return listaMoviles;
}



@end
