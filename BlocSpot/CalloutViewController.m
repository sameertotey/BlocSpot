//
//  CalloutViewController.m
//  BlocSpot
//
//  Created by Sameer Totey on 12/19/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "CalloutViewController.h"

@implementation CalloutViewController


- (IBAction)visitedButtonTouched:(id)sender {
    NSLog(@"Visited button touched");
}

- (CGSize)preferredContentSize {
    return CGSizeMake(280, 150);
}
@end
