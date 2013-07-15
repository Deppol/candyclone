//
// Created by Vladislav Babkin on 7/14/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class Candy;

@protocol BonusDelegate <NSObject>
@required

-(void)BonusActivated:(Candy*)candy;
-(void)Swap:(Candy*)candy1 candy2:(Candy*)candy2;
-(void)SetSelection:(Candy*)candy;
-(void)UnsetSelection:(Candy*)candy;
-(void)AddBonus:(Candy*)candyBonus;
-(void)FallFromOutside:(Candy*)candy point:(NSUInteger)to;
-(void)FallFromField:(Candy*)candy point:(NSUInteger)to;

@end