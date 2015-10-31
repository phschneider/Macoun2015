//
//  AppleShadingMapsAboveRoadsDetailViewController.m
//  Macoun2015
//
//  Created by Philip Schneider on 23.10.15.
//  Copyright (c) 2015 Philip Schneider. All rights reserved.
//

#import "AppleShadingMapsAboveRoadsDetailViewController.h"


@implementation AppleShadingMapsAboveRoadsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    MKTileOverlay *overlay = [[MKTileOverlay alloc] initWithURLTemplate:@"http://tiles.openpistemap.org/landshaded/{z}/{x}/{y}.png"];
    [self.mapView addOverlay:overlay level:MKOverlayLevelAboveRoads];
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKTileOverlay class]]) {
        return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
    }
    return nil;
}

@end