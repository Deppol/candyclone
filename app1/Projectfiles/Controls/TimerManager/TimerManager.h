//
// Created by Depool on 7/15/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class GameManager;


@interface TimerManager : NSObject

@property (nonatomic, readonly) NSTimer* timer;
@property (nonatomic, readonly) GameManager* gameManager;
@property (nonatomic, readwrite) BOOL isTimerOn;

- (TimerManager *)initWithTimerAndManager:(GameManager *) gameManager;

- (void)cleanup;


@end