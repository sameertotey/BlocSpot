//
//  POIDetailTableViewCell.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/29/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "POIDetailTableViewCell.h"

@implementation POIDetailTableViewCell

- (void)setObject:(BlocSpotModel *)object {
    [super setObject:object];
    self.poiBlocSpotView.object = object;
    [self setNeedsDisplay];
}

@end
