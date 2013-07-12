//
// Created by Gregory Tkach on 4/23/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "EDeviceType.h"
#import "ELanguageType.h"

@interface SharedDeviceHelper : NSObject

//! Returns current language
@property (nonatomic, readonly) ELanguageType currentLanguage;

//! Returns current device type.
@property (nonatomic, readonly) EDeviceType deviceType;

+ (SharedDeviceHelper *)shared;
@end