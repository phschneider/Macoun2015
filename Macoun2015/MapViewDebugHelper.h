//
// Created by Philip Schneider on 23.10.15.
// Copyright (c) 2015 Philip Schneider. All rights reserved.
//

#import <Foundation/Foundation.h>


#define NSStringFromMKCoordinate(MKCoordinateRegion)     [NSString stringWithFormat:@"{(%f, %f) (%f %f)}", MKCoordinateRegion.center.latitude, MKCoordinateRegion.center.longitude,MKCoordinateRegion.span.latitudeDelta,MKCoordinateRegion.span.longitudeDelta]
#define NSStringFromMKMapRect(MKMapRect)                 [NSString stringWithFormat:@"{(%f, %f) (%f %f)}", MKMapRect.origin.x, MKMapRect.origin.y, MKMapRect.size.width, MKMapRect.size.height]

@protocol MapViewRestore
@end

@interface MapViewDebugHelper : NSObject
@property(nonatomic) BOOL restoreComplete;

+ (void)restoreCurrentRegion:(const MKMapView *)mapView;

+ (void)saveCurrentRegion:(const MKMapView *)mapView;

+ (void)setBeginRestore;

+ (void)setRestoreComplete;
@end