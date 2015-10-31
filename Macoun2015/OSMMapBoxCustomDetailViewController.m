//
//  OSMMapBoxCustomDetailViewController.m
//  Macoun2015
//
//  Created by Philip Schneider on 23.10.15.
//  Copyright (c) 2015 Philip Schneider. All rights reserved.
//

#import "OSMMapBoxCustomDetailViewController.h"
#import "OSMMapBoxCustomTileOverlay.h"


@implementation OSMMapBoxCustomDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    OSMMapBoxCustomTileOverlay *overlay = [[OSMMapBoxCustomTileOverlay alloc] init];
    overlay.canReplaceMapContent = YES;
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