//
// Created by Victor on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "ECandyColor.h"
#import "CandyBonus.h"


@interface Candy : NSObject

//properties

@property(readonly) enum ECandyColor color;
@property(nonatomic, readonly) CandyBonus *bonus;
@property BOOL isMarked;

//Designated initializer
- (Candy *)initWithColorAndBonus:(enum ECandyColor)candyColor Bonus:(enum ECandyBonusType)candyBonusType;

//methods

- (void)markCandy;

- (void)cleanup;

@end