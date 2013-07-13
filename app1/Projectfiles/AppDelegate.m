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
#import "SharedHighScoreManager.h"

@implementation AppDelegate

-(void) initializationComplete
{
#ifdef KK_ARC_ENABLED
	CCLOG(@"ARC is enabled");
#else
	CCLOG(@"ARC is either not available or not enabled");
#endif



    glClearColor(0.2f, 0.2f, 0.4f, 1.0f);

    {//init singletons
        [SimpleAudioEngine sharedEngine];

        [SharedProgressManager shared];

        [SharedHighScoreManager shared];
    }

    Game *game = [[Game alloc] init];

    [[SharedProgressManager shared] didGameStart:game];

    [SceneBase setScene:EST_GAME];

    [NSThread sleepForTimeInterval:0.1f]; //Needed for scene to initialize

    [super initializationComplete];

}

-(id) alternateView
{
	return nil;
}

-(void)applicationWillTerminate:(UIApplication *)application
{
}

@end
