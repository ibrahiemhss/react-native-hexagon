#import "FFHexagonImageView.h"
#import <SDWebImage/UIImage+MultiFormat.h>
#import <SDWebImage/UIView+WebCache.h>

@interface FFHexagonImageView ()

@property(nonatomic, assign) BOOL hasSentOnLoadStart;
@property(nonatomic, assign) BOOL hasCompleted;
@property(nonatomic, assign) BOOL hasErrored;
// Whether the latest change of props requires the image to be reloaded
@property(nonatomic, assign) BOOL needsReload;

@property(nonatomic, strong) NSDictionary* onLoadEvent;

@end

@implementation FFHexagonImageView

- (id) init {
    self = [super init];
    self.resizeMode = RCTResizeModeCover;
    self.clipsToBounds = YES;
    return self;
}

- (void) setResizeMode: (RCTResizeMode)resizeMode {
    if (_resizeMode != resizeMode) {
        _resizeMode = resizeMode;
        self.contentMode = (UIViewContentMode) resizeMode;
    }
}

- (void) setOnHexagonImageLoadEnd: (RCTDirectEventBlock)onHexagonImageLoadEnd {
    _onHexagonImageLoadEnd = onHexagonImageLoadEnd;
    if (self.hasCompleted) {
        _onHexagonImageLoadEnd(@{});
    }
}

- (void) setOnHexagonImageLoad: (RCTDirectEventBlock)onHexagonImageLoad {
    _onHexagonImageLoad = onHexagonImageLoad;
    if (self.hasCompleted) {
        _onHexagonImageLoad(self.onLoadEvent);
    }
}

- (void) setOnHexagonImageError: (RCTDirectEventBlock)onHexagonImageError {
    _onHexagonImageError = onHexagonImageError;
    if (self.hasErrored) {
        _onHexagonImageError(@{});
    }
}

- (void) setOnHexagonImageLoadStart: (RCTDirectEventBlock)onHexagonImageLoadStart {
    if (_source && !self.hasSentOnLoadStart) {
        _onHexagonImageLoadStart = onHexagonImageLoadStart;
        onHexagonImageLoadStart(@{});
        self.hasSentOnLoadStart = YES;
    } else {
        _onHexagonImageLoadStart = onHexagonImageLoadStart;
        self.hasSentOnLoadStart = NO;
    }
}

- (void) setImageColor: (UIColor*)imageColor {
    if (imageColor != nil) {
        _imageColor = imageColor;
        if (super.image) {
            super.image = [self makeImage: super.image withTint: self.imageColor];
        }
    }
}

