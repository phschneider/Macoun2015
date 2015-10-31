//
//  OSMTrack.m
//  Macoun2015
//
//  Created by Philip Schneider on 23.10.15.
//  Copyright © 2015 Philip Schneider. All rights reserved.
//

#import "OSMTrack.h"


@interface OSMTrack ()
@property (nonatomic) int pointArrCount;
@end


@implementation OSMTrack

- (instancetype)initWithXmlData:(ONOXMLElement*)onoxmlElement document:(ONOXMLDocument*)document
{
    self = [super init];
    if (self)
    {
        __block NSMutableArray *points = [[NSMutableArray alloc] init];
        __block NSMutableDictionary*wayTags = [[NSMutableDictionary alloc] init];
        
        for (ONOXMLElement *child in [onoxmlElement childrenWithTag:@"tag"])
        {
            [wayTags setObject:[child valueForAttribute:@"v"] forKey:[child valueForAttribute:@"k"]];
        }
        
        
        // Aufbereitung...
        for (ONOXMLElement *child in [onoxmlElement childrenWithTag:@"nd"])
        {
            NSString *nodeId = [child valueForAttribute:@"ref"];
            NSString *xPathString = [NSString stringWithFormat:@"//node[@id=%@]",nodeId];
            [document enumerateElementsWithXPath:xPathString usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {

                NSNumber *lat = [element valueForAttribute:@"lat"];
                NSNumber *lon = [element valueForAttribute:@"lon"];
                NSMutableDictionary *pointDict = [[NSMutableDictionary alloc] init];
                [pointDict setObject:lat forKey:@"_lat"];
                [pointDict setObject:lon forKey:@"_lon"];
                [points addObject:pointDict];
            }];
        }
        
        NSDictionary *dictionary = @{ @"trk" :  @{ @"trkseg" : @{ @"trkpt" : points} } };
        [self parseDictionary:dictionary];
    }
    
    return self;
}


- (void)parseDictionary:(NSDictionary *)routingDict
{
    NSArray *trek = [[[routingDict objectForKey:@"trk"] objectForKey:@"trkseg"] objectForKey:@"trkpt"];
    self.coordinates = (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D) * [trek count]);
    int pointArrCount = 0;
    
    for (NSDictionary * pointDict in trek)
    {
        
        CGFloat lat = [[pointDict objectForKey:@"_lat"] doubleValue];
        CGFloat lon = [[pointDict objectForKey:@"_lon"] doubleValue];
        
        CLLocationCoordinate2D workingCoordinate = CLLocationCoordinate2DMake(lat, lon);
        self.coordinates[pointArrCount] = workingCoordinate;
        
        pointArrCount++;
    }
    
    self.pointArrCount = pointArrCount;
}


- (MKPolyline *)route
{
    NSLog(@"Route");
    //    return [MKPolyline polylineWithPoints:self.pointArr count:self.pointArrCount];
    NSAssert(self.coordinates,@"No coordinates for route");
    MKPolyline *myRoute = [MKPolyline polylineWithCoordinates:self.coordinates count:self.pointArrCount];
    
    return myRoute;
}

@end
