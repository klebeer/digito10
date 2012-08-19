//
//  AvatarLoader.m
//  Digito10
//
//  Created by Kleber Ayala Leon on 8/18/12.
//  Copyright (c) 2012 Kleber Ayala Leon. All rights reserved.
//

#import "AvatarLoader.h"
#import <AddressBook/AddressBook.h>
#import <QuartzCore/QuartzCore.h>
#import "Contacto.h"
#define kAppIconHeight 48


@implementation AvatarLoader

@synthesize contacto;
@synthesize indexPathInTableView;
@synthesize delegate;



#pragma mark


- (void)startLoad
{

    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    ABRecordRef persona = CFArrayGetValueAtIndex(allPeople, contacto.indicePersona);
    
    NSData *imageData = (NSData*)CFBridgingRelease(ABPersonCopyImageDataWithFormat(persona, kABPersonImageFormatThumbnail));
    
    UIImage *avatar;
    if(imageData)
    {
        avatar = [UIImage imageWithData:imageData];
    }
    else{
        avatar=  [UIImage imageNamed:@"blank_avatar.png"];
    }

    CGSize imageSize = avatar.size;
    UIGraphicsBeginImageContext(imageSize);
    [avatar drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    self.contacto.avatar = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CFRelease(allPeople);
    CFRelease(addressBook);
    avatar=nil;
    imageData=nil;
    [delegate avatarCargado:self.indexPathInTableView];
}

- (void)cancelLoad
{
    self.activeLoad = nil;
}


@end
