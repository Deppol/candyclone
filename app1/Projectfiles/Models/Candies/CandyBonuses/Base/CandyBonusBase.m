//
// Created by Victor on 7/13/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CandyBonusBase.h"
#import "DelegateContainer.h"


@implementation CandyBonusBase

/*
 * Properties
 */
- (ECandyBonusType)type
{
    NSAssert(NO, @"CandyBonusBase::type. Implement this method in derived classes.");

    return ECBT_COUNT;
}

/*
 * Methods
 */

//! Designated initializer
- (CandyBonusBase *)initWithOwner:(Candy *)owner
{
    NSAssert(owner != nil, @"CandyBonusBase owner nust not be nil");

    self = [super init];

    if(self)
    {
        _owner = owner;
    }

	return self;
}

//methods

- (void)activateBonus
{
    [DelegateContainer callBonusActivated:_owner];
}

@end