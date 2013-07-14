//
// Created by Depool on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "SceneStart.h"
#import "SharedProgressManager.h"
#import "Game.h"
#import "Constants.h"


@implementation SceneStart
{
    CCLabelTTF* _labelForTittle;
}

/*
static
 */

+ (SceneStart *)createScene
{
    SceneStart * result = [[SceneStart alloc] initWithColor:ccc4(255, 0, 0, 255)];

    return result;
}

/*
   properties
 */
- (ESceneType)type
{
    return EST_START;
}


/*
instance methods
 */

//load all resources here
- (void)loadResources
{

}


// prepare the scene. init all objects here
- (void)prepare
{
    [super prepare];

    [self _initGameObjects];
}

-(void)_initGameObjects
{
    //init game tittle
    _labelForTittle = [CCLabelTTF labelWithString:[Constants gameTittle]
                                  fontName:@"Ubuntu Condensed"
                                  fontSize:40];
    [_labelForTittle setDimensions:CGSizeMake(320.0f,100.0f)];

    _labelForTittle.position = CGPointMake(160.0f, 400.0f);
    _labelForTittle.horizontalAlignment = kCCTextAlignmentCenter;
    [_labelForTittle setColor:ccYELLOW];

    [self addChild:_labelForTittle];
}


@end