//
//  POIViewController.h
//  BlocSpot
//
//  Created by Sameer Totey on 12/3/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface POIViewController : UIViewController <UISearchBarDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) NSArray *places;

@end
