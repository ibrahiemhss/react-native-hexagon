#import <UIKit/UIKit.h>

#import <SDWebImage/SDAnimatedImageView+WebCache.h>
#import <SDWebImage/SDWebImageDownloader.h>

#import <React/RCTComponent.h>
#import <React/RCTResizeMode.h>

#import "FFHexagonImageSource.h"

@interface FFHexagonImageView : SDAnimatedImageView

@property (nonatomic, copy) RCTDirectEventBlock onHexagonImageLoadStart;
@property (nonatomic, copy) RCTDirectEventBlock onHexagonImageProgress;
@property (nonatomic, copy) RCTDirectEventBlock onHexagonImageError;
@property (nonatomic, copy) RCTDirectEventBlock onHexagonImageLoad;
@property (nonatomic, copy) RCTDirectEventBlock onHexagonImageLoadEnd;
@property (nonatomic, assign) RCTResizeMode resizeMode;
@property (nonatomic, strong) FFHexagonImageSource *source;
@property (nonatomic, strong) UIImage *defaultSource;
@property (nonatomic, strong) UIColor *imageColor;

@end

