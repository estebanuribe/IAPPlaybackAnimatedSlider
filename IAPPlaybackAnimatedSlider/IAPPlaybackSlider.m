//
//  IAPPlaybackSlider.m
//  IAPPlaybackAnimatedSlider
//
//  Created by Esteban Uribe on 3/10/13.
//  Copyright (c) 2013 Esteban Uribe. All rights reserved.
//

#import "IAPPlaybackSlider.h"

#import "UIView+IAPAnimation.h"

@implementation IAPPlaybackSlider

- (id)init {
    CGRect frame = CGRectMake(0, 0, 100.0, 44.0);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playButton.frame = CGRectMake(0, 0, 50, 44);
        [self.playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        self.playButton.backgroundColor = [UIColor clearColor];
        [self.playButton addTarget:self action:@selector(rolloutView:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.playButton];
        self.playbackControlsView = [[UIView alloc] initWithFrame:CGRectMake(50.0, 0, 50.0, 44.0)];
        self.playbackControlsView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.playbackControlsView];
        NSArray *constraints = @[
           //self.playButton
           [NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0],
           [NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
           [NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.playButton.frame.size.width],
           //self.playbackControlsView
           [NSLayoutConstraint constraintWithItem:self.playbackControlsView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:50.0],
           [NSLayoutConstraint constraintWithItem:self.playbackControlsView attribute:NSLayoutAttributeTop  relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
           [NSLayoutConstraint constraintWithItem:self.playbackControlsView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0],
           [NSLayoutConstraint constraintWithItem:self.playbackControlsView attribute:NSLayoutAttributeBottom  relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]
                               ];
        [self addConstraints:constraints];
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {

    [self.playbackControlsView setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.startTime = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 50,21)];
    [self.startTime setFont:[UIFont boldSystemFontOfSize:12.0]];
    [self.startTime setTextColor:[UIColor darkGrayColor]];
    [self.startTime setBackgroundColor:[UIColor clearColor]];
    [self.startTime setText:@"0:00:00"];
    [self.startTime setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.playbackControlsView addSubview:self.startTime];
    
    self.endTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, 50, 21)];
    [self.endTime setFont:[UIFont boldSystemFontOfSize:12.0]];
    [self.endTime setTextColor:[UIColor darkGrayColor]];
    [self.endTime setBackgroundColor:[UIColor clearColor]];
    [self.endTime setText:@"0:45:00"];
    [self.endTime setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.playbackControlsView addSubview:self.endTime];
        
//    layoutConstraint.priority = NSLayoutPriorityRequired;
    
    self.playbackSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 4, 50, 23)];
    self.playbackSlider.hidden = YES;
    [self.playbackSlider setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UIEdgeInsets edgeInsets;
    edgeInsets.left = 5.0;
    edgeInsets.right = 5.0;
    UIImage *leftCap = [[UIImage imageNamed:@"maxslider.png"] resizableImageWithCapInsets:edgeInsets];
    UIImage *rightCap = [[UIImage imageNamed:@"minslider.png"] resizableImageWithCapInsets:edgeInsets];
    [self.playbackSlider setMaximumTrackImage:leftCap forState:UIControlStateNormal];
    [self.playbackSlider setMinimumTrackImage:rightCap forState:UIControlStateNormal];
    [self.playbackSlider setThumbImage:[UIImage imageNamed:@"thumb.png"] forState:UIControlStateNormal];
    [self.playbackControlsView addSubview:self.playbackSlider];
    
    NSArray *constraints = @[
         //self.startTime constraints
         [NSLayoutConstraint constraintWithItem:self.startTime attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.playbackControlsView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0],
         [NSLayoutConstraint constraintWithItem:self.startTime attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.startTime.frame.size.width],
         //self.endTime constraints
         [NSLayoutConstraint constraintWithItem:self.endTime attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.playbackControlsView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0],
         [NSLayoutConstraint constraintWithItem:self.endTime attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.endTime.frame.size.width],
         //self.playbackSlider constraints
         [NSLayoutConstraint constraintWithItem:self.playbackSlider attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.playbackControlsView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:2.0],
         [NSLayoutConstraint constraintWithItem:self.playbackSlider attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.playbackControlsView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-2.0]
     ];
    
    [self.playbackControlsView addConstraints:constraints];
    [self.playbackControlsView updateConstraintsIfNeeded];
}

- (IBAction)rolloutView:(id)sender {
    CGRect frame = self.frame;
    frame.size.width = self.superview.frame.size.width - 10;
    
    self.playbackSlider.alpha = 0.0;
        
    CGRect oldFrame = self.startTime.frame;
    
    self.playbackSlider.maximumValue = 100.0;
    self.playbackSlider.minimumValue = 0.0;
    self.playbackSlider.value = 10.0;
    
    UIButton *trigger = (UIButton *)sender;
    trigger.enabled = NO;
    
    void (^completion)(BOOL) = nil;
    
    void (^animations)() = ^{
        self.playbackSlider.alpha = 1.0;
        self.playbackSlider.hidden = NO;
        self.startTime.frame = self.endTime.frame;
        self.playbackSlider.value = 50.0;
        [self updateConstraintsIfNeeded];
    };
    
    void (^rollBackAnimation)() = ^{
        self.playbackSlider.alpha = 0.0;
        self.startTime.frame = oldFrame;
        self.endTime.hidden = NO;
        [self updateConstraintsIfNeeded];
    };
    
    void (^rollBackCompletion)(BOOL) = ^(BOOL finished) {
        trigger.enabled = YES;
    };
    
    BOOL rollOutAndBack = NO;
    if (!rollOutAndBack) {
        [self rollOutViewToFrame:frame
               rollOutAnimations:animations
               rollOutCompletion:completion];
    }
    else {
        [self rollOutViewToFrame:frame timeOutRollBack:2.0
            rollOutAnimations:animations
            rollOutCompletion:nil
            rollBackAnimations:rollBackAnimation
            rollBackCompletion:rollBackCompletion];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
