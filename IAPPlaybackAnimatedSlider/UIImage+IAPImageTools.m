//
//  UIImage+IAPImageTools.m
//  IAPPlaybackAnimatedSlider
//
//  Created by Esteban Uribe on 3/22/13.
//  Copyright (c) 2013 Esteban Uribe. All rights reserved.
//

#import "UIImage+IAPImageTools.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (IAPImageTools)

+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
