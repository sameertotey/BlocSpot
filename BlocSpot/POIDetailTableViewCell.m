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
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
    self.longPressGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.longPressGestureRecognizer];
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
