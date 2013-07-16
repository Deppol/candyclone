//
// Created by Victor on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CandyBonusHorizontalLine.h"
#import "SceneGame.h"
#import "GameManager.h"
#import "ConstantsStatic.h"


@implementation CandyBonusHorizontalLine
{

}

- (ECandyBonusType)type
{
    return ECBT_HORIZONTAL_LINE;
}

//designated initializer
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

    NSUInteger index = [gameManager getIndexOf:self.owner];

    index -= index % [ConstantsStatic fieldSize];

    for (NSUInteger i = 0; i < [ConstantsStatic fieldSize]; ++i)
    {
        [gameManager markCandyByIndex:index + i];

    }
}

@end