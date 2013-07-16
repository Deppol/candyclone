/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "SceneGame.h"
#import "SimpleAudioEngine.h"
#import "GameManager.h"
#import "ServiceView.h"
#import "CCButton.h"
#import "Candy.h"
#import "CandyView.h"
#import "cpConstraintNode.h"
#import "DelegateContainer.h"
#import "ResourceManager.h"
#import "PauseView.h"
#import "ConstantsStatic.h"
#import "SharedHighScoreManager.h"

@implementation SceneGame
{
    NSMutableArray *scene;
    NSMutableArray *_candies;

    ServiceView *_buttonSound;
    ServiceView *_buttonReturnToMainMenu;
    ServiceView *_buttonPause;
    ServiceView *_buttonRestart;

    CCSprite *_background;
    CCSprite *_backgroundField;
    PauseView *_pauseView;
    CCLabelTTF *_timerLabel;
    CCLabelTTF *_labelScore;

    NSInteger _timeRemained;
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

    _background = [CCSprite spriteWithFile:[ResourceManager getBackground]];
    [self addChild:_background];

    _backgroundField = [CCSprite spriteWithFile:[ResourceManager getBackgroundField]];
    [self addChild:_backgroundField];

    _buttonSound = [ServiceView createViewWithType:EBST_SOUND];
    [self addChild:_buttonSound.button];

    //init return_to_main_menu button

    _buttonReturnToMainMenu = [ServiceView createViewWithType:EBST_RETURN_TO_MAIN_MENU];
    [self addChild:_buttonReturnToMainMenu.button];

    //init pause button

    _buttonPause = [ServiceView createViewWithType:EBST_PAUSE];
    [self addChild:_buttonPause.button];

    //init button restart
    _buttonRestart = [ServiceView createViewWithType:EBST_RESTART];
    [self addChild:_buttonRestart.button];

    _labelScore = [[CCLabelTTF alloc] initWithString:@"0"
                                            fontName:[ConstantsStatic buttonsFontName]
                                            fontSize:45];
    [self addChild:_labelScore];

    _gameManager = [[GameManager alloc] init];

    _candies = [NSMutableArray arrayWithCapacity:[ConstantsStatic fieldSize] * [ConstantsStatic fieldSize]];

    for (NSUInteger i = 0; i < [ConstantsStatic fieldSize]; i++)
    {
        for (NSUInteger j = 0; j < [ConstantsStatic fieldSize]; j++)
        {
            CandyView *v = [[CandyView alloc] initWithCandy:[_gameManager.candies objectAtIndex:i * [ConstantsStatic fieldSize] + j] scene:self];
            [_candies insertObject:v atIndex:i * [ConstantsStatic fieldSize] + j];
            [self addChild:v.button];
        }
    }

    _pauseView = [[PauseView alloc] init];

    [self addChild:_pauseView.button];

    _timerLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d:%d", [ConstantsStatic gameTime] / 60, [ConstantsStatic gameTime] % 60]
                                     fontName:[ConstantsStatic buttonsFontName]
                                     fontSize:25];
    [self addChild:_timerLabel];

    _timeRemained = [ConstantsStatic gameTime];

    [self schedule:@selector(_timerTick) interval:1.0f repeat:kCCRepeatForever delay:1.0f];

    [DelegateContainer subscribe:self];

    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:[ResourceManager getBackgroundMusic] loop:YES];
}

