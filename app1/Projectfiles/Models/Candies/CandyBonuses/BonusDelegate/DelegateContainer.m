//
// Created by Vladislav Babkin on 7/14/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DelegateContainer.h"
#import "BonusDelegate.h"
#import "Candy.h"


@implementation DelegateContainer
{

}

static id<BonusDelegate> _delegate = nil;

+(void)subscribe:(id <BonusDelegate>)delegate
{
    _delegate = delegate;
}
+(void)unsubscribe
{
    _delegate = nil;
}
+(void)callBonusActivated:(Candy*)candy
{
    if(_delegate!=nil) [_delegate BonusActivated:candy];
}
@end