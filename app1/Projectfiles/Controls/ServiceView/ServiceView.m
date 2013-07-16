//
// Created by Vladislav Babkin on 7/14/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ServiceView.h"
#import "CCButton.h"
#import "ResourceManager.h"
#import "SimpleAudioEngine.h"
#import "SceneBase.h"
#import "EButtonServiceType.h"
#import "ConstantsStatic.h"


@implementation ServiceView
{
    BOOL _stateSound;
    EButtonServiceType _serviceType;
}

-(id)initWithType:(EButtonServiceType)type
{
    self = [super init];
    if(self)
    {

        _serviceType = type;
        switch (_serviceType)
        {
            case EBST_NEWGAME:
            {
                CCLabelTTF * newGameTempLabel = [CCLabelTTF labelWithString:[ConstantsStatic newGameConst]
                                                                   fontName:[ConstantsStatic buttonsFontName]
                                                                   fontSize:30];
                [newGameTempLabel setColor:ccYELLOW];
                _button = [[CCButton alloc] initWithCCSprite:newGameTempLabel];
                _button.colorSelf = ccYELLOW;

                break;
            }
            case EBST_SOUND:
            {
                _button = [[CCButton alloc] initWithCCSprite:[CCSprite spriteWithFile:[ResourceManager buttonSoundOn]]];
                _stateSound = YES;
                break;
            }
            case EBST_PAUSE:
            {
                _button = [[CCButton alloc] initWithCCSprite:[CCSprite spriteWithFile:[ResourceManager buttonPause]]];
                break;
            }
            case EBST_RESTART:
            {
                _button = [[CCButton alloc] initWithCCSprite:[CCSprite spriteWithFile:[ResourceManager getRestart]]];
                break;
            }
            case EBST_RETURN_TO_MAIN_MENU:
            {
                CCSprite* toMainMenu = [[CCSprite alloc] initWithFile:@"exit.png"];
                _button = [[CCButton alloc] initWithCCSprite:toMainMenu];
                break;
            }
            default:
            {
                NSAssert(NO,@"Illegal service button type");
                break;
            }
        }
        [_button setDelegate:self];
    }
    return self;

}

- (void)cleanup
{
    _button = nil;
}


- (void)didButtonTouchBegan:(CCButton *)button touch:(UITouch *)touch
{

}

- (void)didButtonTouchMoved:(CCButton *)button touch:(UITouch *)touch
{

}

- (void)didButtonTouchEnded:(CCButton *)button touch:(UITouch *)touch
{
    switch (_serviceType)
    {
        case EBST_NEWGAME:
        {
            [SceneBase setScene:EST_GAME];
            break;
        }
        case EBST_SOUND:
        {
            [self _soundCall];
            break;
        }
        case EBST_PAUSE:
        {
            if ([SceneBase currentScene].type == EST_GAME)
             [[SceneBase currentScene] performSelectorOnMainThread:@selector(showPause)
                                                        withObject:nil waitUntilDone:YES];
            break;
        }
        case EBST_RESTART:
        {
             if([SceneBase currentScene].type == EST_GAME)
             {
                [SceneBase setScene:EST_GAME];
             }
            break;
        }
        case EBST_RETURN_TO_MAIN_MENU:
        {
            [SceneBase setScene:EST_START];
            break;
        }
        default:
        {
            NSAssert(NO,@"Illegal service button type");
            break;
        }
    }
}

- (void)didButtonTouchCanceled:(CCButton *)button touch:(UITouch *)touch
{

}

+(ServiceView *)createViewWithType:(EButtonServiceType)type;
{
    ServiceView * d = [[ServiceView alloc] initWithType:type];
    return d;
}

-(void)_soundCall
{
    [self.button removeAllChildren];
    if(_stateSound)
    {
        _stateSound = NO;
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.0f];
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.0f];
        [self.button addCCSprite:[CCSprite spriteWithFile:[ResourceManager getSoundOff]]];
    }
    else
    {
        _stateSound = YES;
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:1.0f];
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1.0f];
        [self.button addCCSprite:[CCSprite spriteWithFile:[ResourceManager buttonSoundOn]]];
    }
}
@end