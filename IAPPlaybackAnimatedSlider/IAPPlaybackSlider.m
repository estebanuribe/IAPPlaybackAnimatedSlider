//
//  IAPPlaybackSlider.m
//  IAPPlaybackAnimatedSlider
//
//  Created by Esteban Uribe on 3/10/13.
//  Copyright (c) 2013 Esteban Uribe. All rights reserved.
//

#import "IAPPlaybackSlider.h"

//#import "UIView+IAPAnimation.h"
//#import "UIImage+IAPImageTools.h"

#import "UIKitCategories.h"

//#import "UIViewController+SeethroughModalView.h"

static IAPPlaybackSlider *playbackSlider = nil;

@interface IAPPlaybackSlider (PRIVATECLASSMETHODS)
- (void)setupPlaybackControls;
- (void)setupShareHeartButtons;
@end

@implementation IAPPlaybackSlider

+ (IAPPlaybackSlider *)playbackSlider {
    if (!playbackSlider) {
        playbackSlider = [[IAPPlaybackSlider alloc] init];
    }
    return playbackSlider;
}

- (id)init {
    CGRect frame = CGRectMake(16, 0, 288.0, 44.0);
    self = [super initWithFrame:frame];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.backgroundColor = [UIColor lightGrayColor];
        self->playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self->playButton.frame = CGRectMake(4.0, 0, 42.0, 44.0);
        [self->playButton setImage:[UIImage imageNamed:@"Playback.png"] forState:UIControlStateNormal];
        self->playButton.backgroundColor = [UIColor clearColor];
        [self->playButton addTarget:self action:@selector(rolloutView:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self->playButton];
        self->playbackControlsView = [[UIView alloc] initWithFrame:CGRectMake(46.0, 0, 50.0, 44.0)];
        self->playbackControlsView.backgroundColor = [UIColor clearColor];
        [self->playbackControlsView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self->playbackControlsView];
        
        self->playbackControlsViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self->playbackControlsView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self->playbackControlsView.frame.size.width];
        NSArray *constraints = @[
           //### self.playButton
           [NSLayoutConstraint constraintWithItem:self->playButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:self->playButton.frame.origin.x],
           [NSLayoutConstraint constraintWithItem:self->playButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
           [NSLayoutConstraint constraintWithItem:self->playButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self->playButton.frame.size.width],
           //### self.playbackControlsView
           [NSLayoutConstraint constraintWithItem:self->playbackControlsView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:self->playbackControlsView.frame.origin.x],
           playbackControlsViewWidthConstraint,
           [NSLayoutConstraint constraintWithItem:self->playbackControlsView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self->playbackControlsView.frame.size.height]

                               ];
        [self addConstraints:constraints];
        
        self->shareHeartView = [[UIView alloc] initWithFrame:CGRectMake(116.0, 0.0, 130.0, 44.0)];
        //self.shareHeartView.backgroundColor = [UIColor blueColor];
        [self->shareHeartView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self->shareHeartView];
        NSDictionary *views = @{@"heart":self->shareHeartView, @"play":self->playbackControlsView};
        
        self->heartShareViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self->shareHeartView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self->shareHeartView.frame.size.width];
        
        [self addConstraint:self->heartShareViewWidthConstraint];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[heart]|"
                                                                     options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[heart]|"
                                                                     options:0 metrics:nil views:views]];

        [self setupPlaybackControls];
        [self setupShareHeartButtons];
    }
    return self;
}

- (void)awakeFromNib {
}

- (void)setDelegate:(NSObject<IAPPlaybackSliderDelegate> *)delegate {
    _delegate = delegate;
    [self setStarterTime];
    [self setRemainingTime];
    [self setHearted];
}

- (void)setStarterTime {
    NSUInteger hours = 0, minutes = 0, seconds = 0;
    
    if (self.delegate) {
        NSTimeInterval time = self.delegate.starterTime;
        
        hours = time / 60 / 60;
        minutes = time / 60 - hours * 60;
        seconds = time - (hours * 3600) - (minutes * 60);
        
    }

    [startTime setText:[NSString stringWithFormat:@"%d:%02d:%02d", hours, minutes, seconds]];
}

- (void)setRemainingTime {
    NSUInteger hours = 1, minutes = 0, seconds = 0;
    
    if (self.delegate) {
        NSTimeInterval time = self.delegate.remainingTime;
        
        hours = time / 60 / 60;
        minutes = time / 60 - hours * 60;
        seconds = time - (hours * 3600) - (minutes * 60);
        
    }
    
    [endTime setText:[NSString stringWithFormat:@"%d:%02d:%02d", hours, minutes, seconds]];
}

- (void)setHearted {
    BOOL hearted = NO;
    if (self.delegate) hearted = [self.delegate hearted];
    
    [heartButton setSelected:hearted];
}

