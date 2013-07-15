//
// Created by Depool on 7/15/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TimerManager.h"
#import "GameManager.h"
#import "ConstantsStatic.h"
#import "MyConstants.h"
#import "SharedHighScoreManager.h"
#import "SceneBase.h"


@implementation TimerManager
{
   NSUInteger timeRemained;
}
- (TimerManager *)initWithTimerAndManager:(GameManager *)gameManager
{
    self = [super init];
    if (self)
    {
       _gameManager = gameManager;
       timeRemained = GAME_TIME;
       _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self
                         selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
       _isTimerOn = YES;
    }
    return self;

}

- (void)cleanup
{
    [_timer invalidate];
    _timer = nil;
    _gameManager = nil;
}


- (void)timerFireMethod:(NSTimer *)theTimer
{
   if (_isTimerOn)
   {
    if (timeRemained>0)
    {
        timeRemained--;
        SceneBase* scene  = [SceneBase currentScene];
        if (scene.type == EST_GAME)
        [scene performSelectorOnMainThread:@selector(setTime:) withObject:[NSString stringWithFormat:@"%d:%d", timeRemained / 60, timeRemained % 60, nil]
                            waitUntilDone:YES];
       //delegate redraw label to a game manager
    }
    else
    [_gameManager performSelectorOnMainThread:@selector(finishGame) withObject:nil waitUntilDone:YES];
   }
}


@end