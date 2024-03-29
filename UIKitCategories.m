//
//  UIView+FindUIViewController.m
//  IAPPlaybackAnimatedSlider
//
//  Created by Esteban Uribe on 3/21/13.
//  Copyright (c) 2013 Esteban Uribe. All rights reserved.
//

#import "UIKitCategories.h"

@implementation UIView (FindUIViewController)
- (UIViewController *) firstAvailableUIViewController {
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}
@end
