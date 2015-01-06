//
//  ModalTransitionAnimator.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/3/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.

#import "ModalTransitionAnimator.h"
#import "CategoryListTableViewController.h"

static CGFloat const kInitialScale = 0.01;
static CGFloat const kFinalScale = 0.8;

@implementation ModalTransitionAnimator

#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    // Presenting
    if (self.appearing) {
        fromView.userInteractionEnabled = NO;
        
        // Round the corners
        toView.layer.cornerRadius = 5;
        toView.layer.masksToBounds = YES;
        
        // Set initial scale to zero
        toView.transform = CGAffineTransformMakeScale(kInitialScale, kInitialScale);
        [containerView addSubview:toView];
        
        // Scale up to 80%
        [UIView animateWithDuration:duration animations: ^{
            toView.transform = CGAffineTransformMakeScale(kFinalScale, kFinalScale);
            fromView.alpha = 0.5;
        } completion: ^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    // Dismissing
    else {
        
        // Scale down to 0
        [UIView animateWithDuration:duration animations: ^{
            fromView.transform = CGAffineTransformMakeScale(kInitialScale, kInitialScale);
            toView.alpha = 1.0;
        } completion: ^(BOOL finished) {
            [fromView removeFromSuperview];
            toView.userInteractionEnabled = YES;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

@end

@implementation ModalTransitioningDelegate

#pragma mark - UIViewControllerTransitioningDelegate

/*
 Called when presenting a view controller that has a transitioningDelegate
 */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    id<UIViewControllerAnimatedTransitioning> animationController;
    
    // List Category
    if ([presented isKindOfClass:[UINavigationController class]] &&
        [((UINavigationController *)presented).topViewController isKindOfClass:[CategoryListTableViewController class]]) {
        ModalTransitionAnimator *animator = [[ModalTransitionAnimator alloc] init];
        animator.appearing = YES;
        animator.duration = .65;
        animationController = animator;
    }
    return animationController;
}

/*
 Called when dismissing a view controller that has a transitioningDelegate
 */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    id<UIViewControllerAnimatedTransitioning> animationController;
    
    // List Category
    if ([dismissed isKindOfClass:[UINavigationController class]] &&
        [((UINavigationController *)dismissed).topViewController isKindOfClass:[CategoryListTableViewController class]]) {
        
        ModalTransitionAnimator  *animator = [[ModalTransitionAnimator alloc] init];
        animator.appearing = NO;
        animator.duration = 0.35;
        animationController = animator;
    }
    
    return animationController;
}


@end
