//
// Created by Gregory Tkach on 4/19/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class SceneGame;
//@class Card;

@interface Game : NSObject

//! Returns game scene which control this game
@property (nonatomic, readonly) SceneGame *gameScene;


//! Designated initializer
- (id)init;

//! Setup game scene which control this game
- (void)setupScene:(SceneGame *)gameScene;

@end