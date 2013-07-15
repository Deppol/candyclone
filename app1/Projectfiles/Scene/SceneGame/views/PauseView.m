//
// Created by Vladislav Babkin on 7/15/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PauseView.h"
#import "CCButton.h"
#import "ConstantsStatic.h"


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

        _button = [[CCButton alloc] initWithCCSprite:text];
        _button.adjustColorWhenClicked = NO;

        text.color = ccYELLOW;
        text.position = [CCDirector sharedDirector].screenCenter;

        CCNodeRGBA * _back = [[CCNodeRGBA alloc] init];
        _back.color = ccGRAY;
        [_back setContentSize:CGSizeMake(700, 700)];

        [_button addCCNodeRGBA:_back];

        [_button addCCSprite:text];
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

   self.button.opacity = 0;
}


@end