- (IBAction)rolloutView:(id)sender {
//    CGRect frame = self.frame;
//    frame.size.width = self.superview.frame.size.width - 10;
    
    self->playbackSlider.alpha = 0.0;
        
    CGRect oldFrame = self->startTime.frame;
    
    self->playbackSlider.maximumValue = 100.0;
    self->playbackSlider.minimumValue = 0.0;
    self->playbackSlider.value = 10.0;
    
    UIButton *trigger = (UIButton *)sender;
    trigger.enabled = NO;
        
    void (^completion)(BOOL) = nil;
    
    CGFloat heartShareSmallWidth = 0;
    CGFloat heartShareSavedWidth = self->heartShareViewWidthConstraint.constant;
    
    CGFloat playbackNewWidth = self.frame.size.width - self->playButton.frame.size.width-2.0;
    CGFloat playbackSavedWidth = self->playbackControlsViewWidthConstraint.constant;
    
    CGFloat heartButtonSmallWidth = 0;
    CGFloat heartButtonSavedWidth = self->heartButtonWidthConstraint.constant;
    
    CGFloat shareButtonSmallWidth = 0;
    CGFloat shareButtonSavedWidth = self->shareButtonWidthConstraint.constant;
    
    void (^animations)() = ^{
        self->heartShareViewWidthConstraint.constant = heartShareSmallWidth;
        self->playbackControlsViewWidthConstraint.constant = playbackNewWidth;
        self->heartButtonWidthConstraint.constant = heartButtonSmallWidth;
        self->shareButtonWidthConstraint.constant = shareButtonSmallWidth;
        self->playbackSlider.alpha = 1.0;
        self->playbackSlider.hidden = NO;
        self->startTime.frame = self->endTime.frame;
        self->playbackSlider.value = 50.0;
        [self updateConstraintsIfNeeded];
    };
    
    void (^rollBackAnimation)() = ^{
        self->playbackSlider.alpha = 0.0;
        self->startTime.frame = oldFrame;
        self->endTime.hidden = NO;
        self->playbackControlsViewWidthConstraint.constant = playbackSavedWidth;
        self->heartShareViewWidthConstraint.constant = heartShareSavedWidth;
        self->heartButtonWidthConstraint.constant = heartButtonSavedWidth;
        self->shareButtonWidthConstraint.constant = shareButtonSavedWidth;
        [self updateConstraintsIfNeeded];
    };
    
    void (^rollBackCompletion)(BOOL) = ^(BOOL finished) {
        trigger.enabled = YES;
    };
    
//    frame = self.playbackControlsView.frame;
    //[self removeConstraints:self.playbackControlsView.constraints];
    BOOL rollOutAndBack = YES;
    if (!rollOutAndBack) {
/*        [self.playbackControlsView rollOutViewToFrame:frame
               rollOutAnimations:animations
               rollOutCompletion:completion];*/
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            if(animations) animations();
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            ;        }];
/*        [self.playbackControlsView rollOutViewToFrame:frame
                                    rollOutAnimations:animations
                                    rollOutCompletion:completion];*/
    }
    else {
        
//        __block CGRect saveFrame = self.frame;
        [self setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             animations();
                             [self layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 [UIView animateWithDuration:0.5 delay:2.0 options:UIViewAnimationOptionAllowUserInteraction
                                                  animations:^{
                                                      rollBackAnimation();
                                                      [self layoutIfNeeded];
                                                  } completion:rollBackCompletion];
                             }
                         }];

/*        [self.playbackControlsView rollOutViewToFrame:frame timeOutRollBack:2.0
            rollOutAnimations:animations
            rollOutCompletion:nil
            rollBackAnimations:rollBackAnimation
            rollBackCompletion:rollBackCompletion];*/
    }
}



