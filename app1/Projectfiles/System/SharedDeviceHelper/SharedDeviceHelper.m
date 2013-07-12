//
// Created by Gregory Tkach on 4/23/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SharedDeviceHelper.h"


@implementation SharedDeviceHelper
{

}

/*
 * Properties
 */
- (ELanguageType)currentLanguage
{
    return ELT_JAPANESE;
}


//! Returns current device type.
- (EDeviceType)deviceType
{
    EDeviceType result = EDT_COUNT;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        result = ([UIScreen mainScreen].scale == 1 ? EDT_IPAD : EDT_IPAD_RETINA);
    }
    else
    {
        if (isWidescreenEnabled())
        {
            result = EDT_IPHONE_RETINA_WIDE;
        }
        else
        {
            result = ([UIScreen mainScreen].scale == 1 ? EDT_IPHONE : EDT_IPHONE_RETINA);
        }
    }

    return result;
}

/*
 * Methods
 */

static SharedDeviceHelper *instance = nil;

+ (SharedDeviceHelper *)shared
{
    @synchronized (self)
    {
        if (!instance)
        {
            instance = [[SharedDeviceHelper alloc] init];
        }
    }

    return instance;
}

@end