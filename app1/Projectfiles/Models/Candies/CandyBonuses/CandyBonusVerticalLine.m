//
// Created by Victor on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CandyBonusVerticalLine.h"
#import "SceneGame.h"
#import "GameManager.h"
#import "MyConstants.h"

@implementation CandyBonusVerticalLine
{

}

//designated initializer
- (CandyBonus *)initWithOwner:(Candy *)owner
{
	NSAssert(owner != nil, @"CandyBonus owner nust not be nil");
	_type = ECBT_VERTICAL_LINE;
	return self;
}

//methods

- (void)activateBonus
{
	SceneBase *scene = [SceneBase currentScene];
	NSAssert(scene.type != EST_GAME, @"Attempt to activate bonus in non-game scene");
	GameManager *gameManager = ((SceneGame *) scene).gameManager;
	NSUInteger index = [gameManager getIndexOf:_owner];
	index %= FIELD_SIZE;
	for (NSUInteger i = 0; i < FIELD_SIZE; ++i)
		[gameManager markCandyByIndex:i * FIELD_SIZE + index];
    [super activateBonus];
}

@end