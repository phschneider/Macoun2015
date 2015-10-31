//
//  OSMPoi.m
//  Macoun2015
//
//  Created by Philip Schneider on 23.10.15.
//  Copyright © 2015 Philip Schneider. All rights reserved.
//

#import "OSMPoi.h"

@implementation OSMPoi

- (instancetype)initWithXmlData:(ONOXMLElement*)onoxmlElement
{
    self = [super init];
    if (self)
    {
        self.coordinate = CLLocationCoordinate2DMake([[onoxmlElement valueForAttribute:@"lat"] floatValue],[[onoxmlElement valueForAttribute:@"lon"] floatValue]);
        
        NSMutableString *string = [[NSMutableString alloc] init];
        for (ONOXMLElement *child in [onoxmlElement children])
        {
            [string appendFormat:@"%@ = %@", [child valueForAttribute:@"k"], [child valueForAttribute:@"v"]];
        }
        
        self.title = string;
    }
    return self;
}


@end