- (void)placeViewsiPhone
{
    //place service button
    _buttonSound.button.position = ccp(30, 450);
    _buttonReturnToMainMenu.button.position = ccp(120, 450);
    _buttonPause.button.position = ccp(90, 450);
    _buttonRestart.button.position = ccp(60, 450);

    //place the score
    _labelScore.anchorPoint = ccp(0, 0);
    _labelScore.position = ccp(160, 420);

    _background.anchorPoint = CGPointMake(0.0f, 0.0f);

    _backgroundField.anchorPoint = CGPointMake(0.5f, 0.5f);
    _backgroundField.position = [self _calculatePositionByIndex:[ConstantsStatic fieldSize] * [ConstantsStatic fieldSize] / 2];
    _backgroundField.scale = 0.5f;

    for (NSUInteger i = 0; i < [ConstantsStatic fieldSize]; i++)
        for (NSUInteger j = 0; j < [ConstantsStatic fieldSize]; j++)
        {
            [[[_candies objectAtIndex:i * [ConstantsStatic fieldSize] + j] button] setSquare:[ConstantsStatic candyVisibleSize]];
            CGPoint point = [self _calculatePositionByIndex:i * [ConstantsStatic fieldSize] + j];
            [[[_candies objectAtIndex:i * [ConstantsStatic fieldSize] + j] button] setPosition:point];
        }
    [_gameManager doInitialUpdate];

    _pauseView.button.position = [[CCDirector sharedDirector] screenCenter];

    _timerLabel.position = ccp([[CCDirector sharedDirector] screenCenter].x, 22);
}

- (void)placeViewsiPhoneWide
{
    {//buttons
        _buttonSound.button.scale = 2.0f;
        _buttonSound.button.position = ccp(30, 538);

        _buttonReturnToMainMenu.button.scale = 2.0f;
        _buttonReturnToMainMenu.button.position = ccp(120, 538);

        _buttonPause.button.scale = 2.0f;
        _buttonPause.button.position = ccp(90, 538);

        _buttonRestart.button.scale = 2.0f;
        _buttonRestart.button.position = ccp(90, 538);
    }

    _background.anchorPoint = CGPointMake(0.0f, 0.0f);
    _background.scale = 2.0f;

    _labelScore.scale = 2.0f;
    _labelScore.anchorPoint = ccp(0, 0);
    _labelScore.position = ccp(160, 508);

    _backgroundField.anchorPoint = CGPointMake(0.5f, 0.5f);
    _backgroundField.position = [self _calculatePositionByIndex:[ConstantsStatic fieldSize] * [ConstantsStatic fieldSize] / 2];
    _backgroundField.scale = 1.0f;


    for (NSUInteger i = 0; i < [ConstantsStatic fieldSize]; i++)
        for (NSUInteger j = 0; j < [ConstantsStatic fieldSize]; j++)
        {
            [[[_candies objectAtIndex:i * [ConstantsStatic fieldSize] + j] button] setSquare:[ConstantsStatic candyVisibleSize]];
            CGPoint point = [self _calculatePositionByIndex:i * [ConstantsStatic fieldSize] + j];
            [[[_candies objectAtIndex:i * [ConstantsStatic fieldSize] + j] button] setPosition:point];
        }
    [_gameManager doInitialUpdate];


    _pauseView.button.position = [[CCDirector sharedDirector] screenCenter];

    _timerLabel.position = ccp([[CCDirector sharedDirector] screenCenter].x, 22);
}

- (void)cleanup
{
    [_buttonSound cleanup];
    _buttonSound = nil;
    [_buttonReturnToMainMenu cleanup];
    _buttonReturnToMainMenu = nil;
    [_buttonPause cleanup];
    _buttonPause = nil;
    [_background cleanup];
    _background = nil;
    [_backgroundField cleanup];
    _backgroundField = nil;
    [_buttonRestart cleanup];
    _buttonRestart = nil;

    [_labelScore cleanup];
    _labelScore = nil;

    [DelegateContainer unsubscribe];
    for (NSUInteger i = 0; i < [ConstantsStatic fieldSize]; i++)
    {
        for (NSUInteger j = 0; j < [ConstantsStatic fieldSize]; j++)
        {
            [_candies[i * [ConstantsStatic fieldSize] + j] cleanup];
            [_candies insertObject:[NSNull null] atIndex:i * [ConstantsStatic fieldSize] + j];
        }
    }

    _candies = nil;
    [_gameManager cleanup];
    _gameManager = nil;
    [_pauseView cleanup];
    _pauseView = nil;
    [_timerLabel cleanup];
    _timerLabel = nil;
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [super cleanup];
}

