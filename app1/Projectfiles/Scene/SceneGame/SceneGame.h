/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim.
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "cocos2d.h"
#import "SceneBase.h"

@class GameManager;


@interface SceneGame : SceneBase

/*
 * Static
 */

//! Default creator for scene. Need override in derived classes.
+ (SceneBase *)createScene;

/*
 * Properties
 */

@property(nonatomic, readonly) ESceneType type;

@property(nonatomic, readonly) GameManager *gameManager;

/*
 * Instance methods
 */

//! Load all resources here
- (void)loadResources;

//! Prepare scene. Init all game objects here
- (void)prepare;

@end
