//
//  UIView+IAPAnimation.m
//  IAP
//
//  Created by Esteban Uribe on 2/16/13.
//  Copyright (c) 2013 Esteban Uribe. All rights reserved.
//

#import "UIView+IAPAnimation.h"

#import <QuartzCore/CALayer.h>
#import <QuartzCore/CAAnimation.h>

@implementation UIView (IAPAnimation)

// add with a fade-in effect
- (void)addSubviewWithFadeAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option {
	view.alpha = 0.0;	// make the view transparent
	[self addSubview:view];	// add it
	[UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{view.alpha = 1.0;}
                     completion:nil];	// animate the return to visible
}

- (void)addSubviewWithSlideAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option {
    [self addSubviewWithSlideAnimation:view duration:secs option:option completion:nil];
}

- (void)addSubviewWithSlideAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option completion:(void (^)(BOOL finished))completion {
    [self addSubviewWithSlideAnimation:view duration:secs option:option slideFrom:IAPSlideViewLeftOption completion:completion];
}

- (void)addSubviewWithSlideAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option slideFrom:(IAPSlideViewOption)slideOption completion:(void (^)(BOOL finished))completion {

    __block CGFloat offsetX = view.frame.size.width;
    __block CGFloat offsetY = view.frame.size.height;
    __block CGAffineTransform saveTransform = view.transform;

    CGAffineTransform transform = CGAffineTransformIdentity;
    
    if(slideOption == IAPSlideViewTopOption)         transform = CGAffineTransformMakeTranslation(0, -offsetY);
    else if(slideOption == IAPSlideViewBottomOption) transform = CGAffineTransformMakeTranslation(0, offsetY);
    else if(slideOption == IAPSlideViewLeftOption)   transform = CGAffineTransformMakeTranslation(-offsetX, 0);
    else if(slideOption == IAPSlideViewRightOption)  transform = CGAffineTransformMakeTranslation(offsetX, 0);
    
    view.transform = transform;
    [self addSubview:view];
    [UIView animateWithDuration:secs
                     animations:^{ view.transform = saveTransform; }
                     completion:completion];
}

- (void)slideInSubview:(UIView *)slideInView removeSubView:(UIView *)view {
    [self slideInSubview:slideInView removeSubView:view completion:nil option:IAPSlideViewLeftOption];
}

- (void)slideInSubview:(UIView *)slideInView removeSubView:(UIView *)view completion:(void (^)(void))completion {
    [self slideInSubview:slideInView removeSubView:view completion:completion option:IAPSlideViewLeftOption];
}

- (void)slideInSubview:(UIView *)slideInView removeSubView:(UIView *)view completion:(void (^)(void))completion option:(IAPSlideViewOption)option {
    __block CGFloat offsetX = view.frame.size.width;
    __block CGFloat offsetY = view.frame.size.height;
    __block CGAffineTransform saveTransform = slideInView.transform;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    if(option == IAPSlideViewTopOption)    transform = CGAffineTransformMakeTranslation(0, -offsetY);
    else if(option == IAPSlideViewBottomOption) transform = CGAffineTransformMakeTranslation(0, offsetY);
    else if(option == IAPSlideViewLeftOption)   transform = CGAffineTransformMakeTranslation(-offsetX, 0);
    else if(option == IAPSlideViewRightOption)  transform = CGAffineTransformMakeTranslation(offsetX, 0);
    
    slideInView.hidden = YES;
    [self addSubview:slideInView];

    slideInView.transform = transform;
    slideInView.hidden = NO;
    
    [UIView animateWithDuration:0.5
                     animations:^{ slideInView.transform = saveTransform; }
                     completion:^(BOOL finished) {
                         [view removeFromSuperview];
                         [slideInView setNeedsDisplay];
                         completion();
                     }];
    
}

