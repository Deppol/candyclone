//
// Created by Victor on 7/13/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CandyBonus.h"
#import "DelegateContainer.h"


@implementation CandyBonus
{
	enum ECandyBonusType _type;
	Candy *_owner;
}

//designated initializer
- (CandyBonus *)initWithOwner:(Candy *)owner
{
	NSAssert(NO, @"CandyBonus is abstract class. Please use subclasses.");
	return nil;
}

//methods

- (void)activateBonus
{
    [DelegateContainer callBonusActivated:_owner];
}

@end