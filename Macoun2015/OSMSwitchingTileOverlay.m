//
//  OSMSwitchingTileOverlay.m
//  Macoun2015
//
//  Created by Philip Schneider on 23.10.15.
//  Copyright © 2015 Philip Schneider. All rights reserved.
//

#import "OSMSwitchingTileOverlay.h"

@implementation OSMSwitchingTileOverlay

- (NSURL *)URLForTilePath:(MKTileOverlayPath)path
{
    //http://wiki.openstreetmap.org/wiki/Tileserver
    
    NSString *template;
    switch (path.z) {
        case 1:
            template = [NSString stringWithFormat:@"http://tiles.openpistemap.org/landshaded/%ld/%ld/%ld.png", path.z, path.x, path.y];
            break;
        
        case 2:
            template = [NSString stringWithFormat:@"http://www.openptmap.org/tiles/%ld/%ld/%ld.png", path.z, path.x, path.y];
            break;
           
        case 8:
            template = [NSString stringWithFormat:@"http://www.openptmap.org/tiles/%ld/%ld/%ld.png", path.z, path.x, path.y];
            break;
            
            
        case 10:
            template = [NSString stringWithFormat:@"http://tiles.openpistemap.org/landshaded/%ld/%ld/%ld.png", path.z, path.x, path.y];
            break;

            
        default:
            template = [NSString stringWithFormat:@"http://b.tiles.wmflabs.org/hikebike/%ld/%ld/%ld.png", path.z, path.x, path.y];
            break;
    }
    
    return [NSURL URLWithString:template];
}


@end
