//
// Created by Gregory Tkach on 4/23/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SharedProgressManager.h"
#import "Game.h"


@implementation SharedProgressManager
{

}

static SharedProgressManager *_instance = nil;

+ (SharedProgressManager *)shared
{
    @synchronized (self)
    {
        if (!_instance)
        {
            _instance = [[SharedProgressManager alloc] init];
        }
    }

    return _instance;
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

}


//! Must call when some game starts
- (void)didGameStart:(Game *)game
{
    NSAssert(!_game, @"SharedProgressManager::didGameStart. Some game already started.");
    NSAssert(game, @"SharedProgressManager::didGameStart. Game should be non nil.");

    _game = game;
}

//! Must call when current game end
- (void)didGameEnd
{
    NSAssert(_game, @"SharedProgressManager::didGameStart. Currently game is nil.");

}

@end