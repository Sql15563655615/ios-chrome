/* Compatibility overlay for SDKs that do not ship modern os/availability.h. */
#pragma once
#ifndef IOS_CHROME_IOS93_COMPAT_OS_AVAILABILITY_H_
#define IOS_CHROME_IOS93_COMPAT_OS_AVAILABILITY_H_

#ifndef API_AVAILABLE
#define API_AVAILABLE(...)
#endif

#ifndef API_UNAVAILABLE
#define API_UNAVAILABLE(...)
#endif

#ifndef API_DEPRECATED
#define API_DEPRECATED(...)
#endif

#endif  /* IOS_CHROME_IOS93_COMPAT_OS_AVAILABILITY_H_ */
