//
//  OSMMapsCachingTilesDetailViewController.m
//  Macoun2015
//
//  Created by Philip Schneider on 23.10.15.
//  Copyright © 2015 Philip Schneider. All rights reserved.
//

#import "OSMMapsCachingTilesDetailViewController.h"
#import "OSMCachingTileOverlay.h"


@implementation OSMMapsCachingTilesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    OSMCachingTileOverlay *overlay = [[OSMCachingTileOverlay alloc] initWithURLTemplate:@"http://a.tile.openstreetmap.fr/hot/${z}/${x}/${y}.png"];
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
