//
// Created by Victor on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CandyBonusNothing.h"


@implementation CandyBonusNothing
{

}

//designated initializer
- (CandyBonus *)initWithOwner:(Candy *)owner
{
	NSAssert(owner != nil, @"CandyBonus owner nust not be nil");
	_type = ECBT_NOTHING;
    _owner = owner;
	return self;
}

//methods

- (void)activateBonus
{
    [super activateBonus];
}

@end