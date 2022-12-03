#import "FFHexagonImageViewManager.h"
#import "FFHexagonImageView.h"

#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImagePrefetcher.h>

@implementation FFHexagonImageViewManager

RCT_EXPORT_MODULE(HexagonImageView)

- (FFHexagonImageView*)view {
  return [[FFHexagonImageView alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(source, FFHexagonImageSource)
RCT_EXPORT_VIEW_PROPERTY(defaultSource, UIImage)
RCT_EXPORT_VIEW_PROPERTY(resizeMode, RCTResizeMode)
RCT_EXPORT_VIEW_PROPERTY(onHexagonImageLoadStart, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onHexagonImageProgress, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onHexagonImageError, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onHexagonImageLoad, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onHexagonImageLoadEnd, RCTDirectEventBlock)
RCT_REMAP_VIEW_PROPERTY(tintColor, imageColor, UIColor)

RCT_EXPORT_METHOD(preload:(nonnull NSArray<FFHexagonImageSource *> *)sources)
{
    NSMutableArray *urls = [NSMutableArray arrayWithCapacity:sources.count];

    [sources enumerateObjectsUsingBlock:^(FFHexagonImageSource * _Nonnull source, NSUInteger idx, BOOL * _Nonnull stop) {
        [source.headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString* header, BOOL *stop) {
            [[SDWebImageDownloader sharedDownloader] setValue:header forHTTPHeaderField:key];
        }];
        [urls setObject:source.url atIndexedSubscript:idx];
    }];

    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:urls];
}

RCT_EXPORT_METHOD(clearMemoryCache:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
{
    [SDImageCache.sharedImageCache clearMemory];
    resolve(NULL);
}

RCT_EXPORT_METHOD(clearDiskCache:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
{
    [SDImageCache.sharedImageCache clearDiskOnCompletion:^(){
        resolve(NULL);
    }];
}

@end
