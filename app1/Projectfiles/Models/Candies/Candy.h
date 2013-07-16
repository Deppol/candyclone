//
// Created by Victor on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "ECandyColor.h"
#import "CandyBonusBase.h"


@interface Candy : NSObject

//properties

@property(nonatomic, readonly) ECandyColor color;
@property(nonatomic, readonly) CandyBonusBase *bonus;
@property BOOL isMarked;

//Designated initializer
- (Candy *)initWithColorAndBonus:(ECandyColor)candyColor Bonus:(ECandyBonusType)candyBonusType;

//methods

- (void)markCandy;

- (void)cleanup;

@end