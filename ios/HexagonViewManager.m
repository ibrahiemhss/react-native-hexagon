#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(HexagonViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(src, NSString)
RCT_EXPORT_VIEW_PROPERTY(borderColor, NSString)
RCT_EXPORT_VIEW_PROPERTY(size, NSUInteger)
RCT_EXPORT_VIEW_PROPERTY(borderWidth, NSUInteger)
RCT_EXPORT_VIEW_PROPERTY(cornerRadius, NSUInteger)


@end
