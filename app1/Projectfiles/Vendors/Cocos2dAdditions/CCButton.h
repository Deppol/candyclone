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
@property (nonatomic, readwrite) NSInteger box_y;
@property (nonatomic, readwrite) NSInteger box_x;
@property (nonatomic) ccColor3B color;
@property (nonatomic) ccColor3B colorSelf;
@property (nonatomic) GLubyte opacity;

@property (nonatomic, readwrite) id <CCButtonDelegate> delegate;

@property(nonatomic, strong) id <CCButtonDelegate> _delegate;

//! Designated initializer
- (id)init;

- (id)initWithCCSprite:(CCSprite* ) sprite;

- (void)addCCSprite:(CCSprite*)sprite;

- (void)dealloc;

- (void)cleanup;

- (void)setSquare:(CGFloat)s;

/*
 * CCTouchOneByOneDelegate
 */
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;

@end
