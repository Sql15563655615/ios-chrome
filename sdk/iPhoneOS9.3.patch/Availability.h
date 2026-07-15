/* Compatibility overlay for iPhoneOS9.3 SDK availability macros.
 * This file must be used before, not written into, the original SDK.
 */
#pragma once
#include_next <Availability.h>

#ifndef IOS_CHROME_IOS93_COMPAT_AVAILABILITY_H_
#define IOS_CHROME_IOS93_COMPAT_AVAILABILITY_H_

#ifndef API_AVAILABLE
#define API_AVAILABLE(...)
#endif

#ifndef API_UNAVAILABLE
#define API_UNAVAILABLE(...)
#endif

#ifndef API_DEPRECATED_WITH_REPLACEMENT
#define API_DEPRECATED_WITH_REPLACEMENT(replacement, ...)
#endif

#endif  /* IOS_CHROME_IOS93_COMPAT_AVAILABILITY_H_ */
