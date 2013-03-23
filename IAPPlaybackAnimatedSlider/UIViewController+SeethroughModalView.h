//
//  UIView+SeethroughModalView.h
//  IAPPlaybackAnimatedSlider
//
//  Created by Esteban Uribe on 3/22/13.
//  Copyright (c) 2013 Esteban Uribe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SeethroughModalView)
- (void)presentOverViewController:(UIViewController *)modalViewController animated:(BOOL)animated;
- (void)dismissOverViewControllerAnimated:(BOOL)animated;

@end