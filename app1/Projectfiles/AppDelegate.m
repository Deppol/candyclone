/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "AppDelegate.h"
#import "ESceneType.h"
#import "SceneBase.h"
#import "SharedProgressManager.h"
#import "Game.h"
#import "SimpleAudioEngine.h"

@implementation AppDelegate

-(void) initializationComplete
{
#ifdef KK_ARC_ENABLED
	CCLOG(@"ARC is enabled");
#else
	CCLOG(@"ARC is either not available or not enabled");
#endif
    [super initializationComplete];

    glClearColor(0.2f, 0.2f, 0.4f, 1.0f);

    {//init singletons
        [SimpleAudioEngine sharedEngine];

        [SharedProgressManager shared];
    }

    Game *game = [[Game alloc] init];

    [[SharedProgressManager shared] didGameStart:game];

    [SceneBase setScene:EST_GAME];

}

-(id) alternateView
{
	return nil;
}

@end
