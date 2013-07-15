//
// Created by Vladislav Babkin on 7/15/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "CCButtonDelegate.h"

@class CCButton;


@interface PauseView : NSObject <CCButtonDelegate>

@property (nonatomic, readonly) CCButton* button;

-(PauseView*)init;


-(void)cleanup;

-(void)showPause;


@end