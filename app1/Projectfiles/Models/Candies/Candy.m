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

//Designated initializer
- (Candy *)initWithColorAndBonus:(ECandyColor)candyColor Bonus:(ECandyBonusType)candyBonusType
{
    NSAssert(candyColor != ECC_COUNT, @"Attempt to initialize Candy with illegal color (ECC_COUNT)");

    _color = candyColor;

    Class bonusClass = nil;

    switch (candyBonusType)
    {
        case ECBT_NOTHING:
            bonusClass = [CandyBonusNothing class];
            break;
        case ECBT_VERTICAL_LINE:
            bonusClass = [CandyBonusVerticalLine class];
            break;
        case ECBT_HORIZONTAL_LINE:
            bonusClass = [CandyBonusHorizontalLine class];
            break;
        case ECBT_BOMB:
            bonusClass = [CandyBonusBomb class];
            break;
        case ECBT_COLOR_BOMB:
            bonusClass = [CandyBonusColorBomb class];
            break;
        default:
            NSAssert(NO, @"Attempt to initialize Candy with illegal bonus");
            break;
    }

    _bonus = [[bonusClass alloc] initWithOwner:self];

    _isMarked = NO;
    return self;
}

//methods

- (void)markCandy
{
    if (_isMarked)
        return;

    _isMarked = YES;
    [_bonus activateBonus];
}

- (void)cleanup
{
    _bonus = nil;
}

@end