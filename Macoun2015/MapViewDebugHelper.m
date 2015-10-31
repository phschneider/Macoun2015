//
// Created by Philip Schneider on 23.10.15.
// Copyright (c) 2015 Philip Schneider. All rights reserved.
//

#import "OSMMapsDetailViewController.h"
#import <MapKit/MapKit.h>
#import "MapViewDebugHelper.h"


@interface MapViewDebugHelper ()
@end

@implementation MapViewDebugHelper


+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}


+ (void)restoreCurrentRegion:(const MKMapView *)mapView
{
    if ([mapView.delegate conformsToProtocol:@protocol(MapViewRestore)])
    {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"LATEST_MAP_REGION"];
        if (data) {
            NSLog(@"Restore LATEST_MAP_REGION");
            MKCoordinateRegion region;
            [data getBytes:&region length:sizeof(MKCoordinateRegion)];
            [MapViewDebugHelper setRestoreComplete];
            [mapView setRegion:region animated:YES];
        }
        [MapViewDebugHelper setRestoreComplete];
    }
}


+ (void)saveCurrentRegion:(const MKMapView *)mapView
{
    if ([mapView.delegate conformsToProtocol:@protocol(MapViewRestore)])
    {
        // Save as plain data
        if (![self restoreCompleted]) {
            MKCoordinateRegion region = mapView.region;
            NSData *data = [NSData dataWithBytes:&region length:sizeof(MKCoordinateRegion)];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"LATEST_MAP_REGION"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            NSLog(@"saveCurrentRegion");
        }
    }
}


#pragma mark - Helper
+ (void)setBeginRestore
{
    [MapViewDebugHelper sharedInstance].restoreComplete = NO;
}

+ (BOOL)restoreCompleted
{
    return ([MapViewDebugHelper sharedInstance].restoreComplete == YES);
}


+ (void)setRestoreComplete
{
    [MapViewDebugHelper sharedInstance].restoreComplete = YES;
}

@end