- (IBAction)toggleHeart:(id)sender {
    if (self.delegate) {
        NSLog(@"toggle");
        BOOL heart = !self.delegate.hearted;
        [heartButton setSelected:heart];
        [self.delegate setHearted:heart];
    }
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)sharePodcast:(id)sender {

    if (!activityViewImageView) {
        CGRect viewFrame = self.superview.frame;
        viewFrame.origin = CGPointMake(0, 0);
        activityViewImageView = [[UIImageView alloc] initWithFrame:viewFrame];
        [activityViewImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    if (!activityViewController) {
        
        NSArray *shareActivities = @[@"blah blah blah"];
        NSArray *serviceActivities = @[];
        activityViewController = [[UIActivityViewController alloc] initWithActivityItems:shareActivities applicationActivities:nil];
//        [activityViewController.view addSubview:activityViewImageView];
//        [activityViewController.view sendSubviewToBack:activityViewImageView];
        activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        activityViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
//        activityViewController.view.backgroundColor = [UIColor grayColor];
//        activityViewController.view.alpha = 0.5;
    }
    
//    activityViewImageView.image = [UIImage imageWithView:self.superview];

    UIViewController *rvc = [self firstAvailableUIViewController];
    [rvc presentViewController:activityViewController animated:YES completion:^{
/*        [activityViewController.view addSubview:activityViewImageView];
        [activityViewController.view sendSubviewToBack:activityViewImageView];
        activityViewImageView.image = [UIImage imageWithView:self.superview];*/

    }];
//    [activityViewController.view addSubview:self.superview];
//    [activityViewController.view sendSubviewToBack:self.superview];

}

#pragma mark - Private Class Methods
- (void)setupPlaybackControls {
    self->startTime = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 50,21)];
    [self->startTime setFont:[UIFont boldSystemFontOfSize:12.0]];
    [self->startTime setTextColor:[UIColor darkGrayColor]];
    [self->startTime setBackgroundColor:[UIColor clearColor]];
    [self->startTime setText:@"0:00:00"];
    [self->startTime setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self->playbackControlsView addSubview:self->startTime];
    
    self->endTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, 50, 21)];
    [self->endTime setFont:[UIFont boldSystemFontOfSize:12.0]];
    [self->endTime setTextColor:[UIColor darkGrayColor]];
    [self->endTime setBackgroundColor:[UIColor clearColor]];
    [self->endTime setText:@"0:45:00"];
    [self->endTime setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self->playbackControlsView addSubview:self->endTime];
    
    //    layoutConstraint.priority = NSLayoutPriorityRequired;
    
    self->playbackSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 4, 44, 23)];
    self->playbackSlider.hidden = YES;
    [self->playbackSlider setTranslatesAutoresizingMaskIntoConstraints:NO];
    UIEdgeInsets edgeInsets;
    edgeInsets.left = 5.0;
    edgeInsets.right = 5.0;
    UIImage *leftCap = [[UIImage imageNamed:@"MaxSlider.png"] resizableImageWithCapInsets:edgeInsets];
    UIImage *rightCap = [[UIImage imageNamed:@"MinSlider.png"] resizableImageWithCapInsets:edgeInsets];
    [self->playbackSlider setMaximumTrackImage:leftCap forState:UIControlStateNormal];
    [self->playbackSlider setMinimumTrackImage:rightCap forState:UIControlStateNormal];
    [self->playbackSlider setThumbImage:[UIImage imageNamed:@"Thumb.png"] forState:UIControlStateNormal];
    [self->playbackControlsView addSubview:self->playbackSlider];
    
    NSArray *constraints = @[
                             //self.startTime constraints
                             [NSLayoutConstraint constraintWithItem:self->startTime attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self->playbackControlsView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0],
                             [NSLayoutConstraint constraintWithItem:self->startTime attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self->startTime.frame.size.width],
                             //self->endTime constraints
                             [NSLayoutConstraint constraintWithItem:self->endTime attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self->playbackControlsView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0],
                             [NSLayoutConstraint constraintWithItem:self->endTime attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self->endTime.frame.size.width],
                             //self->playbackSlider constraints
                             [NSLayoutConstraint constraintWithItem:self->playbackSlider attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self->playbackControlsView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:2.0],
                             [NSLayoutConstraint constraintWithItem:self->playbackSlider attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self->playbackControlsView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-2.0]
                             ];
    
    [self->playbackControlsView addConstraints:constraints];
    [self->playbackControlsView updateConstraintsIfNeeded];
}

- (void)setupShareHeartButtons {
    self->shareButton = [UIButton buttonWithType:UIButtonTypeCustom];//[[UIButton alloc] initWithFrame:
    //self.shareButton.frame = CGRectMake(136, 0, 70, 44.0);
    self->shareButton.frame = CGRectMake(10, 0, 70, 44.0);
    [self->shareButton setTitle:@"Share" forState:UIControlStateNormal];
    [self->shareButton setTitleColor:[UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0]
 forState:UIControlStateNormal];
    self->shareButton.titleLabel.font = [UIFont boldSystemFontOfSize:24.0];
    [self->shareButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self->shareButton addTarget:self action:@selector(sharePodcast:) forControlEvents:UIControlEventTouchDown];

    [self->shareHeartView addSubview:self->shareButton];
    
    self->shareButtonWidthConstraint = [NSLayoutConstraint constraintWithItem:self->shareButton attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self->shareButton.frame.size.width];
    NSArray *constraints = @[
        [NSLayoutConstraint constraintWithItem:self->shareButton attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self->shareHeartView attribute:NSLayoutAttributeLeading multiplier:1.0
                                      constant:self->shareButton.frame.origin.x],
        self->shareButtonWidthConstraint
                                ];
    [self->shareHeartView addConstraints:constraints];
    
    self->heartButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.heartButton.frame = CGRectMake(220, 0, 40, 44);
    self->heartButton.frame = CGRectMake(84, 0, 40, 44);
    [self->heartButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self->heartButton setImage:[UIImage imageNamed:@"GreyHeartPodcast.png"] forState:UIControlStateNormal];
    [self->heartButton setImage:[UIImage imageNamed:@"RedHeartPodcast.png"] forState:UIControlStateSelected];
    [self->heartButton setImage:[UIImage imageNamed:@"RedHeartPodcast.png"] forState:UIControlStateHighlighted];
    
    //[self->heartButton addTarget:self action:@selector(toggleHeart:)
    [self->heartButton addTarget:self action:@selector(toggleHeart:) forControlEvents:UIControlEventTouchDown];

    [self->shareHeartView addSubview:self->heartButton];
    self->heartButtonWidthConstraint =
        [NSLayoutConstraint constraintWithItem:self->heartButton attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1.0 constant:self->heartButton.frame.size.width];
    [self addConstraint:self->heartButtonWidthConstraint];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self->heartButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-4.0]];

}


@end
