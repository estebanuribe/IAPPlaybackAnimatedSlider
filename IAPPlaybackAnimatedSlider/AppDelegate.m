//
//  AppDelegate.m
//  IAPPlaybackAnimatedSlider
//
//  Created by Esteban Uribe on 3/10/13.
//  Copyright (c) 2013 Esteban Uribe. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

#import "IAPPlaybackSlider.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    self.viewController.view.backgroundColor = [UIColor orangeColor];
//    [self.viewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.window makeKeyAndVisible];
    
//    IAPPlaybackSlider *slider = (IAPPlaybackSlider *)[[NSBundle mainBundle] loadNibNamed:@"IAPPlaybackSlider" owner:self options:NULL][0];
//    [self.viewController.view addSubview:slider];
    IAPPlaybackSlider *slider = [IAPPlaybackSlider playbackSlider];
    [self.viewController.view addSubview:slider];
    hearted = NO;
    [slider setDelegate:self];
    
    NSArray *constraints = @[
        [NSLayoutConstraint constraintWithItem:slider attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.viewController.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:16],
        [NSLayoutConstraint constraintWithItem:slider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.viewController.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
        [NSLayoutConstraint constraintWithItem:slider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:slider.frame.size.height],
        [NSLayoutConstraint constraintWithItem:slider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:slider.frame.size.width]
        ];
    
    [self.viewController.view addConstraints:constraints];
    
    return YES;
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

#pragma mark - IAPPlaybackSlider Delegate
- (NSTimeInterval)starterTime {
    return 0.0;
}

- (NSTimeInterval)remainingTime {
    return 60.0*60.0;
}

- (BOOL)hearted {
    return hearted;
}

- (void)setHearted:(BOOL)heart {
    hearted = heart;
}

- (NSString *)socialDescription {
    return @"This podcast is amazing!";
}

- (void)playButtonPressed:(IAPPlaybackSlider *)slider {
    NSLog(@"Yay I pushed a button!");
}

@end
