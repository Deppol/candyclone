//
// Created by Depool on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SceneBase.h"


@interface SceneStart : SceneBase

/*
    static
 */


//! Default creator for scene. Need override in derived classes.
+(SceneStart *)createScene;

/*
properties
 */

@property (nonatomic, readonly) ESceneType type;

/*
instance methods
 */

//load all resources here
-(void)loadResources;

//prepare scene. Init all game objects here
-(void)prepare;



@end