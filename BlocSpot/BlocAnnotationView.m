//
//  BlocAnnotationView.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/18/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "BlocAnnotationView.h"
#import "BlocSpotModel.h"
#import "LocationCategory+Create.h"

static NSString * const kDefaultImage   = @"pin.jpg";

@interface BlocAnnotationView ()
@property(nonatomic, strong) CalloutViewController *calloutViewController;
@end

@implementation BlocAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.image = [UIImage imageNamed:kDefaultImage];
        self.frame = CGRectMake(0, 0, 40, 40);
        self.backgroundColor = [UIColor clearColor];
        
        self.calloutViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"callout"];
        
        CGRect calloutFrame = self.calloutViewController.view.frame;
        calloutFrame.size = [self.calloutViewController preferredContentSize];
        self.calloutViewController.view.frame = calloutFrame;
        self.calloutViewController.annotation = self.annotation;
        
//        self.centerOffset = CGPointMake(40.0, 40.0);
        // The opaque property is YES by default. Setting it to
        // NO allows map content to show through any unrendered parts of your view.
        self.opaque = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // used to draw the rounded background box and pointer
//
//    [[UIColor darkGrayColor] setFill];
//        
//    // draw the pointed shape
//    UIBezierPath *pointShape = [UIBezierPath bezierPath];
//    [pointShape moveToPoint:CGPointMake(14.0, 0.0)];
//    [pointShape addLineToPoint:CGPointMake(0.0, 0.0)];
//    [pointShape addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
//    [pointShape fill];
//        
//        // draw the rounded box
//    [[UIColor greenColor] setFill];
//
//        UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:
//                                     CGRectMake(10.0,
//                                                0.0,
//                                                self.frame.size.width - 10.0,
//                                                self.frame.size.height)
//                                                               cornerRadius:3.0];
//        roundedRect.lineWidth = 2.0;
//        [roundedRect fill];
    
    [[UIColor lightGrayColor] setFill];

    BlocSpotModel *object;

    if ([self.annotation isKindOfClass:[BlocSpotModel class]]) {
        object = self.annotation;
        LocationCategory *lc = object.pointOfInterest.locationCategory;
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
    
    if (object.pointOfInterest.visited) {
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

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == nil && self.selected) {
        UIView *calloutView = self.calloutViewController.view;
        CGPoint pointInCalloutView = [self convertPoint:point toView:calloutView];
        hitView = [calloutView hitTest:pointInCalloutView withEvent:event];
    }
    return hitView;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    // Get the custom callout view.
    UIView *calloutView = self.calloutViewController.view;
    if (selected) {
        CGRect annotationViewBounds = self.bounds;
        CGRect calloutViewFrame = calloutView.frame;
        // Center the callout view above and to the right of the annotation view.
        calloutViewFrame.origin.x = -(CGRectGetWidth(calloutViewFrame) - CGRectGetWidth(annotationViewBounds)) * 0.5;
        calloutViewFrame.origin.y = -CGRectGetHeight(calloutViewFrame) + 15.0;
        calloutView.frame = calloutViewFrame;
        
        [self addSubview:calloutView];
    } else {
        [calloutView removeFromSuperview];
    }
}


@end
