//
// Created by Depool on 7/14/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "CCButton.h"
#import "EButtonServiceType.h"

@protocol CCButtonDelegate;

@interface ButtonsService : CCButton <CCTouchOneByOneDelegate>

/*
    properties
 */
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL adjustColorWhenClicked;
@property (nonatomic, readwrite) EButtonServiceType serviceType;

/*
    instance methods
 */
-(void)dealloc;
-(void)cleanup;

/*
  CCTouchOneByOneDelegate
 */

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;



@end