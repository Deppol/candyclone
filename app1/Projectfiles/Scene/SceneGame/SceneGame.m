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
#import "MyConstants.h"
#import "Candy.h"
#import "CandyView.h"
#import "cpConstraintNode.h"

@implementation SceneGame
{
	NSMutableArray* scene;
    NSMutableArray* _candies;
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

    _candies = [NSMutableArray arrayWithCapacity:FIELD_SIZE*FIELD_SIZE];

    for(NSUInteger i = 0; i<FIELD_SIZE; i++)
        for(NSUInteger j = 0; j<FIELD_SIZE; j++)
        {
            CandyView* v = [[CandyView alloc] initWithCandy:[_gameManager.candies objectAtIndex:i*FIELD_SIZE+j]];
            [_candies insertObject:v atIndex:i*FIELD_SIZE+j];
            [self addChild:v.button];
        }
    [_gameManager doInitialUpdate];
}

- (void)_initGameObjects
{
	_gameManager = [[GameManager alloc] init];

}

-(void)placeViewsiPhone
{
    _sound.button.position = ccp(30,450);

    for(NSUInteger i = 0; i<FIELD_SIZE; i++)
        for(NSUInteger j = 0; j<FIELD_SIZE; j++)
        {
            [[[_candies objectAtIndex:i * FIELD_SIZE + j] button] setSquare:40.0f];
            [[[_candies objectAtIndex:i * FIELD_SIZE + j] button] setPosition:ccp(22+(FIELD_SIZE-i-1)*45,22+(FIELD_SIZE-j-1)*50)];
        }
}
-(void)placeViewsiPhoneWide
{
    _sound.button.scale = 2.0f;
    _sound.button.position = ccp(30,538);

    for(NSUInteger i = 0; i<FIELD_SIZE; i++)
        for(NSUInteger j = 0; j<FIELD_SIZE; j++)
        {
            [[[_candies objectAtIndex:i * FIELD_SIZE + j] button] setSquare:40.0f];
            [[[_candies objectAtIndex:i * FIELD_SIZE + j] button] setPosition:ccp(22+(FIELD_SIZE-i-1)*45,22+(FIELD_SIZE-j-1)*50)];
        }

}

-(void)cleanup
{
    [_sound cleanup];
    _sound = nil;
    for(NSUInteger i = 0; i<FIELD_SIZE; i++)
        for(NSUInteger j = 0; j<FIELD_SIZE; j++)
        {
            [_candies insertObject:nil atIndex:i*FIELD_SIZE+j];
        }
    [super cleanup];
}

@end
