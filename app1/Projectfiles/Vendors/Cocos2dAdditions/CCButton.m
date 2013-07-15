//
//  CCButton.m
//  Dices
//
//  Created by gregory.tkach on 17.04.12.
//  Copyright (c) 2012 CowPlay. All rights reserved.
//

#import "CCButton.h"
#import "SimpleAudioEngine.h"
#import "CCButtonDelegate.h"
#import "CCSprite+Resize.h"


@implementation CCButton
{
    CGPoint _startTouchPosition;
    CGPoint _endTouchPosition;

    NSDate *_lastTimeActionTouchEnded;

    NSDate *_previousTouchDate;

    BOOL _enabled;

    CGRect _rect;

}

/*
 * Properties
 */

- (void)setOpacity:(GLubyte)opacity
{
    _opacity = opacity;
    for(NSUInteger i = 0; i< [_children count]; i++)
        ((CCSprite *) [_children objectAtIndex:i]).opacity = _opacity;
}
- (void)setColorSelf:(ccColor3B)colorSelf
{
    _colorSelf = colorSelf;
    self.color = colorSelf;
}
- (void)setColor:(ccColor3B)color
{
    _color = color;
    for(NSUInteger i = 0; i< [_children count]; i++)
        ((CCSprite *) [_children objectAtIndex:i]).color = color;
}
- (void)setEnabled:(BOOL)value
{
    _enabled = value;

    static const ccColor3B ccDARKGRAY = {127, 127, 127};

    self.color = value ? _colorSelf : ccDARKGRAY;
}

/*
 * Methods
 */

//! Designated initializer
- (id)init
{
    self = [super init];

    if(self)
    {
        self.box_x = -7;
        self.box_y = -7;
        [self _prepareButton];
    }
    return self;
}

- (id)initWithCCSprite:(CCSprite* ) sprite
{
    self = [self init];
    if(self)
    {
        _rect = sprite.textureRect;
        _opacity = sprite.opacity;
        _color = sprite.color;
        _colorSelf = sprite.color;
        sprite.position = ccp(0,0);
        [self addChild:sprite];
    }
    return self;
}


- (void)addCCSprite:(CCSprite*)sprite
{
    if([_children containsObject:sprite])
        [self removeChild:sprite];
    [sprite resizeTo:_rect.size ];
    sprite.color = _colorSelf;
    sprite.opacity = _opacity;
    sprite.position = ccp(0,0);
    [self addChild:sprite];
}
-(void)addCCNodeRGBA:(CCNodeRGBA*)sprite
{
    if([_children containsObject:sprite])
        [self removeChild:sprite];
    sprite.color = _colorSelf;
    sprite.opacity = _opacity;
    sprite.position = ccp(0,0);
    [self addChild:sprite];
}


- (void)_prepareButton
{
    _adjustColorWhenClicked = YES;
    _enabled = YES;
    _colorSelf = ccWHITE;
    _swallowsTouches = YES;

    [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:1 swallowsTouches:self.swallowsTouches];
}

- (void)dealloc
{
    [self cleanup];
}

- (void)cleanup
{
    _delegate = nil;

    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];

    _lastTimeActionTouchEnded = nil;
    _previousTouchDate = nil;

    [super cleanup];
}

- (void)setSquare:(CGFloat)s
{
    for(NSUInteger i = 0; i<[_children count]; i++)
    {
        //((CCNode *) [_children objectAtIndex:i]) setContentSize:CGSizeMake(s, s)];
        [((CCSprite*)[_children objectAtIndex:i]) resizeTo:CGSizeMake(s, s)];
    }
}
/*
 * CCTouchOneByOneDelegate
 */

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL result = NO;

    NSTimeInterval intervalFromPreviousTouch = [[NSDate date] timeIntervalSinceDate:_previousTouchDate];

    _previousTouchDate = [NSDate date];

    if ((intervalFromPreviousTouch < INTERVAL_BETWEEN_TOUCH_BEGIN) || !_enabled || (self.opacity == OPACITY_HIDE))
    {
        //do nothing
    }
    else
    {
        CGPoint point = [self convertTouchToNodeSpace:touch];

        // Apply start and end positions to make difference in testTouch function
        _startTouchPosition = point;
        _endTouchPosition = point;

        result = [self _isPointInside:point];

        if (self.adjustColorWhenClicked)
        {
            if (result)
            {
                self.color = ccGRAY;
            }
            else
            {
                self.color = _colorSelf;
            }
        }
        else
        {
            self.color = _colorSelf;
        }

        if (result && _delegate)
        {
            [_delegate didButtonTouchBegan:self touch:touch];
        }
    }

    return result;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint point = [self convertTouchToNodeSpace:touch];

    _endTouchPosition = point; // Apply current end touch position

    if (self.adjustColorWhenClicked)
    {
        if ([self _isPointInside:point])
        {
            self.color = ccGRAY;
        }
        else
        {
            self.color = _colorSelf;
        }
    }

    if (_delegate)
    {
        [_delegate didButtonTouchMoved:self touch:touch];
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.color = _colorSelf;

    _endTouchPosition = [self convertTouchToNodeSpace:touch]; // Apply current end touch position

    BOOL result = [self _isPointInside:_endTouchPosition];

    if (result)
    {
        if (_lastTimeActionTouchEnded == nil || ([[NSDate date] timeIntervalSinceDate:_lastTimeActionTouchEnded] > INTERVAL_BETWEEN_TOUCH_ENDED))
        {
            if (_delegate)
            {
                [_delegate didButtonTouchEnded:self touch:touch];
            }

            if (!self.disallowSound)
            {
                [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
            }
        }
    }

    _lastTimeActionTouchEnded = [NSDate date];
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"touch canceled");
}


- (BOOL)_isPointInside:(CGPoint)point
{
    point.x *= self.scaleX;
    point.y *= self.scaleY;

    BOOL ans = NO;

    for(NSUInteger i = 0; i< [_children count]; i++)
    {

        CGRect r = [((CCNode*)[_children objectAtIndex:i]) boundingBox];

        CGFloat difx = (r.size.width*self.scaleX - r.size.width)/2.0f;
        CGFloat dify = (r.size.height*self.scaleY - r.size.height)/2.0f;

        r.origin.x -= difx;
        r.origin.y -= dify;

        r.size.width += difx;
        r.size.height += dify;

        //r.origin.x = _startTouchPosition.x - _endTouchPosition.x;
        //r.origin.y = _startTouchPosition.y - _endTouchPosition.y;
        ans = ans|CGRectContainsPoint(CGRectInset(r, self.box_x, self.box_y), point);
    }
    return ans;
}

@end
