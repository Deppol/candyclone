//
// Created by Victor on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Candy.h"
#import "CandyBonusNothing.h"
#import "CandyBonusVerticalLine.h"
#import "CandyBonusHorizontalLine.h"
#import "CandyBonusBomb.h"
#import "CandyBonusColorBomb.h"


@implementation Candy
{

}

//Designated initializer
- (Candy *)initWithColorAndBonus:(enum ECandyColor)candyColor Bonus:(enum ECandyBonusType)candyBonusType
{
	NSAssert(candyColor != ECC_COUNT, @"Attempt to initialize Candy with illegal color (ECC_COUNT)");
	_color = candyColor;
    _type = candyBonusType;
	switch (candyBonusType)
	{
		case ECBT_NOTHING:
			_bonus = [[CandyBonusNothing alloc] init];
	        break;
		case ECBT_VERTICAL_LINE:
			_bonus = [[CandyBonusVerticalLine alloc] init];
	        break;
		case ECBT_HORIZONTAL_LINE:
			_bonus = [[CandyBonusHorizontalLine alloc] init];
	        break;
		case ECBT_BOMB:
			_bonus = [[CandyBonusBomb alloc] init];
	        break;
		case ECBT_COLOR_BOMB:
			_bonus = [[CandyBonusColorBomb alloc] init];
	        break;
		default:
			NSAssert(NO, @"Attempt to initialize Candy with illegal bonus");
	}
	_isMarked = NO;
	return self;
}

//methods

- (void)markCandy
{
	if (!_isMarked)
	{
		_isMarked = YES;
		[_bonus activateBonus];
	}
}

- (void)cleanup
{
	_bonus = nil;
}

@end