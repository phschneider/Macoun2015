//
//  OSMSaveTileOverlay.m
//  Macoun2015
//
//  Created by Philip Schneider on 23.10.15.
//  Copyright © 2015 Philip Schneider. All rights reserved.
//

#import "OSMSaveTileOverlay.h"

@implementation OSMSaveTileOverlay


- (NSString*)storageForPath:(MKTileOverlayPath)path
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld-%ld-%ld.png",path.z, path.x, path.y]]];
    
    return databasePath;
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
        NSLog(@"Load stored");
        result(storedData, nil);
    }
    else
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:[self URLForTilePath:path]];
        /*
         * The shared session uses the currently set global NSURLCache,
         * NSHTTPCookieStorage and NSURLCredentialStorage objects.
         */
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError)
          {
              if (connectionError)
              {
                  NSLog(@"ConnectionError = %@",connectionError);
              }
              
              if (data)
              {
                  NSLog(@"save to %@", [[self storageForPath:path] lastPathComponent]);
                  [data writeToFile:[self storageForPath:path] atomically:YES];
              }
              result(data, connectionError);
          }] resume];
    }
}

@end
