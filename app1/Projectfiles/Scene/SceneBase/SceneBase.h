//
// Created by Gregory Tkach on 4/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "ESceneType.h"


@interface SceneBase : CCLayer

/*
 * Static functions
 */

//! Returns current scene
+ (SceneBase *)currentScene;

//! Set current scene
+ (void)setScene:(ESceneType)type;

//! Default creator for scene. Need override in derived classes.
+ (SceneBase *)createScene;

/*
 * Properties
 */

@property(nonatomic, readonly) ESceneType type;

/*
 * Instance methods
 */

//! Load all resources here
- (void)loadResources;

//! Prepare scene. Init all game objects here
- (void)prepare;

- (void)placeViewsiPhone;

- (void)placeViewsiPhoneWide;

- (void)placeViewsiPad;
@end