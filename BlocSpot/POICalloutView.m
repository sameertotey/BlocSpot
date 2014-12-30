//
//  POICalloutView.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/19/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "POICalloutView.h"

@interface POICalloutView ()
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *subtitleLabel;
@property(nonatomic,strong) UILabel *informationLabel;
@property(nonatomic, strong) UIButton *visitedButton;
@property(nonatomic, strong) UIView *dividerView;
@end

@implementation POICalloutView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label;
        });
        [self addSubview:self.titleLabel];
        
        self.visitedButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"heart-empty"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(visited) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor redColor];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            button;
        });
        [self addSubview:self.visitedButton];
        
        self.dividerView = ({
            UIView *divider = [[UIView alloc] init];
            divider.translatesAutoresizingMaskIntoConstraints = NO;
            divider.backgroundColor = [UIColor blackColor];
            divider;
        });
        [self addSubview:self.dividerView];
        
        self.subtitleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label;
        });
        [self addSubview:self.subtitleLabel];
        
        self.informationLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
            label.textColor = [UIColor darkGrayColor];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label;
        });
        [self addSubview:self.informationLabel];
        
        NSDictionary *viewMetrics = @{@"bigLabelHeight": @(21.0),
                                      @"smallLabelHeight": @(15.0),
                                      @"labelWidth": @(216.0),
                                      @"horizontalPadding": @(13.0),
                                      @"verticalPadding": @(3.0),
                                      @"verticalSpacing": @(0.0)};
//        id titleLabel = self.titleLabel;
//        id subtitleLabel = self.subtitleLabel;
//        id informationLabel = self.informationLabel;
//        id visitedButton = self.visitedButton;
        NSDictionary *views = NSDictionaryOfVariableBindings(_titleLabel, _subtitleLabel, _informationLabel, _visitedButton, _dividerView);
        
        NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalPadding-[_titleLabel(bigLabelHeight)]-verticalSpacing-[_dividerView(verticalPadding)]-verticalSpacing-[_subtitleLabel(smallLabelHeight)]-verticalSpacing-[_informationLabel(smallLabelHeight)]-verticalSpacing-[_visitedButton(smallLabelHeight)]-verticalPadding-|"
                                                                               options:0
                                                                               metrics:viewMetrics
                                                                                 views:views];
        [self addConstraints:verticalConstraints];
        
        NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-horizontalPadding-[_titleLabel(labelWidth)]-horizontalPadding-|"
                                                                                 options:0
                                                                                 metrics:viewMetrics
                                                                                   views:views];
        horizontalConstraints = [horizontalConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-horizontalPadding-[_subtitleLabel(labelWidth)]-horizontalPadding-|"
                                                                                                                             options:0
                                                                                                                             metrics:viewMetrics
                                                                                                                               views:views]];
        horizontalConstraints = [horizontalConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-horizontalPadding-[_informationLabel(labelWidth)]-horizontalPadding-|"
                                                                                                                             options:0
                                                                                                                             metrics:viewMetrics
                                                                                                                               views:views]];
        horizontalConstraints = [horizontalConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-horizontalPadding-[_visitedButton(labelWidth)]-horizontalPadding-|"
                                                                                                                             options:0
                                                                                                                             metrics:viewMetrics
                                                                                                                               views:views]];
        horizontalConstraints = [horizontalConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_dividerView(labelWidth)]-|"
                                                                                                                             options:0
                                                                                                                             metrics:viewMetrics
                                                                                                                               views:views]];
        
        [self addConstraints:horizontalConstraints];
        
        self.layer.anchorPoint = CGPointMake(0.5, 1.0);
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.layer.borderColor = [UIColor colorWithRed:0.890 green:0.875 blue:0.843 alpha:1.000].CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 8.0;
        self.layer.masksToBounds = YES;
    }
    return self;
}

#pragma mark - properties

- (void)setAnnotation:(BlocSpotModel *)annotation {
    _annotation = annotation;
    if (_annotation) {
        self.titleLabel.text = _annotation.title;
        
    }
}

#pragma mark - button target

- (void)visited {
    NSLog(@"Visited clicked");
}

@end
