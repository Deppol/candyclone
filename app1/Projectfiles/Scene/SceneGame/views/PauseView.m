//
// Created by Vladislav Babkin on 7/15/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PauseView.h"
#import "CCButton.h"
#import "ConstantsStatic.h"
#import "CCSprite+Resize.h"


@implementation PauseView
{

}
- (void)didButtonTouchBegan:(CCButton *)button touch:(UITouch *)touch
{

}

- (void)didButtonTouchMoved:(CCButton *)button touch:(UITouch *)touch
{

}

- (void)didButtonTouchEnded:(CCButton *)button touch:(UITouch *)touch
{
    self.button.opacity = 0;
    self.button.enabled = NO;
}

- (void)didButtonTouchCanceled:(CCButton *)button touch:(UITouch *)touch
{

}

- (PauseView *)init
{

    self = [super init];
    if(self)
    {
        CCLabelTTF * text = [CCLabelTTF labelWithString:@"Game Paused"
                                               fontName:[ConstantsStatic buttonsFontName]
                                               fontSize:25];

        CCSprite* sprite = [CCSprite node];
        [sprite setTextureRect:CGRectMake(0, 0, 700, 700)];
        [sprite setColor:ccGRAY];
        [sprite setOpacity:128];

        _button = [[CCButton alloc] initWithCCSprite:text];


        [_button addCCSprite:sprite];

        [sprite resizeTo:CGSizeMake(700,700)];
        _button.adjustColorWhenClicked = NO;
        _button.color = ccWHITE;
        _button.colorSelf = ccWHITE;




        text.color = ccYELLOW;
        text.position = [CCDirector sharedDirector].screenCenter;

        [_button addCCSprite:text];

        _button.enabled = NO;

        _button.opacity = 0;

        _button.delegate = self;
    }
    return self;

}

- (void)cleanup
{
    [_button cleanup];
    _button = nil;
}

- (void)showPause
{

   self.button.opacity = 255;
   self.button.enabled = YES;
}


@end