//
// Created by Vladislav Babkin on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <sys/ucred.h>
#import "SceneBase.h"
#import "SceneTest.h"
#import "SharedHighScoreManager.h"
#import "ConstantsForModelsStatic.h"
#import "Game.h"
#import "SharedProgressManager.h"
#import "CCButton.h"

//!Temporary scene. Made only to test Highscores. To be removed.
@implementation SceneTest

+ (SceneBase *)createScene
{
    SceneTest *result = [[SceneTest alloc] init];

    return result;
}

- (ESceneType)type
{
    return EST_TEST;
}

//! Load all resources here
- (void)loadResources
{

}

//! Prepare scene. Init all game objects here
- (void)prepare
{

}

- (void)placeViewsiPhone
{
    [self performSelectorOnMainThread:@selector(_place) withObject:nil waitUntilDone:YES];
}
- (void)placeViewsiPhoneWide
{
    [self performSelectorOnMainThread:@selector(_place) withObject:nil waitUntilDone:YES];
}
- (void)_place
{
    SharedHighScoreManager * scores = [SharedHighScoreManager shared];
    [scores addScore:[NSNumber numberWithInt:25]];
    for(int i = 0; i< [ConstantsForModelsStatic scoresCount].intValue; i++)
    {
        CCLabelTTF * label = [CCLabelTTF labelWithString:[[scores.scores objectAtIndex:(NSUInteger )i ] stringValue]
                                                fontName:@"Ubuntu Condensed"
                                                fontSize:28];

        CCNode* _root = [[CCNode alloc] init ];
        _root.position = ccp(50,50+(20*i));
        label.position = ccp(0,0);
        label.color = ccYELLOW;
        [_root addChild:label];
        [self addChild:_root];
    }
    CCSprite* sprite1 = [CCSprite spriteWithFile:@"text1.png"];
    CCSprite* sprite2 = [CCSprite spriteWithFile:@"text2.png"];
    CCButton* btn1 = [[CCButton alloc] initWithCCSprite:sprite1];
    btn1.position = ccp(75,75);
    [btn1 addCCSprite:sprite2];
    //[sprite runAction:[CCMoveBy actionWithDuration:1.0f position:ccp(0, -20)]];
    [self addChild:btn1];
}
@end