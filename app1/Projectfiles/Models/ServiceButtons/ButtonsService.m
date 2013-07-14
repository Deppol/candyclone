//
// Created by Depool on 7/14/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ButtonsService.h"
#import "CCButtonDelegate.h"
#import "SceneBase.h"


@interface ButtonsService ()
- (id)init;
@end

@implementation ButtonsService
{

    NSDate *_previousTouchDate;

    CGPoint _startTouchPosition,_endTouchPosition;

}
- (id)init
{
    self = [super init];
    if (self)
    {
      self.enabled = YES;
      self.adjustColorWhenClicked = YES;
    }
    return self;
}

- (void)dealloc
{
   [self cleanup];
}

- (void)cleanup
{
   [super cleanup];
}

- (BOOL)_isPointInside:(CGPoint)point
{
    point.x *= self.scaleX;
    point.y *= self.scaleY;

    BOOL ans = NO;

    for(NSUInteger i = 0; i< [_children count]; i++)
    {

        CGRect r = [((CCNode*)[_children objectAtIndex:i]) boundingBox];

        //r.origin.x = _startTouchPosition.x - _endTouchPosition.x;
        //r.origin.y = _startTouchPosition.y - _endTouchPosition.y;

        ans = ans|CGRectContainsPoint(CGRectInset(r, -10, -10), point);
    }
    return ans;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL result = NO;

    NSTimeInterval intervalFromPreviousTouch = [[NSDate date] timeIntervalSinceDate:_previousTouchDate];

    _previousTouchDate = [NSDate date];

    if ((intervalFromPreviousTouch < INTERVAL_BETWEEN_TOUCH_BEGIN) || !self.enabled || (self.opacity == OPACITY_HIDE))
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
                self.color = ccCYAN;
                [self _runCaseOfTypes];
            }
            else
            {
              //  self.color = ccWHITE;
            }
        }
        else
        {
            self.color = ccWHITE;
        }
    }

    return result;
}

- (void)_runCaseOfTypes
{
   switch (_serviceType)
   {
       case EBST_NEWGAME:
       {
           [SceneBase setScene:EST_GAME];
           break;
       }
       case EBST_SOUND:
       {

           break;
       }
       case EBST_PAUSE:
       {
           break;
       }
       case EBST_RESTART:
       {

       }
       case EBST_RETURN_TO_MAIN_MENU:
       {

       }
       default:
       {
           NSAssert(NO,@"Illegal service button type");
           break;
       }
   }
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
  //to implement
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
  //to implement
}


@end