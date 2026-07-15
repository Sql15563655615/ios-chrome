/* UIKit compatibility declarations for Objective-C++ shell code targeting iOS 9.3.
 * This overlay provides compile-time names used by newer Chromium/iOS code while
 * the actual runtime must continue to avoid iOS 10+ and iOS 13+ APIs on device.
 */
#pragma once
#import <UIKit/UIKit.h>

#ifndef IOS_CHROME_IOS93_UIKIT_COMPATIBILITY_H_
#define IOS_CHROME_IOS93_UIKIT_COMPATIBILITY_H_

#ifndef API_AVAILABLE
#define API_AVAILABLE(...)
#endif

#ifndef API_UNAVAILABLE
#define API_UNAVAILABLE(...)
#endif

#ifndef API_DEPRECATED_WITH_REPLACEMENT
#define API_DEPRECATED_WITH_REPLACEMENT(replacement, ...)
#endif

#ifndef NS_SWIFT_NAME
#define NS_SWIFT_NAME(_name)
#endif

#ifndef UISceneActivationState
typedef NS_ENUM(NSInteger, UISceneActivationState) {
  UISceneActivationStateUnattached = -1,
  UISceneActivationStateForegroundActive = 0,
  UISceneActivationStateForegroundInactive = 1,
  UISceneActivationStateBackground = 2,
};
#endif

#ifndef UIUserInterfaceStyle
typedef NS_ENUM(NSInteger, UIUserInterfaceStyle) {
  UIUserInterfaceStyleUnspecified = 0,
  UIUserInterfaceStyleLight = 1,
  UIUserInterfaceStyleDark = 2,
};
#endif

@class UIScene;
@class UIWindowScene;
@class UISceneSession;
@class UISceneConfiguration;
@class UISceneConnectionOptions;

#endif  /* IOS_CHROME_IOS93_UIKIT_COMPATIBILITY_H_ */
