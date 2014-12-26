//
//  LocationCategoryTableViewCell.h
//  BlocSpot
//
//  Created by Sameer Totey on 12/24/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationCategory.h"

@class LocationCategoryTableViewCell;

@protocol LocationCategoryTableViewCellDelegate <NSObject>

- (void) cell:(LocationCategoryTableViewCell *)cell didSelectLocation:(LocationCategory *)locationCategory;

@end

@interface LocationCategoryTableViewCell : UITableViewCell
@property(nonatomic, strong)LocationCategory *object;
@property(nonatomic, weak) id<LocationCategoryTableViewCellDelegate>delegate;
@property(nonatomic)BOOL chosen;
@end
