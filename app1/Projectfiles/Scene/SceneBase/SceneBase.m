//
// Created by Gregory Tkach on 4/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SceneBase.h"
#import "SceneGame.h"
#import "SharedProgressManager.h"
#import "SharedDeviceHelper.h"

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
    [self performSelectorInBackground:@selector(_setScene:) withObject:[NSNumber numberWithInt:type]];
}

+ (void)_setScene:(NSNumber *)typeObj
{
    ESceneType type = (ESceneType) [typeObj integerValue];

    if (_currentScene)
    {
        [_currentScene _startLoading];

        [_currentScene _clearScene];

        _currentScene = nil;
    }

    switch (type)
    {
        case EST_GAME:
        {
            _currentScene = [SceneGame createScene];
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

    [[CCDirector sharedDirector] runWithScene:scene];

    [_currentScene loadResources];

    [_currentScene performSelectorOnMainThread:@selector(prepare) withObject:nil waitUntilDone:YES];

    switch ([SharedDeviceHelper shared].deviceType)
    {
        case EDT_IPHONE:
        case EDT_IPHONE_RETINA:
        {
            [_currentScene placeViewsiPhone];

            break;
        }
        case EDT_IPHONE_RETINA_WIDE:
        {
            [_currentScene placeViewsiPhoneWide];

            break;
        }
        case EDT_IPAD:
        case EDT_IPAD_RETINA:
        {
            [_currentScene placeViewsiPad];

            break;
        }
        default:
        {
            //Not implemented
            NSAssert(NO, @"SceneBase::_setScene. Not implemented");
            break;
        }
    }

    [_currentScene _endLoading];
}


- (void)_startLoading
{
    NSLog(@"BEGIN LOADING");
    [self _reportMemory];

//    [[SharedLoader shared] startLoading];
    [[CCDirector sharedDirector] stopAnimation];
}

- (void)_endLoading
{
    [[CCDirector sharedDirector] startAnimation];

//    [[SharedLoader shared] stopLoading];

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
        [[CCDirector sharedDirector].touchDispatcher removeAllDelegates];

        [self stopAllActions];

        [self removeFromParentAndCleanup:YES];

        [[CCDirector sharedDirector] popScene];

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