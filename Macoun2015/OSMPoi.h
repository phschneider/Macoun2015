//
//  OSMPoi.h
//  Macoun2015
//
//  Created by Philip Schneider on 23.10.15.
//  Copyright © 2015 Philip Schneider. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Ono/ONOXMLDocument.h>

@interface OSMPoi : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;

@property (nonatomic) ONOXMLElement *onoxmlElement;

- (instancetype)initWithXmlData:(ONOXMLElement *)onoxmlElement;

@end
