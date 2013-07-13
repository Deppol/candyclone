//
// Created by Vladislav Babkin on 7/14/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SoundDelegate.h"
#import "CCButton.h"
#import "ResourceManager.h"
#import "SimpleAudioEngine.h"


@implementation SoundDelegate
{
    BOOL _state;
}
-(id)init
{
    self = [super init];
    if(self)
    {
        _state = YES;
    }
    return self;

}

- (void)didButtonTouchBegan:(CCButton *)button touch:(UITouch *)touch
{

}

- (void)didButtonTouchMoved:(CCButton *)button touch:(UITouch *)touch
{

}

- (void)didButtonTouchEnded:(CCButton *)button touch:(UITouch *)touch
{
    [button removeAllChildren];
    if(_state)
    {
        _state = NO;
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.0f];
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.0f];
        [button addCCSprite:[CCSprite spriteWithFile:[ResourceManager getSoundOff]]];
    }
    else
    {
        _state = YES;
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:1.0f];
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1.0f];
        [button addCCSprite:[CCSprite spriteWithFile:[ResourceManager getSoundOn]]];
    }
}

- (void)didButtonTouchCanceled:(CCButton *)button touch:(UITouch *)touch
{

}

+(CCButton *)generateSoundButton
{
    CCButton* ret = [[CCButton alloc] initWithCCSprite:[CCSprite spriteWithFile:[ResourceManager getSoundOn]]];
    SoundDelegate * d = [[SoundDelegate alloc]init];
    [ret setDelegate:d];
    return ret;
}
@end