//
//  AvatarLoader.h
//  Digito10
//
//  Created by Kleber Ayala Leon on 8/18/12.
//  Copyright (c) 2012 Kleber Ayala Leon. All rights reserved.
//



@class Contacto;
@class ContactosViewController;

@protocol AvatarLoaderDelegate;

@interface AvatarLoader : NSObject
{
    Contacto *contacto;
    NSIndexPath *indexPathInTableView;
   __unsafe_unretained  id <AvatarLoaderDelegate> delegate;

}

@property (nonatomic, retain) Contacto *contacto;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign) id <AvatarLoaderDelegate> delegate;

@property (nonatomic, retain) NSMutableData *activeLoad;

- (void)startLoad;
- (void)cancelLoad;

@end

@protocol AvatarLoaderDelegate

- (void)avatarCargado:(NSIndexPath *)indexPath;

@end