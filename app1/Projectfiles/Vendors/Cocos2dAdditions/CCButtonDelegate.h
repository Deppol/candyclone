//
// Created by Gregory Tkach on 4/23/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class CCButton;

@protocol CCButtonDelegate <NSObject>

@required

//! Fires when specify button touch began
- (void)didButtonTouchBegan:(CCButton *)button touch:(UITouch *)touch;

//! Fires when specify button touch moved
- (void)didButtonTouchMoved:(CCButton *)button touch:(UITouch *)touch;

//! Fires when specify button touch ended
- (void)didButtonTouchEnded:(CCButton *)button touch:(UITouch *)touch;

//! Fires when specify button touch canceled
- (void)didButtonTouchCanceled:(CCButton *)button touch:(UITouch *)touch;


@end