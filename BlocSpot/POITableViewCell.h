//
//  POITableViewCell.h
//  BlocSpot
//
//  Created by Sameer Totey on 12/22/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "BlocSpotModel.h"

@class POITableViewCell;

@protocol POITableViewCellDelegate <NSObject>

- (void)didRequestZoomTo:(BlocSpotModel *)object;

@end

@interface POITableViewCell : UITableViewCell

@property(nonatomic, strong)BlocSpotModel *object;
@property(nonatomic, strong)UILongPressGestureRecognizer *longPressGestureRecognizer;
@property(nonatomic, weak)id<POITableViewCellDelegate> delegate;

- (void)longPressFired:(UIGestureRecognizer *)gesture;

@end
