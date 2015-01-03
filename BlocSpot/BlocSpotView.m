//
//  BlocSpotView.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/30/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "BlocSpotView.h"
#import "LocationCategory+Create.h"

@implementation BlocSpotView

- (void)setObject:(BlocSpotModel *)object {
    _object = object;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    
    [[UIColor lightGrayColor] setFill];
    
    
    if ([self.object isKindOfClass:[BlocSpotModel class]]) {
        LocationCategory *lc = self.object.pointOfInterest.locationCategory;
        NSString *color = lc ? lc.color : @".4,.4,.4,.4";
        [[UIColor fromString:color] setFill];
    }
    
    CGFloat w = self.frame.size.width / 3.1f;
    CGPoint center = CGPointMake(self.frame.size.width / 2.f, self.frame.size.height / 2.f);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path addArcWithCenter:CGPointMake(center.x - w/2.f, center.y - sqrt(3.f) * w / 6.f) radius:w / sqrt(3.f) startAngle:[self toRadians:150.f] endAngle:[self toRadians:-30.f] clockwise:YES];
    [path addArcWithCenter:CGPointMake(center.x + w/2.f, center.y - sqrt(3.f) * w / 6.f) radius:w / sqrt(3.f) startAngle:[self toRadians:-150.f] endAngle:[self toRadians:30.f] clockwise:YES];
    
    [path moveToPoint:CGPointMake(center.x - w, center.y)];
    [path addLineToPoint:CGPointMake(center.x, center.y + w * sqrt(3.f))];
    [path addLineToPoint:CGPointMake(center.x + w, center.y)];
    
    [path fill];
    
    if (self.object.pointOfInterest.visited) {
        [path moveToPoint:CGPointMake(15., 25.)];
        [path addLineToPoint:CGPointMake(18., 30.)];
        [path addLineToPoint:CGPointMake(30.,5.)];
        path.lineWidth = 3.0;
        [[UIColor whiteColor] setStroke];
        [path stroke];
    }
}

- (CGFloat)toRadians:(CGFloat)angle
{
    return angle / 180.f * M_PI;
}

@end
