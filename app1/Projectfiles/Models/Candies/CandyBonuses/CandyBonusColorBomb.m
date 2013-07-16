//
// Created by Victor on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CandyBonusColorBomb.h"
#import "SceneGame.h"
#import "GameManager.h"
#import "Candy.h"


@implementation CandyBonusColorBomb
{

}

/*
 * Properties
 */
- (ECandyBonusType)type
{
    return ECBT_COLOR_BOMB;
}

/*
 * Methods
 */

//designated initializer
- (CandyBonusBase *)initWithOwner:(Candy *)owner
{
    self = [super initWithOwner:owner];

    if (self)
    {

    }

    return self;
}

/*
 * Methods
 */

- (void)activateBonus
{
    [super activateBonus];

    SceneGame *scene = (SceneGame *) [SceneBase currentScene];

    GameManager *gameManager = scene.gameManager;

    [gameManager markColor:self.owner.color];
}

@end