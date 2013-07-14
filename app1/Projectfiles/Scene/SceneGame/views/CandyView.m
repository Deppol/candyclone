//
// Created by Vladislav Babkin on 7/14/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CandyView.h"
#import "Candy.h"
#import "CCButton.h"
#import "ResourceManager.h"


@implementation CandyView
{
    BOOL _buttonActivated;
}
- (CandyView*)initWithCandy:(Candy *)candy
{
    self = [super init];
    if(self)
    {
        _buttonActivated = NO;
        _representsCandy = candy;

        NSMutableArray* images = [ResourceManager getCandyImage:candy.color type:candy.bonus.type];
        _button = [[CCButton alloc] initWithCCSprite:[CCSprite spriteWithFile:[images objectAtIndex:0]]];
        for(NSUInteger i = 1; i<[images count]; i++)
        {
            [_button addCCSprite:[images objectAtIndex:i]];
        }

    }
    return self;

}

- (void)activateBonus
{
    switch (_representsCandy.bonus.type)
    {
        case ECBT_NOTHING:
        {
            CCScaleTo * a1 = [CCScaleTo actionWithDuration:0.3f scale:0.05];
            [_button runAction:a1];
            break;
        }
        default:
        {
            NSLog(@"TODO: animations for bonuses");
        }
    }
}

- (void)cleanup
{
    _button = nil;
    _representsCandy = nil;
}

/*
 * ButtonDelegate
 */

- (void)didButtonTouchBegan:(CCButton *)button touch:(UITouch *)touch
{

}

- (void)didButtonTouchMoved:(CCButton *)button touch:(UITouch *)touch
{

}

- (void)didButtonTouchEnded:(CCButton *)button touch:(UITouch *)touch
{

}

- (void)didButtonTouchCanceled:(CCButton *)button touch:(UITouch *)touch
{

}

@end