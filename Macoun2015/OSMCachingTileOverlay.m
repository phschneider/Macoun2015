//
//  OSMCachingTileOverlay.m
//  Macoun2015
//
//  Created by Philip Schneider on 23.10.15.
//  Copyright © 2015 Philip Schneider. All rights reserved.
//

#import "OSMCachingTileOverlay.h"

@interface OSMCachingTileOverlay ()
@property NSCache *cache;
@end


@implementation OSMCachingTileOverlay

- (instancetype)initWithURLTemplate:(NSString *)URLTemplate
{
    self = [super initWithURLTemplate:URLTemplate];
    if (self)
    {
        self.cache = [[NSCache alloc] init];
    }
    
    return self;
}


- (void)loadTileAtPath:(MKTileOverlayPath)path
                result:(void (^)(NSData *data, NSError *error))result
{
    if (!result)
    {
        return;
    }

    NSString *key = [NSString stringWithFormat:@"%ld/%ld/%ld",path.z, path.x, path.y];
    NSData *cachedData = [self.cache objectForKey:key];
    if (cachedData)
    {
        NSLog(@"Load from cache");
        result(cachedData, nil);
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
                 NSLog(@"Save to cache %@", key);
                 [self.cache setObject:data forKey:key];
             }
             result(data, connectionError);
         }] resume];
    }
}


@end
