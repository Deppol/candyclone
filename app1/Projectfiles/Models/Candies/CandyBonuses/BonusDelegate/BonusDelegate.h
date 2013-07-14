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

@end