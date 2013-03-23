//
//  AppDelegate.h
//  IAPPlaybackAnimatedSlider
//
//  Created by Esteban Uribe on 3/10/13.
//  Copyright (c) 2013 Esteban Uribe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IAPPlaybackSlider.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, IAPPlaybackSliderDelegate> {
    BOOL hearted;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
