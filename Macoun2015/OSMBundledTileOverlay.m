//
//  OSMBundledTileOverlay.m
//  Macoun2015
//
//  Created by Philip Schneider on 23.10.15.
//  Copyright © 2015 Philip Schneider. All rights reserved.
//

#import "OSMBundledTileOverlay.h"

@implementation OSMBundledTileOverlay


- (NSString*)storageForPath:(MKTileOverlayPath)path
{
    NSBundle* mainBundle = [NSBundle mainBundle];
    
    NSString *bundlePath = [mainBundle pathForResource:[NSString stringWithFormat:@"%ld-%ld-%ld", path.z, path.x, path.y] ofType:@"png"];
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

@end
