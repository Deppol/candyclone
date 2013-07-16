//
// Created by Vladislav Babkin on 7/14/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CandyView.h"
#import "Candy.h"
#import "CCButton.h"
#import "ResourceManager.h"
#import "SceneGame.h"
#import "GameManager.h"
#import "ConstantsStatic.h"


@implementation CandyView
{
    SceneGame* _scene;
    CCSprite* _selector;
    CCSprite* _image1;
    CCSprite* _image2;
}
- (CandyView*)initWithCandy:(Candy *)candy scene:(SceneGame*)scene
{
    self = [super init];

    if(self)
    {
        _representsCandy = candy;
        _scene = scene;
        _selector = [CCSprite spriteWithFile:[ResourceManager getCandySelector]];
        _image1 = nil;
        _image2 = nil;

        NSMutableArray* images = [ResourceManager getCandyImage:candy.color type:candy.bonus.type];
        _button = [[CCButton alloc] initWithCCSprite:_selector];
	    [_button setSquare:[ConstantsStatic candyVisibleSize]];
	    _button.delegate = self;
        _button.box_x = -6;
        _button.box_y = -4;

        for(NSUInteger i = 0; i<[images count]; i++)
        {
            if(i == 0)
            {
                _image1 = [CCSprite spriteWithFile:[images objectAtIndex:i]];
                [_button addCCSprite:_image1];
            }
            else
            {
                _image2 = [CCSprite spriteWithFile:[images objectAtIndex:i]];
                [_button addCCSprite:_image2];
            }
        }
        [_button addCCSprite:_selector];
        _selector.opacity = 0;
    }

    return self;
}

-(void)deactivate
{
    _selector.opacity = 0;
}

- (void)activateBonus
{
    switch (_representsCandy.bonus.type)
    {
        case ECBT_NOTHING:
        {
            CCScaleTo* a1 = [CCScaleTo actionWithDuration:[ConstantsStatic animationTimeBonus] scale:0.05];

            [_button runAction:a1];
            break;
        }
        case ECBT_HORIZONTAL_LINE:
        {
            CCMoveBy* a1 = [CCMoveBy actionWithDuration:[ConstantsStatic animationTimeBonus] position:ccp(-400,0)];
            CCMoveBy* a2 = [CCMoveBy actionWithDuration:[ConstantsStatic animationTimeBonus] position:ccp(400,0)];

            [_image1 runAction:a1];
            [_image2 runAction:a2];

            break;

        }
        case ECBT_VERTICAL_LINE:
        {
            CCMoveBy* a1 = [CCMoveBy actionWithDuration:[ConstantsStatic animationTimeBonus] position:ccp(0,-400)];
            CCMoveBy* a2 = [CCMoveBy actionWithDuration:[ConstantsStatic animationTimeBonus] position:ccp(0,400)];

            [_image1 runAction:a1];
            [_image2 runAction:a2];

            break;
        }
        case ECBT_BOMB:
        {
            [_button runAction:[CCScaleBy actionWithDuration:[ConstantsStatic animationTimeBonus] scale:3.0f]];

            break;
        }
        case ECBT_COLOR_BOMB:
        {
            for(NSUInteger i = 0; i<[[_scene gameManager].candies count]; i++)
            {
                if([((Candy*)[_scene gameManager].candies[i]) color] == _representsCandy.color)
                {
                    [[_scene getCandyViewForPosition:i] colorBombActivation];
                }
            }

            [_button runAction:[CCScaleTo actionWithDuration:[ConstantsStatic animationTimeBonus] scale:0.05]];

            break;
        }
        default:
        {
            NSAssert(NO, @"WARNING: Impossible bonus detected");
            break;
        }
    }

    [_scene performSelector:@selector(removeChild:) withObject:self.button afterDelay:[ConstantsStatic animationTimeBonus] + 0.04f];

   // [self cleanup];
}

- (void)cleanup
{
    [_button stopAllActions];
    //[_button removeFromParentAndCleanup:YES];
    _button = nil;
    _representsCandy = nil;
    _scene = nil;
    _image1 = nil;
    _image2 = nil;
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
    if(!_scene.gameManager.animationIsRunning)
    {
        [_scene select:self];
    }
}

- (void)didButtonTouchCanceled:(CCButton *)button touch:(UITouch *)touch
{

}

-(void)activate
{
    _selector.opacity = 255;
}
-(void)colorBombActivation
{
    if(self.representsCandy.bonus.type == ECBT_NOTHING)
    {
        [self.button removeAllChildren];
        [self.button addCCSprite:[CCSprite spriteWithFile:[ResourceManager getCandyImage:self.representsCandy.color type:ECBT_COLOR_BOMB][0]]];
    }
}

@end