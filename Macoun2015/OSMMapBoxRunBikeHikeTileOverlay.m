//
//  OSMMapBoxRunBikeHikeTileOverlay.m
//  Macoun2015
//
//  Created by Philip Schneider on 19.08.15.
//  Copyright (c) 2015 phschneider.net. All rights reserved.
//

#import "OSMMapBoxRunBikeHikeTileOverlay.h"


@implementation OSMMapBoxRunBikeHikeTileOverlay


#ifdef MAPBOX_API_KEY
- (NSURL *)URLForTilePath:(MKTileOverlayPath)path
{
    NSString *accessToken = MAPBOX_API_KEY;
    NSString *format = @".png";
    NSString *mapID = @"mapbox.run-bike-hike";
       
    NSString *urlString = [NSString stringWithFormat:@"https://api.mapbox.com/v4/%@/%ld/%ld/%ld%@?access_token=%@", mapID, path.z, path.x, path.y, format, accessToken];
    
    return [NSURL URLWithString:urlString];
}


#else
- (NSString*)storageForPath:(MKTileOverlayPath)path
{
    NSBundle* mainBundle = [NSBundle mainBundle];

    NSString *bundlePath = [mainBundle pathForResource:[NSString stringWithFormat:@"mapbox-runbikehike-%ld-%ld-%ld", path.z, path.x, path.y] ofType:@"png"];
    NSLog(@"BundlePath = %@", bundlePath);
    return bundlePath;
}


- (void)loadTileAtPath:(MKTileOverlayPath)path
                result:(void (^)(NSData *data, NSError *error))result
{
    if (!result) {
        return;
    }

    NSData *storedData = [NSData dataWithContentsOfFile:[self storageForPath:path]];
    if (storedData)
    {
        NSLog(@"storedData");
        result(storedData, nil);
    }
}
#endif

@end
