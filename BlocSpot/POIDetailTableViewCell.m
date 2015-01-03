//
//  POIDetailTableViewCell.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/29/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "POIDetailTableViewCell.h"


@implementation POIDetailTableViewCell

- (void)awakeFromNib {
    // Background gradient
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(id)[UIColor whiteColor].CGColor,
                             (id)[UIColor colorWithRed:0.561 green:0.839 blue:0.922 alpha:1].CGColor];
    gradientLayer.cornerRadius = 4;
    gradientLayer.masksToBounds = YES;
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)setObject:(BlocSpotModel *)object {
    [super setObject:object];
    self.poiBlocSpotView.object = object;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserLocation:) name:kUpdatedBlocSpotModel object:self.object];
    [self setNeedsDisplay];
}

- (void)updateUserLocation:(NSNotification *)notification {
    self.poiDistanceLabel.text = [NSString stringWithFormat:@"%.1f mi", self.object.currentDistanceFromUser * 0.000621371];
    [self.poiDistanceLabel setNeedsDisplay];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
