//
//  POITableViewCell.h
//  BlocSpot
//
//  Created by Sameer Totey on 12/22/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "SearchResultObjectAnnotation.h"

@interface POITableViewCell : UITableViewCell

@property(nonatomic, strong)SearchResultObjectAnnotation *object;

@end
