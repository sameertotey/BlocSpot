//
//  LocationCategoryTableViewCell.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/24/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "LocationCategoryTableViewCell.h"

@interface LocationCategoryTableViewCell ()
@property(nonatomic, strong)UILongPressGestureRecognizer *longPressGestureRecognizer;
@property(nonatomic, strong)UIButton *accessoryButton;
@end

@implementation LocationCategoryTableViewCell

- (void)awakeFromNib {
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
    self.longPressGestureRecognizer.delegate = self;
    [self.contentView addGestureRecognizer:self.longPressGestureRecognizer];

    self.accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    CGFloat height = CGRectGetHeight(self.contentView.bounds);
    CGFloat height = 43.5;
    self.accessoryButton.frame = CGRectMake(0, 0, height, height);
    [self.accessoryButton addTarget:self action:@selector(selectionToggled) forControlEvents:UIControlEventTouchUpInside];
}


- (void)longPressFired:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan){
        [self.delegate cell:self didSelectLocation:self.object];
    }
}

- (void)selectionToggled {
    [self.delegate cell:self didSelectLocation:self.object];
}

- (void)setObject:(LocationCategory *)object {
    _object = object;
    if (_object) {
        self.textLabel.text = object.name;
        self.contentView.backgroundColor = [UIColor fromString:object.color];
        self.accessoryView.backgroundColor = [UIColor fromString:object.color];
        self.accessoryButton.backgroundColor = [UIColor fromString:object.color];
    }
    [self setNeedsDisplay];
}

- (void)setChosen:(BOOL)chosen {
    _chosen = chosen;
    if (_chosen) {
        [self.accessoryButton setImage:[UIImage imageNamed:@"chosen"] forState:UIControlStateNormal];
    } else {
        [self.accessoryButton setImage:[UIImage imageNamed:@"not-chosen"] forState:UIControlStateNormal];
    }
    self.accessoryView = self.accessoryButton;
    [self setNeedsDisplay];
}

@end