- (UIImage*) makeImage: (UIImage*)image withTint: (UIColor*)color {
    UIImage* newImage = [image imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(image.size, NO, newImage.scale);
    [color set];
    [newImage drawInRect: CGRectMake(0, 0, image.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void) setImage: (UIImage*)image {
    if (self.imageColor != nil) {
        super.image = [self makeImage: image withTint: self.imageColor];
    } else {
        super.image = image;
    }
}

- (void) sendOnLoad: (UIImage*)image {
    self.onLoadEvent = @{
            @"width": [NSNumber numberWithDouble: image.size.width],
            @"height": [NSNumber numberWithDouble: image.size.height]
    };
    if (self.onHexagonImageLoad) {
        self.onHexagonImageLoad(self.onLoadEvent);
    }
}

- (void) setSource: (FFHexagonImageSource*)source {
    if (_source != source) {
        _source = source;
        _needsReload = YES;
    }
}

- (void) setDefaultSource: (UIImage*)defaultSource {
    if (_defaultSource != defaultSource) {
        _defaultSource = defaultSource;
        _needsReload = YES;
    }
}

- (void) didSetProps: (NSArray<NSString*>*)changedProps {
    if (_needsReload) {
        [self reloadImage];
    }
}

- (void) reloadImage {
    _needsReload = NO;

    if (_source) {
        // Load base64 images.
        NSString* url = [_source.url absoluteString];
        if (url && [url hasPrefix: @"data:image"]) {
            if (self.onHexagonImageLoadStart) {
                self.onHexagonImageLoadStart(@{});
                self.hasSentOnLoadStart = YES;
            } else {
                self.hasSentOnLoadStart = NO;
            }
            // Use SDWebImage API to support external format like WebP images
            UIImage* image = [UIImage sd_imageWithData: [NSData dataWithContentsOfURL: _source.url]];
            [self setImage: image];
            if (self.onHexagonImageProgress) {
                self.onHexagonImageProgress(@{
                        @"loaded": @(1),
                        @"total": @(1)
                });
            }
            self.hasCompleted = YES;
            [self sendOnLoad: image];

            if (self.onHexagonImageLoadEnd) {
                self.onHexagonImageLoadEnd(@{});
            }
            return;
        }

        // Set headers.
        NSDictionary* headers = _source.headers;
        SDWebImageDownloaderRequestModifier* requestModifier = [SDWebImageDownloaderRequestModifier requestModifierWithBlock: ^NSURLRequest* _Nullable (NSURLRequest* _Nonnull request) {
            NSMutableURLRequest* mutableRequest = [request mutableCopy];
            for (NSString* header in headers) {
                NSString* value = headers[header];
                [mutableRequest setValue: value forHTTPHeaderField: header];
            }
            return [mutableRequest copy];
        }];
        SDWebImageContext* context = @{SDWebImageContextDownloadRequestModifier: requestModifier};

        // Set priority.
        SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageHandleCookies;
        switch (_source.priority) {
            case FFFPriorityLow:
                options |= SDWebImageLowPriority;
                break;
            case FFFPriorityNormal:
                // Priority is normal by default.
                break;
            case FFFPriorityHigh:
                options |= SDWebImageHighPriority;
                break;
        }

        switch (_source.cacheControl) {
            case FFFCacheControlWeb:
                options |= SDWebImageRefreshCached;
                break;
            case FFFCacheControlCacheOnly:
                options |= SDWebImageFromCacheOnly;
                break;
            case FFFCacheControlImmutable:
                break;
        }

        if (self.onHexagonImageLoadStart) {
            self.onHexagonImageLoadStart(@{});
            self.hasSentOnLoadStart = YES;
        } else {
            self.hasSentOnLoadStart = NO;
        }
        self.hasCompleted = NO;
        self.hasErrored = NO;

        [self downloadImage: _source options: options context: context];
    } else if (_defaultSource) {
        [self setImage: _defaultSource];
    }
}

- (void) downloadImage: (FFHexagonImageSource*)source options: (SDWebImageOptions)options context: (SDWebImageContext*)context {
    __weak typeof(self) weakSelf = self; // Always use a weak reference to self in blocks
    [self sd_setImageWithURL: _source.url
            placeholderImage: _defaultSource
                     options: options
                     context: context
                    progress: ^(NSInteger receivedSize, NSInteger expectedSize, NSURL* _Nullable targetURL) {
                        if (weakSelf.onHexagonImageProgress) {
                            weakSelf.onHexagonImageProgress(@{
                                    @"loaded": @(receivedSize),
                                    @"total": @(expectedSize)
                            });
                        }
                    } completed: ^(UIImage* _Nullable image,
                    NSError* _Nullable error,
                    SDImageCacheType cacheType,
                    NSURL* _Nullable imageURL) {
                if (error) {
                    weakSelf.hasErrored = YES;
                    if (weakSelf.onHexagonImageError) {
                        weakSelf.onHexagonImageError(@{});
                    }
                    if (weakSelf.onHexagonImageLoadEnd) {
                        weakSelf.onHexagonImageLoadEnd(@{});
                    }
                } else {
                    weakSelf.hasCompleted = YES;
                    [weakSelf sendOnLoad: image];
                    if (weakSelf.onHexagonImageLoadEnd) {
                        weakSelf.onHexagonImageLoadEnd(@{});
                    }
                }
            }];
}

- (void) dealloc {
    [self sd_cancelCurrentImageLoad];
}

@end
