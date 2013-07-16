//
// Created by Victor on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CandyBonusNothing.h"


@implementation CandyBonusNothing
{

}

- (ECandyBonusType)type
{
    return ECBT_NOTHING;
}

//designated initializer
- (id)initWithOwner:(Candy *)owner
{
    self = [super initWithOwner:owner];

    if (self)
    {

    }

    return self;
}

@end