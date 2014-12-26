//
//  UIColor+String.h
//  BlocSpot
//
//  Created by Sameer Totey on 12/24/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (String)

-(NSString *)toString;

+(UIColor *)fromString: (NSString *)string;

@end
