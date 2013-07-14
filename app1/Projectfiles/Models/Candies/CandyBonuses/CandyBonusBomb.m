//
// Created by Victor on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CandyBonusBomb.h"
#import "SceneBase.h"
#import "GameManager.h"
#import "SceneGame.h"
#import "MyConstants.h"


@implementation CandyBonusBomb
{
	enum ECandyBonusType _type;
	Candy *_owner;
}

//designated initializer
- (CandyBonus *)initWithOwner:(Candy *)owner
{
	NSAssert(owner != nil, @"CandyBonus owner nust not be nil");
	_type = ECBT_BOMB;
	return self;
}

//methods

- (void)activateBonus
{
	SceneBase *scene = [SceneBase currentScene];
	NSAssert(scene.type != EST_GAME, @"Attempt to activate bonus in non-game scene");
	GameManager *gameManager = ((SceneGame *) scene).gameManager;
	NSUInteger index = [gameManager getIndexOf:_owner];
	NSInteger row = index / FIELD_SIZE;
	NSInteger column = index % FIELD_SIZE;
	for (NSInteger i = row - 1; i <= row + 1; ++i)
		for (NSInteger j = column - 1; j <= column + 1; ++j)
			if (i >= 0 && i < (NSInteger) FIELD_SIZE && j >= 0 && j < (NSInteger) FIELD_SIZE)
				[gameManager markCandyByIndex:(NSUInteger)i * FIELD_SIZE + j];
}

@end