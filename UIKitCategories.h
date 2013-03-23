//
//  UIView+FindUIViewController.h
//  IAPPlaybackAnimatedSlider
//
//  Created by Esteban Uribe on 3/21/13.
//  Copyright (c) 2013 Esteban Uribe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FindUIViewController)
- (UIViewController *) firstAvailableUIViewController;
- (id) traverseResponderChainForUIViewController;
@end

