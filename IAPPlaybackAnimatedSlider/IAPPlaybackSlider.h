//
//  IAPPlaybackSlider.h
//  IAPPlaybackAnimatedSlider
//
//  Created by Esteban Uribe on 3/10/13.
//  Copyright (c) 2013 Esteban Uribe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IAPPlaybackSlider : UIView

@property (nonatomic) IBOutlet UIButton *playButton;
@property (nonatomic) UILabel           *startTime;
@property (nonatomic) UILabel           *endTime;
@property (nonatomic) IBOutlet UIView   *playbackControlsView;
@property (nonatomic) UILabel           *currentTime;
@property (nonatomic) UISlider          *playbackSlider;

- (IBAction)rolloutView:(id)sender;
- (IBAction)rollbackView:(id)sender;

@end
