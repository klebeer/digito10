//
//  AppDelegate.m
//  Digito10
//
//  Created by Kleber Ayala Leon on 8/12/12.
//  Copyright (c) 2012 Kleber Ayala Leon. All rights reserved.
//

#import "AppDelegate.h"
#import "Contacto.h"

#import "ContactosDAO.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self cargarTema];
    return YES;
}

- (void)cargarTema
{
    UIImage *navBarImage = [UIImage imageNamed:@"menubar.png"];
    
    [[UINavigationBar appearance] setBackgroundImage:navBarImage
                                       forBarMetrics:UIBarMetricsDefault];
    
    
    UIImage *barButton = [[UIImage imageNamed:@"menu-bar-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    
    [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *backButton = [[UIImage imageNamed:@"back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,15,0,8)];
    
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    
    UIImage *minImage = [UIImage imageNamed:@"slider-fill.png"];
    UIImage *maxImage = [UIImage imageNamed:@"slider-track.png"];
    UIImage *thumbImage = [UIImage imageNamed:@"slider-handle.png"];
    
    [[UISlider appearance] setMaximumTrackImage:maxImage
                                       forState:UIControlStateNormal];
    [[UISlider appearance] setMinimumTrackImage:minImage
                                       forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:thumbImage
                                forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:thumbImage
                                forState:UIControlStateHighlighted];
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
