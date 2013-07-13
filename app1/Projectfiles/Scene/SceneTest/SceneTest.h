//
// Created by Vladislav Babkin on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class SceneBase;

//!Temporary scene. Made only to test Highscores. To be removed.
@interface SceneTest : SceneBase

+ (SceneBase *)createScene;

@property(nonatomic, readonly) ESceneType type;


/*
 * Instance methods
 */

//! Load all resources here
- (void)loadResources;

//! Prepare scene. Init all game objects here
- (void)prepare;

- (void)placeViewsiPhoneWide;
@end