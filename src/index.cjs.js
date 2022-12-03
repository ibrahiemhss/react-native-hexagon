'use strict';

var _extends = require('@babel/runtime/helpers/extends');
var React = require('react');
var reactNative = require('react-native');

function _interopDefaultLegacy (e) { return e && typeof e === 'object' && 'default' in e ? e : { 'default': e }; }

var _extends__default = /*#__PURE__*/_interopDefaultLegacy(_extends);
var React__default = /*#__PURE__*/_interopDefaultLegacy(React);

const resizeMode = {
  contain: 'contain',
  cover: 'cover',
  stretch: 'stretch',
  center: 'center'
};
const priority = {
  low: 'low',
  normal: 'normal',
  high: 'high'
};
const cacheControl = {
  // Ignore headers, use uri as cache key, fetch only if not in cache.
  immutable: 'immutable',
  // Respect http headers, no aggressive caching.
  web: 'web',
  // Only load from cache.
  cacheOnly: 'cacheOnly'
};

const resolveDefaultSource = defaultSource => {
  if (!defaultSource) {
    return null;
  }

  if (reactNative.Platform.OS === 'android') {
    // Android receives a URI string, and resolves into a Drawable using RN's methods.
    const resolved = reactNative.Image.resolveAssetSource(defaultSource);

    if (resolved) {
      return resolved.uri;
    }

    return null;
  } // iOS or other number mapped assets
  // In iOS the number is passed, and bridged automatically into a UIImage


  return defaultSource;
};

function HexagonImageBase({
  source,
  defaultSource,
  tintColor,
  onLoadStart,
  onProgress,
  onLoad,
  onError,
  onLoadEnd,
  style,
  fallback,
  children,
  // eslint-disable-next-line no-shadow
  resizeMode = 'cover',
  forwardedRef,
  ...props
}) {
  if (fallback) {
    const cleanedSource = { ...source
    };
    delete cleanedSource.cache;
    const resolvedSource = reactNative.Image.resolveAssetSource(cleanedSource);
    return /*#__PURE__*/React__default['default'].createElement(reactNative.View, {
      style: [styles.imageContainer, style],
      ref: forwardedRef
    }, /*#__PURE__*/React__default['default'].createElement(reactNative.Image, _extends__default['default']({}, props, {
      style: reactNative.StyleSheet.absoluteFill,
      source: resolvedSource,
      defaultSource: defaultSource,
      onLoadStart: onLoadStart,
      onProgress: onProgress,
      onLoad: onLoad,
      onError: onError,
      onLoadEnd: onLoadEnd,
      resizeMode: resizeMode
    })), children);
  }

  const resolvedSource = reactNative.Image.resolveAssetSource(source);
  const resolvedDefaultSource = resolveDefaultSource(defaultSource);
  return /*#__PURE__*/React__default['default'].createElement(reactNative.View, {
    style: [styles.imageContainer, style],
    ref: forwardedRef
  }, /*#__PURE__*/React__default['default'].createElement(HexagonImageView, _extends__default['default']({}, props, {
    tintColor: tintColor,
    style: reactNative.StyleSheet.absoluteFill,
    source: resolvedSource,
    defaultSource: resolvedDefaultSource,
    onHexagonImageLoadStart: onLoadStart,
    onHexagonImageProgress: onProgress,
    onHexagonImageLoad: onLoad,
    onHexagonImageError: onError,
    onHexagonImageLoadEnd: onLoadEnd,
    resizeMode: resizeMode
  })), children);
}

const HexagonImageMemo = /*#__PURE__*/React.memo(HexagonImageBase);
const HexagonImageComponent = /*#__PURE__*/React.forwardRef((props, ref) => /*#__PURE__*/React__default['default'].createElement(HexagonImageMemo, _extends__default['default']({
  forwardedRef: ref
}, props)));
HexagonImageComponent.displayName = 'HexagonImage';
const HexagonImage = HexagonImageComponent;
HexagonImage.resizeMode = resizeMode;
HexagonImage.cacheControl = cacheControl;
HexagonImage.priority = priority;

HexagonImage.preload = sources => reactNative.NativeModules.HexagonImageView.preload(sources);

HexagonImage.clearMemoryCache = () => reactNative.NativeModules.HexagonImageView.clearMemoryCache();

HexagonImage.clearDiskCache = () => reactNative.NativeModules.HexagonImageView.clearDiskCache();

const styles = reactNative.StyleSheet.create({
  imageContainer: {
    overflow: 'hidden'
  }
}); // Types of requireNativeComponent are not correct.

const HexagonImageView = reactNative.requireNativeComponent('HexagonImageView', HexagonImage, {
  nativeOnly: {
    onHexagonImageLoadStart: true,
    onHexagonImageProgress: true,
    onHexagonImageLoad: true,
    onHexagonImageError: true,
    onHexagonImageLoadEnd: true
  }
});

module.exports = HexagonImage;
