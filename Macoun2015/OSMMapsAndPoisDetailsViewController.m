//
//  OSMMapsAndPoisDetailsViewController.m
//  Macoun2015
//
//  Created by Philip Schneider on 23.10.15.
//  Copyright © 2015 Philip Schneider. All rights reserved.
//

#import "OSMMapsAndPoisDetailsViewController.h"
#import <AFNetworking/AFHTTPRequestOperation.h>
#import <Ono/ONOXMLDocument.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "OSMPoi.h"


@implementation OSMMapsAndPoisDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(50.104665, 8.683817),MKCoordinateSpanMake(0.072227, 0.064201))];

    MKTileOverlay *overlay = [[MKTileOverlay alloc] initWithURLTemplate:@"http://tile.openstreetmap.org/{z}/{x}/{y}.png"];
    [self.mapView addOverlay:overlay level:MKOverlayLevelAboveLabels];
    
    UIBarButtonItem *syncBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Load Pois" style:UIBarButtonItemStylePlain target:self action:@selector(loadPois)];
    self.navigationItem.rightBarButtonItem = syncBarButtonItem;    
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKTileOverlay class]]) {
        return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
    }
    return nil;
}


- (void) loadPois
{    
    NSArray * boundingBox = [self getBoundingBox:self.mapView.visibleMapRect];
    NSString *boundingBoxString = [NSString stringWithFormat:@"%.3f,%.3f,%.3f,%.3f", [[boundingBox objectAtIndex:1] floatValue], [[boundingBox objectAtIndex:0] floatValue], [[boundingBox objectAtIndex:3] floatValue], [[boundingBox objectAtIndex:2] floatValue]];
    
    NSString *string = [NSString stringWithFormat:@"http://overpass.osm.rambler.ru/cgi/xapi_meta?node[tourism=viewpoint][bbox=%@]", boundingBoxString];
    NSLog(@"String = %@", string);
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    __block NSMutableArray *poiArray = [[NSMutableArray alloc] init];
    
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
        
        NSString *xPathString = @"//node";
        [document enumerateElementsWithXPath:xPathString usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
            OSMPoi *poi= [[OSMPoi alloc] initWithXmlData:element];
            [poiArray addObject:poi];
        }];
        
        dispatch_async(dispatch_get_main_queue(),^{
            NSLog(@"Add %lu annotations", (unsigned long)[poiArray count]);
            [self.mapView addAnnotations:poiArray];
        });
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSLog(@"Failure");
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error retrieving POIs"
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


- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView *pav = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pav.canShowCallout = YES;
    return pav;
}


#pragma mark - Helper
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
