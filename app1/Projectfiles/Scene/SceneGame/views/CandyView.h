//
// Created by Vladislav Babkin on 7/14/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "CCButtonDelegate.h"

@class Candy;
@class CCButton;


@interface CandyView : NSObject <CCButtonDelegate>

@property (nonatomic, readonly) Candy* representsCandy;
@property (nonatomic, readonly) CCButton* button;

//designated initializer
-(CandyView *)initWithCandy:(Candy*) candy;

-(void)activateBonus;

-(void)cleanup;

@end