//
//  IAPPlaybackSlider.h
//  IAPPlaybackAnimatedSlider
//
//  Created by Esteban Uribe on 3/10/13.
//  Copyright (c) 2013 Esteban Uribe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IAPPlaybackSliderDelegate <NSObject>
- (NSTimeInterval)remainingTime;
- (NSTimeInterval)starterTime;
- (void)setStarterTime:(NSTimeInterval)startertime;
- (void)setHearted:(BOOL)hearted;
- (BOOL)hearted;
@end

@interface IAPPlaybackSlider : UIView {
    UIActivityViewController *activityViewController;
    UIImageView              *activityViewImageView;
    UIView                   *shareHeartView;
    UIView                   *playbackControlsView;
    UIButton                 *playButton;
    UILabel                  *startTime;
    UILabel                  *endTime;
    UILabel                  *currentTime;
    UISlider                 *playbackSlider;
    NSLayoutConstraint       *playbackControlsViewWidthConstraint;
    NSLayoutConstraint       *heartShareViewWidthConstraint;
    NSLayoutConstraint       *heartButtonWidthConstraint;
    NSLayoutConstraint       *shareButtonWidthConstraint;
    UIButton                 *shareButton;
    UIButton                 *heartButton;
}

@property (nonatomic, weak) NSObject<IAPPlaybackSliderDelegate> *delegate;

+ (IAPPlaybackSlider *)playbackSlider;

- (IBAction)rolloutView:(id)sender;
- (IBAction)rollbackView:(id)sender;

- (IBAction)sharePodcast:(id)sender;

- (IBAction)toggleHeart:(id)sender;
@end
