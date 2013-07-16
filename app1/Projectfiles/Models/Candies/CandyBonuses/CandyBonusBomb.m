//
// Created by Victor on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CandyBonusBomb.h"
#import "SceneBase.h"
#import "GameManager.h"
#import "SceneGame.h"

#import "ConstantsStatic.h"


@implementation CandyBonusBomb
{

}

- (ECandyBonusType)type
{
    return ECBT_BOMB;
}

//! Designated initializer
- (CandyBonusBase *)initWithOwner:(Candy *)owner
{
    self = [super initWithOwner:owner];

    if (self)
    {

    }

    return self;
}

//methods

- (void)activateBonus
{
    [super activateBonus];

    SceneGame *scene = (SceneGame *) [SceneBase currentScene];

    GameManager *gameManager = scene.gameManager;

    NSUInteger index = [gameManager.candies indexOfObject:self.owner];

    NSInteger row = index / [ConstantsStatic fieldSize];
    NSInteger column = index % [ConstantsStatic fieldSize];

    for (NSInteger i = row - 1; i <= row + 1; ++i)
    {
        for (NSInteger j = column - 1; j <= column + 1; ++j)
        {
            if (i >= 0 && i < (NSInteger) [ConstantsStatic fieldSize] && j >= 0 && j < (NSInteger) [ConstantsStatic fieldSize])
            {
                [gameManager markCandyByIndex:(NSUInteger) i * [ConstantsStatic fieldSize] + j];
            }
        }
    }
}

@end