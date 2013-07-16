//
// Created by Vladislav Babkin on 7/14/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol BonusDelegate;
@class Candy;


@interface DelegateContainer : NSObject

+ (void)subscribe:(id <BonusDelegate>)delegate;

+ (void)unsubscribe;

+ (void)callBonusActivated:(Candy *)candy;

+ (void)callSwap:(Candy *)candy1 candy2:(Candy *)candy2;

+ (void)callSetSelection:(Candy *)candy;

+ (void)callUnsetSelection:(Candy *)candy;

+ (void)callAddBonus:(Candy *)candyBonus;

+ (void)callFallFromOutside:(Candy *)candy point:(NSUInteger)to;

+ (void)callFallFromField:(Candy *)candy point:(NSUInteger)to;
@end