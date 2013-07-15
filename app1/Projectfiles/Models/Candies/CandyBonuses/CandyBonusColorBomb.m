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

//designated initializer
- (CandyBonus *)initWithOwner:(Candy *)owner
{
	NSAssert(owner != nil, @"CandyBonus owner nust not be nil");
	_type = ECBT_COLOR_BOMB;
    _owner = owner;
	return self;
}

//methods

- (void)activateBonus
{
    [super activateBonus];

	SceneBase *scene = [SceneBase currentScene];
	NSAssert(scene.type ==  EST_GAME, @"Attempt to activate bonus in non-game scene");
	GameManager *gameManager = ((SceneGame *) scene).gameManager;
	[gameManager markColor:_owner.color];
}

@end