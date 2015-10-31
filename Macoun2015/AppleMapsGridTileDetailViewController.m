//
//  AppleMapsGridTileDetailViewController.m
//  Macoun2015
//
//  Created by Philip Schneider on 23.10.15.
//  Copyright © 2015 Philip Schneider. All rights reserved.
//

#import "AppleMapsGridTileDetailViewController.h"
#import "GridTileOverlay.h"


@implementation AppleMapsGridTileDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    GridTileOverlay *overlay = [[GridTileOverlay alloc] init];
    [self.mapView addOverlay:overlay level:MKOverlayLevelAboveLabels];
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKTileOverlay class]]) {
        return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
    }
    return nil;
}

@end
