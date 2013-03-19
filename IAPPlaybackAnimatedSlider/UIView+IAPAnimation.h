//
//  UIView+IAPAnimation.h
//  IAP
//
//  Created by Esteban Uribe on 2/16/13.
//  Copyright (c) 2013 Esteban Uribe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum IAPSlideViewOption {
    IAPSlideViewTopOption,
    IAPSlideViewBottomOption,
    IAPSlideViewLeftOption,
    IAPSlideViewRightOption
} IAPSlideViewOption;

@interface UIView (IAPAnimation)

- (void)addSubviewWithFadeAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option;
- (void)addSubviewWithSlideAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option;
- (void)addSubviewWithSlideAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option completion:(void (^)(BOOL finished))completion;
- (void)addSubviewWithSlideAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option slideFrom:(IAPSlideViewOption)slideOption completion:(void (^)(BOOL finished))completion;

- (void)slideOutAndRemoveSubview:(UIView *)slideOutView replacementView:(UIView *)replacementView;


- (void)slideInSubview:(UIView *)slideInView removeSubView:(UIView *)view;
- (void)slideInSubview:(UIView *)slideInView removeSubView:(UIView *)view completion:(void (^)(void))completion;
- (void)slideInSubview:(UIView *)slideInView removeSubView:(UIView *)view completion:(void (^)(void))completion option:(IAPSlideViewOption)option;

- (void)slideOutView:(UIView *)slideOutView slideIn:(UIView *)slideInView completion:(void (^)(void))completion;
- (void)slideOutView:(UIView *)slideOutView slideIn:(UIView *)slideInView;

- (void)resizeToFrame:(CGRect)frame;

- (void)rollOutViewToFrame:(CGRect)frame timeOutRollBack:(NSTimeInterval)timeOut;

- (void)rollOutViewToFrame:(CGRect)frame rollOutAnimations:(void (^)(void))rollOutAnimations rollOutCompletion:(void (^)(BOOL))rollOutCompletion;

- (void)rollOutViewToFrame:(CGRect)frame timeOutRollBack:(NSTimeInterval)timeOut rollOutAnimations:(void (^)(void))rollOutAnimations rollOutCompletion:(void (^)(BOOL))rollOutCompletion rollBackAnimations:(void (^)(void))rollBackAnimations rollBackCompletion:(void (^)(BOOL))rollBackCompletion;

- (void)shakeView;

- (void)removeWithSinkAnimation:(int)steps;
- (void)removeWithSinkAnimationRotateTimer:(NSTimer*) timer;

- (UIImage*)imageWithViewContents;

@end
