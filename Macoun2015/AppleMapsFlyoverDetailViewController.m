//
//  AppleMapsFlyoverDetailViewController.m
//  Macoun2015
//
//  Created by Philip Schneider on 23.10.15.
//  Copyright © 2015 Philip Schneider. All rights reserved.
//

#import "AppleMapsFlyoverDetailViewController.h"
#import <AFNetworking/AFHTTPRequestOperation.h>
#import <Ono/ONOXMLDocument.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "OSMTrack.h"

@implementation AppleMapsFlyoverDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapView.mapType = MKMapTypeSatelliteFlyover;
    self.mapView.userInteractionEnabled = NO;
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(46.533028, 7.829775),MKCoordinateSpanMake(0.074910, 0.115126))];

    
    UIBarButtonItem *syncBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Load Tracks" style:UIBarButtonItemStylePlain target:self action:@selector(loadTracks)];
    self.navigationItem.rightBarButtonItem = syncBarButtonItem;
}


- (void) loadTracks
{
    NSArray * boundingBox = [self getBoundingBox:self.mapView.visibleMapRect];
    NSString *boundingBoxString = [NSString stringWithFormat:@"%.3f,%.3f,%.3f,%.3f", [[boundingBox objectAtIndex:1] floatValue], [[boundingBox objectAtIndex:0] floatValue], [[boundingBox objectAtIndex:3] floatValue], [[boundingBox objectAtIndex:2] floatValue]];
    
    NSString *string = [NSString stringWithFormat:@"http://overpass.osm.rambler.ru/cgi/xapi_meta?way[highway=path][bbox=%@]", boundingBoxString];
    NSLog(@"String = %@", string);
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    __block NSMutableArray *trackArray = [[NSMutableArray alloc] init];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Completed");
        NSData *data = responseObject;
        NSError *error;
        
        ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:data error:&error];
        
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = [dirPaths objectAtIndex:0];
        NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xml",boundingBoxString]]];
        [data writeToFile:databasePath atomically:YES];
        
        NSString *xPathString = @"//way";
        [document enumerateElementsWithXPath:xPathString usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
            OSMTrack *track = [[OSMTrack alloc] initWithXmlData:element document:document];
            [trackArray addObject:[track route]];
        }];
        
        dispatch_async(dispatch_get_main_queue(),^{
            NSLog(@"Add %lu overlays", (unsigned long)[trackArray count]);
            [self.mapView addOverlays:trackArray];
            [self tiltCamera];
        });
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"Failure");
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error retrieving ways"
                                                                       message:[error localizedDescription]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    
    [operation start];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    NSLog(@"Started");
}


// Helper
- (void) tiltCamera
{
    MKMapCamera *camera = [MKMapCamera camera];
    camera.centerCoordinate = self.mapView.region.center;
    camera.heading = 37.402628;
    camera.pitch = 56.696519;
    camera.altitude = 6927.923740;
    
    [self.mapView setCamera:camera animated:YES];
    
    self.mapView.userInteractionEnabled = YES;
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKTileOverlay class]])
    {
        return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
    }
    else if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolyline *polyLine = (MKPolyline*)overlay;
        
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        renderer.strokeColor = [UIColor magentaColor];
        renderer.lineDashPattern = @[@2, @5];
        renderer.lineWidth = 2.0;
        renderer.alpha = 1;
        return renderer;
    }
    return nil;
}


#pragma mark - Helper
// http://www.softwarepassion.com/how-to-get-geographic-coordinates-of-the-visible-mkmapview-area-in-ios/
-(NSArray *)getBoundingBox:(MKMapRect)mRect
{
    CLLocationCoordinate2D bottomLeft = [self getSWCoordinate:mRect];
    CLLocationCoordinate2D topRight = [self getNECoordinate:mRect];
    return @[[NSNumber numberWithDouble:bottomLeft.latitude ],
             [NSNumber numberWithDouble:bottomLeft.longitude],
             [NSNumber numberWithDouble:topRight.latitude],
             [NSNumber numberWithDouble:topRight.longitude]];
}


// http://www.softwarepassion.com/how-to-get-geographic-coordinates-of-the-visible-mkmapview-area-in-ios/
-(CLLocationCoordinate2D)getNECoordinate:(MKMapRect)mRect
{
    return [self getCoordinateFromMapRectanglePoint:MKMapRectGetMaxX(mRect) y:mRect.origin.y];
}

// http://www.softwarepassion.com/how-to-get-geographic-coordinates-of-the-visible-mkmapview-area-in-ios/
-(CLLocationCoordinate2D)getNWCoordinate:(MKMapRect)mRect
{
    return [self getCoordinateFromMapRectanglePoint:MKMapRectGetMinX(mRect) y:mRect.origin.y];
}

// http://www.softwarepassion.com/how-to-get-geographic-coordinates-of-the-visible-mkmapview-area-in-ios/
-(CLLocationCoordinate2D)getSECoordinate:(MKMapRect)mRect
{
    return [self getCoordinateFromMapRectanglePoint:MKMapRectGetMaxX(mRect) y:MKMapRectGetMaxY(mRect)];
}

// http://www.softwarepassion.com/how-to-get-geographic-coordinates-of-the-visible-mkmapview-area-in-ios/
-(CLLocationCoordinate2D)getSWCoordinate:(MKMapRect)mRect
{
    return [self getCoordinateFromMapRectanglePoint:mRect.origin.x y:MKMapRectGetMaxY(mRect)];
}

// http://www.softwarepassion.com/how-to-get-geographic-coordinates-of-the-visible-mkmapview-area-in-ios/
-(CLLocationCoordinate2D)getCoordinateFromMapRectanglePoint:(double)x y:(double)y
{
    MKMapPoint swMapPoint = MKMapPointMake(x, y);
    return MKCoordinateForMapPoint(swMapPoint);
}

@end
