//
// Created by Gregory Tkach on 4/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SceneBase.h"
#import "SceneGame.h"
#import "SharedDeviceHelper.h"
#import "SharedHighScoreManager.h"
#import "SceneStart.h"

#include <mach/mach.h>
#import <sys/sysctl.h>


@implementation SceneBase
{

}


/*
 * Static functions
 */

static SceneBase *_currentScene = nil;

+ (SceneBase *)currentScene
{
    return _currentScene;
}

+ (void)setScene:(ESceneType)type
{
    [self performSelectorOnMainThread:@selector(_setScene:) withObject:[NSNumber numberWithInt:type] waitUntilDone:YES];
}

+ (void)setSceneWithNumber:(NSNumber*)t
{
    [self performSelectorOnMainThread:@selector(_setScene:) withObject:t waitUntilDone:YES];
}

+ (void)_setScene:(NSNumber *)typeObj
{
    ESceneType type = (ESceneType) [typeObj integerValue];

    if (_currentScene)
    {
        [_currentScene _startLoading];
        [_currentScene _clearScene];

        //[_sceneToClean cleanup];//TODO: CHECK

        _currentScene = nil;
    }

    switch (type)
    {
        case EST_GAME:
        {
            _currentScene = [SceneGame createScene];
            break;
        }

        case EST_START: //!Temporary scene. Made only to test Highscores. To be removed.
        {
            _currentScene = [SceneStart createScene];
            break;
        }

        default:
        {
            //Not implemented
            NSAssert(NO, @"SceneBase::_setScene. Not implemented");
            break;
        }
    }

    CCScene *scene = [CCScene node];

    [scene addChild:_currentScene];

    [[CCDirector sharedDirector] runningScene] == nil ? [[CCDirector sharedDirector] runWithScene:scene]
            : [[CCDirector sharedDirector] replaceScene:scene];

    [_currentScene loadResources];

    [_currentScene performSelectorOnMainThread:@selector(prepare) withObject:nil waitUntilDone:YES];

    SEL selectorPlaceViews = nil;

    switch ([SharedDeviceHelper shared].deviceType)
    {
        case EDT_IPHONE:
        case EDT_IPHONE_RETINA:
        {
            selectorPlaceViews = @selector(placeViewsiPhone);

            break;
        }
        case EDT_IPHONE_RETINA_WIDE:
        {
            selectorPlaceViews = @selector(placeViewsiPhoneWide);

            break;
        }
        case EDT_IPAD:
        case EDT_IPAD_RETINA:
        {
            selectorPlaceViews = @selector(placeViewsiPad);

            break;
        }
        default:
        {
            //Not implemented
            NSAssert(NO, @"SceneBase::_setScene. Not implemented");
            break;
        }
    }

    [_currentScene performSelectorOnMainThread:selectorPlaceViews withObject:nil waitUntilDone:YES];

    [_currentScene _endLoading];

}


- (void)_startLoading
{
    NSLog(@"BEGIN LOADING");
    [self _reportMemory];
}

- (void)_endLoading
{
    [self _reportMemory];
    NSLog(@"END LOADING");
}

- (void)_reportMemory
{
    NSInteger mib[6];
    mib[0] = CTL_HW;
    mib[1] = HW_PAGESIZE;

    int pagesize;
    size_t length;
    length = sizeof (pagesize);
    if (sysctl(mib, 2, &pagesize, &length, NULL, 0) < 0)
    {
        fprintf(stderr, "getting page size");
    }

    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;

    vm_statistics_data_t vmstat;
    if (host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t) &vmstat, &count) != KERN_SUCCESS)
    {
        fprintf(stderr, "Failed to get VM statistics.");
    }

    task_basic_info_64_data_t info;
    unsigned size = sizeof (info);
    task_info(mach_task_self (), TASK_BASIC_INFO_64, (task_info_t) &info, &size);

    double unit = 1024 * 1024;
    NSString *text = [NSString stringWithFormat:@"FREE IN APP: % 3.1f MB \\ FREE IN OS: % 3.1f MB \\ USED:% 3.1f MB", vmstat.free_count * pagesize / unit, (vmstat.free_count + vmstat.inactive_count) * pagesize / unit, info.resident_size / unit];
    NSLog(@"MEM: %@", text);
}

- (void)_clearScene
{
    @autoreleasepool
    {
        //[[CCDirector sharedDirector].touchDispatcher removeAllDelegates];

        [self removeFromParentAndCleanup:YES];

        [self stopAllActions];

        [[CCTextureCache sharedTextureCache] removeAllTextures];
    }
}

//! Default creator for scene. Need override in derived classes.
+ (SceneBase *)createScene
{
    NSAssert(NO, @"SceneBase::createScene. Implement this method in derived classes.");

    return nil;
}


/*
 * Properties
 */
- (ESceneType)type
{
    NSAssert(NO, @"SceneBase::type. Implement this method in derived classes.");

    return EST_COUNT;
}

- (void)cleanup
{
    [super cleanup];
}


/*
 * Instance methods
 */

//! Load all resources here
- (void)loadResources
{

}

//! Prepare scene. Init all game objects here
- (void)prepare
{

}

- (void)placeViewsiPhone
{

}

- (void)placeViewsiPhoneWide
{

}

- (void)placeViewsiPad
{

}
@end