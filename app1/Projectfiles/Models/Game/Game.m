//
// Created by Gregory Tkach on 4/19/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Game.h"
#import "SceneGame.h"


@implementation Game
{

}
//! Designated initializer
- (id)init
{

    self = [super init];

    if (self)
    {
        [self _prepare];
    }

    return self;
}

- (void)_prepare
{

    //[self _createFoundationBase];

    //[self _createCards];

}

//! Setup game scene which control this game
- (void)setupScene:(SceneGame *)gameScene
{
    NSAssert(!_gameScene, @"Game::setupScene. Game scene already setup.");
    NSAssert(gameScene, @"Game::setupScene. gameScene should be non nil.");

    _gameScene = gameScene;


//    [self _addCardBoxesToScene];
//    [self _addCardsToScene];
//
//    [self _moveCardsToContainers];

}


@end