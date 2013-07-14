/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "SceneGame.h"
#import "SimpleAudioEngine.h"
#import "Game.h"
#import "SharedProgressManager.h"
#import "GameManager.h"
#import "SoundView.h"
#import "CCButton.h"

@implementation SceneGame
{
	NSMutableArray *scene;
    SoundView* _sound;
}
/*
 * Static
 */

//! Default creator for scene. Need override in derived classes.
+ (SceneBase *)createScene
{
	SceneGame *result = [[SceneGame alloc] init];

	return result;
}

/*
 * Properties
 */
- (ESceneType)type
{
	return EST_GAME;
}

/*
 * Instance
 */

//! Load all resources here
- (void)loadResources
{
	[super loadResources];

	//TODO:implement purge

//    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[ResourceManager sceneGameBasic]];

}

//! Prepare scene. Init all game objects here
- (void)prepare
{
	[super prepare];

    _sound = [SoundView createView];
    [self addChild:_sound.button];

	[[SharedProgressManager shared].game setupScene:self];

	[self _initGameObjects];
}

- (void)_initGameObjects
{
	_gameManager = [[GameManager alloc] init];

}

-(void)placeViewsiPhone
{
    _sound.button.position = ccp(30,450);
}
-(void)placeViewsiPhoneWide
{
    _sound.button.scale = 2.0f;
    _sound.button.position = ccp(30,538);

}

-(void)cleanup
{
    [_sound cleanup];
    _sound = nil;
    [super cleanup];
}

@end
