//
//  IAPPlaybackSlider.h
//  IAPPlaybackAnimatedSlider
//
//  Created by Esteban Uribe on 3/10/13.
//  Copyright (c) 2013 Esteban Uribe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IAPPlaybackSlider;

@protocol IAPPlaybackSliderDelegate <NSObject>
@required
- (NSTimeInterval)remainingTime;
- (NSTimeInterval)starterTime;
- (void)playButtonPressed:(IAPPlaybackSlider *)slider;
- (void)setHearted:(BOOL)hearted;
- (BOOL)hearted;
@optional
- (void)setStarterTime:(NSTimeInterval)startertime;
- (NSString *)socialDescription;
- (NSString *)socialDescriptionForService:(NSString *)serviceType;
@end

@interface IAPPlaybackSlider : UIView {
    UIActivityViewController *activityViewController;
    UIImageView              *activityViewImageView;
    UIView                   *shareHeartView;
    UIView                   *playbackControlsView;
    UIButton                 *playButton;
    UIButton                 *playbackControlsViewExpander;
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
@property (nonatomic, readonly) BOOL playbackControlsRolledOut;
@property (nonatomic, readonly) BOOL playing;

+ (IAPPlaybackSlider *)playbackSlider;

- (IBAction)rolloutView:(id)sender;
- (IBAction)rollbackView:(id)sender;

- (IBAction)sharePodcast:(id)sender;

- (IBAction)toggleHeart:(id)sender;
@end
