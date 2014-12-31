//
//  POIDetailTableViewCell.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/29/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "POIDetailTableViewCell.h"
#import "UserLocation.h"

@interface POIDetailTableViewCell ()
@property (nonatomic, strong)CLLocation *poiLocation;
@property (nonatomic, strong)UserLocation *userLocation;
@end

@implementation POIDetailTableViewCell

- (void)awakeFromNib {
    self.userLocation = [UserLocation sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserLocation:) name:kUserLocationUpdated object:nil];
}

- (void)setObject:(BlocSpotModel *)object {
    [super setObject:object];
    self.poiBlocSpotView.object = object;
    self.poiLocation = [[CLLocation alloc] initWithLatitude:object.coordinate.latitude longitude:object.coordinate.longitude];
    [self setNeedsDisplay];
}

- (void)updateUserLocation:(NSNotification *)notification {
    CLLocationDistance distance = [self.poiLocation distanceFromLocation:self.userLocation.location];
    NSString *distanceText = [NSString stringWithFormat:@"%.1f mi", distance * 0.000621371];
    self.poiDistanceLabel.text = distanceText;
    [self setNeedsDisplay];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
