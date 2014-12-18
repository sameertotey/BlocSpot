//
//  BaseTransitionAnimator.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/3/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//


#import "BaseTransitionAnimator.h"

static NSTimeInterval const kDefaultDuration = 1.0;

@implementation BaseTransitionAnimator

- (id)init
{
    self = [super init];
    if (self) {
        _duration = kDefaultDuration;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // Must be implemented by inheriting class
    [self doesNotRecognizeSelector:_cmd];
}

@end
