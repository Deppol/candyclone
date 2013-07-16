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

static id <BonusDelegate> _delegate = nil;

+ (void)subscribe:(id <BonusDelegate>)delegate
{
    _delegate = delegate;
}

+ (void)unsubscribe
{
    _delegate = nil;
}

+ (void)__callBonusActivated:(Candy *)candy
{
    [_delegate BonusActivated:candy];
};


+ (void)callBonusActivated:(Candy *)candy
{
    if (_delegate != nil)
    {
        [self performSelectorOnMainThread:@selector(__callBonusActivated:) withObject:candy waitUntilDone:YES];
    }
}

+ (void)callSwap:(Candy *)candy1 candy2:(Candy *)candy2
{
    if (_delegate != nil) [_delegate Swap:candy1 candy2:candy2];
}

+ (void)callSetSelection:(Candy *)candy
{
    if (_delegate != nil) [_delegate SetSelection:candy];
}

+ (void)callUnsetSelection:(Candy *)candy
{
    if (_delegate != nil) [_delegate UnsetSelection:candy];
}

+ (void)callAddBonus:(Candy *)candyBonus
{
    if (_delegate != nil)
    {
        [self performSelectorOnMainThread:@selector(_callAddBonus:) withObject:candyBonus waitUntilDone:YES];
    }
}

+ (void)_callAddBonus:(Candy *)candy
{
    [_delegate AddBonus:candy];
}

+ (void)callFallFromOutside:(Candy *)candy point:(NSUInteger)to
{
    if (_delegate != nil)
        [_delegate FallFromOutside:candy point:to];
}

+ (void)callFallFromField:(Candy *)candy point:(NSUInteger)to
{
    if (_delegate != nil)
        [_delegate FallFromField:candy point:to];
}
@end