//
//  OSMMapBoxRunBikeHikeDetailViewController.m
//  Macoun2015
//
//  Created by Philip Schneider on 23.10.15.
//  Copyright © 2015 Philip Schneider. All rights reserved.
//

#import "OSMMapBoxRunBikeHikeDetailViewController.h"
#import "OSMMapBoxRunBikeHikeTileOverlay.h"


@implementation OSMMapBoxRunBikeHikeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    OSMMapBoxRunBikeHikeTileOverlay *overlay = [[OSMMapBoxRunBikeHikeTileOverlay alloc] init];
    [self.mapView addOverlay:overlay level:MKOverlayLevelAboveLabels];

    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(47.252015, 9.563419),MKCoordinateSpanMake(0.611495, 0.513611))];
}


#ifndef MAPBOX_API_KEY
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Missing MapBox API KEY"
                                                                    message:@"using backup tiles"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
#endif


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKTileOverlay class]]) {
        return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
    }
    return nil;
}


@end
