//
//  ContactosViewController.h
//  ContactosEC
//
//  Created by Kleber Ayala Leon on 8/11/12.
//  Copyright (c) 2012 Kleber Ayala Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvatarLoader.h"

@interface ContactosViewController : UITableViewController<UIScrollViewDelegate, AvatarLoaderDelegate>
{
    NSMutableDictionary *imageAvatarsInProgress;
    NSMutableArray *contactos;
}
@property (nonatomic, retain) NSMutableArray *contactos;
@property (nonatomic, retain) NSMutableDictionary *imageAvatarsInProgress;

@end
