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
#import "ServiceView.h"
#import "CCButton.h"
#import "MyConstants.h"
#import "Candy.h"
#import "CandyView.h"
#import "cpConstraintNode.h"
#import "DelegateContainer.h"

@implementation SceneGame
{
	NSMutableArray* scene;
    NSMutableArray* _candies;
    ServiceView * _sound;
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

	_sound = [ServiceView createViewWithType:EBST_SOUND];
	[self addChild:_sound.button];

	[[SharedProgressManager shared].game setupScene:self];

	[self _initGameObjects];

	_candies = [NSMutableArray arrayWithCapacity:FIELD_SIZE * FIELD_SIZE];

    for(NSUInteger i = 0; i<FIELD_SIZE; i++)
        for(NSUInteger j = 0; j<FIELD_SIZE; j++)
        {
            CandyView* v = [[CandyView alloc] initWithCandy:[_gameManager.candies objectAtIndex:i*FIELD_SIZE+j] scene:self];
            [_candies insertObject:v atIndex:i*FIELD_SIZE+j];
            [self addChild:v.button];
        }

    [DelegateContainer subscribe:self];

    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"_test.mp3" loop:YES];
}

- (void)_initGameObjects
{
	_gameManager = [[GameManager alloc] init];

}

- (void)placeViewsiPhone
{
	_sound.button.position = ccp(30, 450);

	for (NSUInteger i = 0; i < FIELD_SIZE; i++)
		for (NSUInteger j = 0; j < FIELD_SIZE; j++)
		{
			[[[_candies objectAtIndex:i * FIELD_SIZE + j] button] setSquare:CANDY_VISIBLE_SIZE];
            CGPoint point = [self _calculatePositionByIndex:i*FIELD_SIZE+j];
			[[[_candies objectAtIndex:i * FIELD_SIZE + j] button] setPosition:point];
		}
    [_gameManager doInitialUpdate];
}

- (void)placeViewsiPhoneWide
{
	_sound.button.scale = 2.0f;
	_sound.button.position = ccp(30, 538);

	for (NSUInteger i = 0; i < FIELD_SIZE; i++)
		for (NSUInteger j = 0; j < FIELD_SIZE; j++)
		{
			[[[_candies objectAtIndex:i * FIELD_SIZE + j] button] setSquare:CANDY_VISIBLE_SIZE];
            CGPoint point = [self _calculatePositionByIndex:i*FIELD_SIZE+j];
            [[[_candies objectAtIndex:i * FIELD_SIZE + j] button] setPosition:point];
		}
    [_gameManager doInitialUpdate];
}

- (void)cleanup
{
	[_sound cleanup];
	_sound = nil;
    [DelegateContainer unsubscribe];
	for (NSUInteger i = 0; i < FIELD_SIZE; i++)
		for (NSUInteger j = 0; j < FIELD_SIZE; j++)
		{
			[_candies insertObject:[NSNull null] atIndex:i * FIELD_SIZE + j];
		}
	[super cleanup];
}

-(void)select:(CandyView*) v
{
    [_gameManager candyClick:v.representsCandy];
}

- (void)BonusActivated:(Candy *)candy
{
    NSUInteger i = [_gameManager getIndexOf:candy];
    [[_candies objectAtIndex:i] activateBonus];
}


- (void)Swap:(Candy *)candy1 candy2:(Candy *)candy2
{
    NSUInteger index1 = [_gameManager getIndexOf:candy1];
    NSUInteger index2 = [_gameManager getIndexOf:candy2];

    CandyView* v1 = [_candies objectAtIndex:index1];
    CandyView* v2 = [_candies objectAtIndex:index2];

    if(v1 == nil || v2 == nil)return;
    CGPoint p1 = v1.button.position;
    CGPoint p2 = v2.button.position;

    CCMoveTo* a1 = [CCMoveTo actionWithDuration:SWAP_ANIMATION_TIME position:p2];
    CCMoveTo* a2 = [CCMoveTo actionWithDuration:SWAP_ANIMATION_TIME position:p1];

    [_candies replaceObjectAtIndex:index1 withObject:v2];
    [_candies replaceObjectAtIndex:index2 withObject:v1];

    [v1.button runAction:a1];
    [v2.button runAction:a2];

}


- (void)SetSelection:(Candy *)candy
{
    [[_candies objectAtIndex:[_gameManager getIndexOf:candy]] activate];
}

- (void)UnsetSelection:(Candy *)candy
{
    [[_candies objectAtIndex:[_gameManager getIndexOf:candy]] deactivate];
}
- (void)AddBonus:(Candy*)candyBonus
{
   NSUInteger pos = [_gameManager getIndexOf:candyBonus];
   CandyView *newCandy = [[CandyView alloc] initWithCandy:candyBonus scene:self];

    [_candies replaceObjectAtIndex:pos withObject:newCandy];
    CGPoint point = [self _calculatePositionByIndex:pos];
    [[[_candies objectAtIndex:pos] button] setSquare:CANDY_VISIBLE_SIZE];
    [[[_candies objectAtIndex:pos] button] setPosition:point];
    [self addChild:newCandy.button];

}

- (void)FallFromOutside:(Candy *)candy point:(NSUInteger)to
{
    CandyView* v = [[CandyView alloc] initWithCandy:candy scene:self];
    [self addChild:v.button];

    v.button.position = CGPointMake(22+(to%FIELD_SIZE)*45, 22 + (FIELD_SIZE * 50));
    [v.button setSquare:CANDY_VISIBLE_SIZE];
    CGPoint point = [self _calculatePositionByIndex:to];
    //CGPoint point = [self _calculatePositionByIndex:to];CGPoint point = CGPointMake(22+(NSUInteger)(to%FIELD_SIZE)*45,22 + (FIELD_SIZE - (NSUInteger)(to/FIELD_SIZE) - 1) * 50);
    CCMoveTo* moveCandy = [CCMoveTo actionWithDuration:LINE_DROP_ANIMATION_TIME position:point];

    [v.button runAction:moveCandy];

    _candies[to] = v;

}

- (void)FallFromField:(Candy *)candy point:(NSUInteger)to
{
    CGPoint point = [self _calculatePositionByIndex:to];
    //CGPoint point = CGPointMake(22+(to%FIELD_SIZE)*45,22+(FIELD_SIZE - to/FIELD_SIZE - 1) * 50);
    CCMoveTo* moveCandy = [CCMoveTo actionWithDuration:LINE_DROP_ANIMATION_TIME position:point];
    NSUInteger curpos = [_gameManager getIndexOf:candy];
    CandyView* v = _candies[curpos];

    [v.button runAction:moveCandy];

    _candies[to] = v;
}
-(CGPoint)_calculatePositionByIndex:(NSUInteger)index
{
    return ccp(22+(index%FIELD_SIZE)*45,22+(FIELD_SIZE - index/FIELD_SIZE - 1) * 50);
}
-(CandyView*)getCandyViewForPosition:(NSUInteger)pos
{
    return _candies[pos];
}

@end
