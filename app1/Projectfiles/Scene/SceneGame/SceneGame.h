/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim.
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "cocos2d.h"
#import "SceneBase.h"
#import "BonusDelegate.h"

@class GameManager;
@class CandyView;


@interface SceneGame : SceneBase <BonusDelegate>


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

-(void)placeViewsiPhone;
-(void)placeViewsiPhoneWide;

-(void)cleanup;

-(void)select:(CandyView*) v;

-(void)BonusActivated:(Candy*) candy;

-(void)setTime:(NSString*)time;

-(CandyView*)getCandyViewForPosition:(NSUInteger)pos;

-(void)showPause;

-(void)unshowPause;

@end
