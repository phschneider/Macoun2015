//
//  OSMTrack.h
//  Macoun2015
//
//  Created by Philip Schneider on 23.10.15.
//  Copyright © 2015 Philip Schneider. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Ono/ONOXMLDocument.h>

@interface OSMTrack : MKPolyline <MKOverlay>

@property (nonatomic) CLLocationCoordinate2D *coordinates;

- (instancetype)initWithXmlData:(ONOXMLElement*)onoxmlElement document:(ONOXMLDocument*)document;
- (MKPolyline *)route;

@end
