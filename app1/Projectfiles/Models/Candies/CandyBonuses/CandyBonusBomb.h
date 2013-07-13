//
// Created by Victor on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "CandyBonus.h"


@interface CandyBonusBomb : CandyBonus

//properties

@property(readonly) enum ECandyBonusType type;

@property(nonatomic, readonly) Candy *owner;

//designated initializer
- (CandyBonus *)initWithOwner:(Candy *)owner;

//methods

- (void)activateBonus;

@end