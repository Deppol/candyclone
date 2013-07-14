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
	enum ECandyBonusType _type;
	Candy *_owner;
}

//designated initializer
- (CandyBonus *)initWithOwner:(Candy *)owner
{
	NSAssert(owner != nil, @"CandyBonus owner nust not be nil");
	_type = ECBT_NOTHING;
	return self;
}

//methods

- (void)activateBonus
{
	SceneBase *scene = [SceneBase currentScene];
	NSAssert(scene.type != EST_GAME, @"Attempt to activate bonus in non-game scene");
	GameManager *gameManager = ((SceneGame *) scene).gameManager;
	[gameManager markColor:_owner.color];
    [super activateBonus];
}

@end