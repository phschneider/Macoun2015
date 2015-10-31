//
//  OSMMapsSaveTIlesDetailViewController.m
//  Macoun2015
//
//  Created by Philip Schneider on 23.10.15.
//  Copyright © 2015 Philip Schneider. All rights reserved.
//

#import "OSMMapsSaveTIlesDetailViewController.h"
#import "OSMSaveTileOverlay.h"


@implementation OSMMapsSaveTIlesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    OSMSaveTileOverlay *overlay = [[OSMSaveTileOverlay alloc] initWithURLTemplate:@"http://www.openptmap.org/tiles/{z}/{x}/{y}.png"];
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
