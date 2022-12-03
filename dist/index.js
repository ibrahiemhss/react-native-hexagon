import _extends from '@babel/runtime/helpers/extends';
import React, { forwardRef, memo } from 'react';
import { NativeModules, StyleSheet, requireNativeComponent, Image, View, Platform } from 'react-native';

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

  if (Platform.OS === 'android') {
    // Android receives a URI string, and resolves into a Drawable using RN's methods.
    const resolved = Image.resolveAssetSource(defaultSource);

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
    const resolvedSource = Image.resolveAssetSource(cleanedSource);
    return /*#__PURE__*/React.createElement(View, {
      style: [styles.imageContainer, style],
      ref: forwardedRef
    }, /*#__PURE__*/React.createElement(Image, _extends({}, props, {
      style: StyleSheet.absoluteFill,
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

  const resolvedSource = Image.resolveAssetSource(source);
  const resolvedDefaultSource = resolveDefaultSource(defaultSource);
  return /*#__PURE__*/React.createElement(View, {
    style: [styles.imageContainer, style],
    ref: forwardedRef
  }, /*#__PURE__*/React.createElement(HexagonImageView, _extends({}, props, {
    tintColor: tintColor,
    style: StyleSheet.absoluteFill,
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

const HexagonImageMemo = /*#__PURE__*/memo(HexagonImageBase);
const HexagonImageComponent = /*#__PURE__*/forwardRef((props, ref) => /*#__PURE__*/React.createElement(HexagonImageMemo, _extends({
  forwardedRef: ref
}, props)));
HexagonImageComponent.displayName = 'HexagonImage';
const HexagonImage = HexagonImageComponent;
HexagonImage.resizeMode = resizeMode;
HexagonImage.cacheControl = cacheControl;
HexagonImage.priority = priority;

HexagonImage.preload = sources => NativeModules.HexagonImageView.preload(sources);

HexagonImage.clearMemoryCache = () => NativeModules.HexagonImageView.clearMemoryCache();

HexagonImage.clearDiskCache = () => NativeModules.HexagonImageView.clearDiskCache();

const styles = StyleSheet.create({
  imageContainer: {
    overflow: 'hidden'
  }
}); // Types of requireNativeComponent are not correct.

const HexagonImageView = requireNativeComponent('HexagonImageView', HexagonImage, {
  nativeOnly: {
    onHexagonImageLoadStart: true,
    onHexagonImageProgress: true,
    onHexagonImageLoad: true,
    onHexagonImageError: true,
    onHexagonImageLoadEnd: true
  }
});

export default HexagonImage;
