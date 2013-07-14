//
// Created by Victor on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "ECandyBonusType.h"


@class Candy;

@interface CandyBonus : NSObject
{
	@protected enum ECandyBonusType _type;
	@protected Candy *_owner;
}
//properties

@property(readonly) enum ECandyBonusType type;

@property(nonatomic, readonly) Candy *owner;

//designated initializer
- (CandyBonus *)initWithOwner:(Candy *)owner;

//methods

- (void)activateBonus;

@end