- (void)select:(CandyView *)v
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

    CandyView *v1 = [_candies objectAtIndex:index1];
    CandyView *v2 = [_candies objectAtIndex:index2];

    CGPoint p1 = v1.button.position;
    CGPoint p2 = v2.button.position;

    CCMoveTo *a1 = [CCMoveTo actionWithDuration:[ConstantsStatic animationTimeSwap] position:p2];
    CCMoveTo *a2 = [CCMoveTo actionWithDuration:[ConstantsStatic animationTimeSwap] position:p1];

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

- (void)AddBonus:(Candy *)candyBonus
{
    NSUInteger pos = [_gameManager getIndexOf:candyBonus];
    CandyView *newCandy = [[CandyView alloc] initWithCandy:candyBonus scene:self];

    [_candies replaceObjectAtIndex:pos withObject:newCandy];
    CGPoint point = [self _calculatePositionByIndex:pos];
    [[[_candies objectAtIndex:pos] button] setSquare:[ConstantsStatic candyVisibleSize]];
    [[[_candies objectAtIndex:pos] button] setPosition:point];
    [self addChild:newCandy.button];

}

- (void)FallFromOutside:(Candy *)candy point:(NSUInteger)to
{
    CandyView *v = [[CandyView alloc] initWithCandy:candy scene:self];
    [self addChild:v.button];
    v.button.position = [self _calculatePositionOnTopOfTheField:to];
    [v.button setSquare:[ConstantsStatic candyVisibleSize]];
    CGPoint point = [self _calculatePositionByIndex:to];

    CCMoveTo *moveCandy = [CCMoveTo actionWithDuration:[ConstantsStatic animatiopnTimeLineDrop] position:point];

    [v.button runAction:moveCandy];

    _candies[to] = v;

}

- (void)FallFromField:(Candy *)candy point:(NSUInteger)to
{
    CGPoint point = [self _calculatePositionByIndex:to];

    CCMoveTo *moveCandy = [CCMoveTo actionWithDuration:[ConstantsStatic animatiopnTimeLineDrop] position:point];
    NSUInteger curpos = [_gameManager getIndexOf:candy];
    CandyView *v = _candies[curpos];

    [v.button runAction:moveCandy];

    _candies[to] = v;
}

- (CGPoint)_calculatePositionByIndex:(NSUInteger)index
{
    return ccp((index % [ConstantsStatic fieldSize] + 0.5) * 320.0 / [ConstantsStatic fieldSize], 65 + ([ConstantsStatic fieldSize] - index / [ConstantsStatic fieldSize] - 1) * 50);

}

- (CGPoint)_calculatePositionOnTopOfTheField:(NSUInteger)index
{
    return ccp((index % [ConstantsStatic fieldSize] + 0.5) * 320.0 / [ConstantsStatic fieldSize], 65 + [ConstantsStatic fieldSize] * 50);
}

- (CandyView *)getCandyViewForPosition:(NSUInteger)pos
{
    return _candies[pos];
}

- (void)setTime:(NSString *)time
{
    [_timerLabel setString:time];
}

- (void)showPause
{
    if (!_gameManager.animationIsRunning)
    {
        [self reorderChild:_pauseView.button z:0];
        [self unschedule:@selector(_timerTick)];
        [_pauseView showPause];
    }
}

- (void)unshowPause
{
    if (!_gameManager.animationIsRunning)
    {
        [self schedule:@selector(_timerTick) interval:1.0f repeat:kCCRepeatForever delay:1.0f];
    }
}

- (void)_timerTick
{
    if (_timeRemained > 0)
    {
        _timeRemained--;
        [_labelScore setString:[NSString stringWithFormat:@"%d", [_gameManager getScore]]];
        [self setTime:[NSString stringWithFormat:@"%d:%d", _timeRemained / 60, _timeRemained % 60]];
    }
    else
    {
        [_gameManager finishGame];
        [self unschedule:@selector(_timerTick)];
    }
}

@end
