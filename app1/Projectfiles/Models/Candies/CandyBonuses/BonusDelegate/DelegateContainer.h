//
// Created by Vladislav Babkin on 7/14/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol BonusDelegate;
@class Candy;


@interface DelegateContainer : NSObject

+(void)subscribe:(id <BonusDelegate>)delegate;
+(void)unsubscribe;
+(void)callBonusActivated:(Candy*)candy;

@end