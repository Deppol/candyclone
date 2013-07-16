//
// Created by Victor on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "ECandyBonusType.h"


@class Candy;

@interface CandyBonusBase : NSObject

/*
 * Properties
 */

@property(nonatomic, readonly) ECandyBonusType type;

@property(nonatomic, readonly) Candy *owner;

//designated initializer
- (CandyBonusBase *)initWithOwner:(Candy *)owner;

//methods

- (void)activateBonus;

@end