- (void)slideOutAndRemoveSubview:(UIView *)slideOutView replacementView:(UIView *)replacementView {
    __block CGFloat offsetX = slideOutView.frame.size.width;
    __block CGAffineTransform transform = CGAffineTransformMakeTranslation(-offsetX, 0);
    __block CGAffineTransform original = slideOutView.transform;
    
    [self addSubview:replacementView];
    [self sendSubviewToBack:replacementView];

    [UIView animateWithDuration:0.5
                     animations:^{ slideOutView.transform = transform; }
                     completion:^(BOOL finished) {
                         [slideOutView removeFromSuperview];
                         slideOutView.transform = original;
                         [replacementView setNeedsDisplay];
                     }];
}

- (void)slideOutView:(UIView *)slideOutView slideIn:(UIView *)slideInView {
    [self slideOutView:slideOutView slideIn:slideInView completion:nil];
}

- (void)slideOutView:(UIView *)slideOutView slideIn:(UIView *)slideInView completion:(void (^)(void))completion{
    __block CGFloat offsetX = slideOutView.frame.size.width;
    __block CGAffineTransform outTransform = CGAffineTransformMakeTranslation(-offsetX, 0);
    __block CGAffineTransform outOriginal = slideOutView.transform;
    __block CGAffineTransform inTransform = CGAffineTransformMakeTranslation(offsetX, 0);
    __block CGAffineTransform inOriginal = slideInView.transform;
    
    slideInView.hidden = YES;
    [self addSubview:slideInView];
    [self sendSubviewToBack:slideInView];
    slideInView.transform = inTransform;
    slideInView.hidden = NO;

    [UIView animateWithDuration:0.5
                     animations:^{
                         slideOutView.transform = outTransform;
                         slideInView.transform  = inOriginal;
                     }
                     completion:^(BOOL finished) {
                         [slideOutView removeFromSuperview];
                         slideOutView.transform = outOriginal;
                         [slideInView setNeedsDisplay];
                         if (completion) completion();
                     }];
}

- (void)shakeView {
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.1];
    [animation setRepeatCount:5];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([self center].x - 5.0f, [self center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([self center].x + 5.0f, [self center].y)]];
    [[self layer] addAnimation:animation forKey:@"position"];
}

- (void)resizeToFrame:(CGRect)frame {
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = frame;
    }];
}

- (void)rollOutViewToFrame:(CGRect)frame rollOutAnimations:(void (^)(void))rollOutAnimations rollOutCompletion:(void (^)(BOOL))rollOutCompletion {
    __block CGRect saveFrame = self.frame;
    [self setNeedsUpdateConstraints];
    /*[UIView animateWithDuration:0.5 animations:^{
        self.frame = frame;
        if(rollOutAnimations) rollOutAnimations();
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(rollOutCompletion) rollOutCompletion(finished);
    }];*/
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.frame = frame;
        if(rollOutAnimations) rollOutAnimations();
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(rollOutCompletion) rollOutCompletion(finished);
    }];
}

- (void)rollOutViewToFrame:(CGRect)frame timeOutRollBack:(NSTimeInterval)timeOut rollOutAnimations:(void (^)(void))rollOutAnimations rollOutCompletion:(void (^)(BOOL))rollOutCompletion rollBackAnimations:(void (^)(void))rollBackAnimations rollBackCompletion:(void (^)(BOOL))rollBackCompletion {
    __block CGRect saveFrame = self.frame;
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction
    animations:^{
        self.frame = frame;
        rollOutAnimations();
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            if(rollOutCompletion) rollOutCompletion(finished);
            [UIView animateWithDuration:0.5 delay:timeOut options:UIViewAnimationOptionAllowUserInteraction
            animations:^{
                self.frame = saveFrame;
                rollBackAnimations();
                [self layoutIfNeeded];
            } completion:rollBackCompletion];
        }
    }];
}

- (void)rollOutViewToFrame:(CGRect)frame timeOutRollBack:(NSTimeInterval)timeOut {
    [self rollOutViewToFrame:frame timeOutRollBack:timeOut rollOutAnimations:nil rollOutCompletion:nil rollBackAnimations:nil rollBackCompletion:nil];
}

@end
