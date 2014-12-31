//
//  POIDetailTableViewCell.h
//  BlocSpot
//
//  Created by Sameer Totey on 12/29/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "POITableViewCell.h"
#import "BlocSpotView.h"

@interface POIDetailTableViewCell : POITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *poiTitle;
@property (weak, nonatomic) IBOutlet UITextView *poiNotes;
@property (weak, nonatomic) IBOutlet BlocSpotView *poiBlocSpotView;
@property (weak, nonatomic) IBOutlet UILabel *poiDistanceLabel;
@property (nonatomic, assign) CLLocationDistance poiDistance;
@end
