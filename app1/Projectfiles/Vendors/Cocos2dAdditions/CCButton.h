//
//  CCButton.h
//  Dices
//
//  Created by gregory.tkach on 17.04.12.
//  Copyright (c) 2012 CowPlay. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"

@protocol CCButtonDelegate;

static CGFloat const INTERVAL_BETWEEN_TOUCH_BEGIN = 0.3f;
static CGFloat const INTERVAL_BETWEEN_TOUCH_MOVED = 0.3f;
static CGFloat const INTERVAL_BETWEEN_TOUCH_ENDED = 0.3f;
static CGFloat const OPACITY_HIDE = 0.0f;

@interface CCButton : CCNode <CCTouchOneByOneDelegate>

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL adjustColorWhenClicked;
@property (nonatomic, assign) BOOL swallowsTouches;
@property (nonatomic, assign) BOOL disallowSound;
@property (nonatomic) ccColor3B color;
@property (nonatomic) GLubyte opacity;

@property (nonatomic, assign) id <CCButtonDelegate> delegate;

//! Designated initializer
- (id)init;

- (id)initWithCCSprite:(CCSprite* ) sprite;

- (void)addCCSprite:(CCSprite*)sprite;

- (void)dealloc;

- (void)cleanup;

/*
 * CCTouchOneByOneDelegate
 */
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;

@end
