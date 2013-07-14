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
                _button = [[CCButton alloc] initWithCCSprite:[CCSprite spriteWithFile:[ResourceManager getSoundOn]]];
                _stateSound = YES;
                break;
            }
            case EBST_PAUSE:
            {
                break;
            }
            case EBST_RESTART:
            {
                break;
            }
            case EBST_RETURN_TO_MAIN_MENU:
            {
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
    switch (_serviceType)
    {
        case EBST_NEWGAME:
        {
            break;
        }
        case EBST_SOUND:
        {
            break;
        }
        case EBST_PAUSE:
        {
            break;
        }
        case EBST_RESTART:
        {
            break;
        }
        case EBST_RETURN_TO_MAIN_MENU:
        {
            break;
        }
        default:
        {
            NSAssert(NO,@"Illegal service button type");
            break;
        }
    }
}

- (void)didButtonTouchMoved:(CCButton *)button touch:(UITouch *)touch
{
    switch (_serviceType)
    {
        case EBST_NEWGAME:
        {
            break;
        }
        case EBST_SOUND:
        {
            break;
        }
        case EBST_PAUSE:
        {
            break;
        }
        case EBST_RESTART:
        {
            break;
        }
        case EBST_RETURN_TO_MAIN_MENU:
        {
            break;
        }
        default:
        {
            NSAssert(NO,@"Illegal service button type");
            break;
        }
    }
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
            [button removeAllChildren];
            if(_stateSound)
            {
                _stateSound = NO;
                [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.0f];
                [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.0f];
                [button addCCSprite:[CCSprite spriteWithFile:[ResourceManager getSoundOff]]];
            }
            else
            {
                _stateSound = YES;
                [[SimpleAudioEngine sharedEngine] setEffectsVolume:1.0f];
                [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1.0f];
                [button addCCSprite:[CCSprite spriteWithFile:[ResourceManager getSoundOn]]];
            }
            break;
        }
        case EBST_PAUSE:
        {
            break;
        }
        case EBST_RESTART:
        {
            break;
        }
        case EBST_RETURN_TO_MAIN_MENU:
        {
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
    switch (_serviceType)
    {
        case EBST_NEWGAME:
        {
            break;
        }
        case EBST_SOUND:
        {
            break;
        }
        case EBST_PAUSE:
        {
            break;
        }
        case EBST_RESTART:
        {
            break;
        }
        case EBST_RETURN_TO_MAIN_MENU:
        {
            break;
        }
        default:
        {
            NSAssert(NO,@"Illegal service button type");
            break;
        }
    }
}

+(ServiceView *)createViewWithType:(EButtonServiceType)type;
{
    ServiceView * d = [[ServiceView alloc] initWithType:type];
    return d;
}
@end