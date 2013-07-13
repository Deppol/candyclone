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


@implementation CCButton
{
    CGPoint _startTouchPosition;
    CGPoint _endTouchPosition;

    NSDate *_lastTimeActionTouchEnded;

    NSDate *_previousTouchDate;

    BOOL _enabled;

}

/*
 * Properties
 */

- (void)setEnabled:(BOOL)value
{
    _enabled = value;

    static const ccColor3B ccDARKGRAY = {127, 127, 127};

    self.color = value ? ccWHITE : ccDARKGRAY;
}

/*
 * Methods
 */

//! Designated initializer
- (id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated
{
    self = [super initWithTexture:texture rect:rect rotated:rotated];

    if (self)
    {
        [self _prepareButton];
    }

    return self;
}

- (void)_prepareButton
{
    _adjustColorWhenClicked = YES;
    _enabled = YES;
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
                self.color = ccWHITE;
            }
        }
        else
        {
            self.color = ccWHITE;
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
            self.color = ccWHITE;
        }
    }

    if (_delegate)
    {
        [_delegate didButtonTouchMoved:self touch:touch];
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.color = ccWHITE;

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

    CGRect r = [self boundingBox];

    r.origin.x = _startTouchPosition.x - _endTouchPosition.x;
    r.origin.y = _startTouchPosition.y - _endTouchPosition.y;

    return CGRectContainsPoint(CGRectInset(r, -10, -10), point);
}

@end
