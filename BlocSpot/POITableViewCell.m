//
//  POITableViewCell.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/22/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "POITableViewCell.h"

@interface POITableViewCell ()

@end

@implementation POITableViewCell

- (void)awakeFromNib {
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
    self.longPressGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.longPressGestureRecognizer];

}

- (void)longPressFired:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan){
        //Do Whatever You want on Began of Gesture
        [self.delegate didRequestZoomTo:self.object];
    }
}

@end
