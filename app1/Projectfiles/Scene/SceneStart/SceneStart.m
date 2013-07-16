//
// Created by Depool on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "SceneStart.h"
#import "ConstantsStatic.h"
#import "CCButton.h"

#import "SharedHighScoreManager.h"
#import "ResourceManager.h"
#import "ServiceView.h"


@implementation SceneStart
{
    CCLabelTTF* _labelForTittle;
    CCLabelTTF* _labelForScore;
    NSMutableArray* _topScores;

    ServiceView * _startGame;
}

/*
static
 */

+ (SceneStart *)createScene
{
    SceneStart * result = [[SceneStart alloc] init];
    //TODO move to resource manager

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

    CCSprite* backgroundTexture = [CCSprite spriteWithFile: [ResourceManager getBackground]];
    [self addChild:backgroundTexture];

    [self _initGameObjects];
}

- (void)placeViewsiPhone
{
  //place the background
    for (int i = 0; i < (int) _children.count; ++i)
    {
        [[_children objectAtIndex:i] setPosition:[CCDirector sharedDirector].screenCenter];
        //[[_children objectAtIndex:i] setRect:CGRectMake(0.0f, 0.0f, 320.0f, 480.f)];
    }

    //place game tittle
    _labelForTittle.position = CGPointMake(160.0f, 400.0f);
    _labelForTittle.horizontalAlignment = kCCTextAlignmentCenter;
    [_labelForTittle setColor:ccYELLOW];

    //place score label
    _labelForScore.position = CGPointMake(160.0f, 350.0f);
    _labelForScore.horizontalAlignment = kCCTextAlignmentCenter;
    [_labelForScore setColor:ccWHITE];

    //place new game button
    _startGame.button.position = CGPointMake(160.0f, 50.f);

    //init and load high scores
    for (NSUInteger i = 0; i < _topScores.count ; ++i)
    {
        CCLabelTTF* tmp = (CCLabelTTF *)_topScores[i];
        tmp.anchorPoint = CGPointMake(0.0f, 0.0f);
        tmp.horizontalAlignment = kCCTextAlignmentLeft;
        tmp.position = CGPointMake(110.0f, 350.0f -
        (i+1)*(_labelForScore.position.y - _startGame.button.position.y)/
              ([[ConstantsStatic scoresCount] integerValue]+1));
        [tmp setColor:ccWHITE];
    }
}


-(void)_initGameObjects
{
    //init game tittle
    _labelForTittle = [CCLabelTTF labelWithString:[ConstantsStatic gameTittle]
                                         fontName:[ConstantsStatic buttonsFontName]
                                         fontSize:40];//TODO addToconstatns

    [self addChild:_labelForTittle];

    //init score label
    _labelForScore = [CCLabelTTF labelWithString:[ConstantsStatic highScoreConst]
                                 fontName:[ConstantsStatic buttonsFontName]
                                 fontSize:25];

    [self addChild:_labelForScore];


    //init new game button
     /*CCLabelTTF * newGameTempLabel = [CCLabelTTF labelWithString:[ConstantsStatic newGameConst]
                                                         fontName:[ConstantsStatic buttonsFontName]
                                                         fontSize:30];  //TODO addToconstatns
    [newGameTempLabel setColor:ccYELLOW];

    _startGame = [[ButtonsService alloc] initWithCCSprite:newGameTempLabel];
    _startGame.serviceType = EBST_NEWGAME;

    [self addChild:_startGame];*/
    _startGame = [ServiceView createViewWithType:EBST_NEWGAME];
    [self addChild:_startGame.button];

    //init and load high scores
    [self performSelectorOnMainThread:@selector(_initAndLoadHighScores) withObject:nil waitUntilDone:YES];

}

- (void)_initAndLoadHighScores
{
   _topScores = [[NSMutableArray alloc] initWithCapacity:[[ConstantsStatic scoresCount] unsignedIntegerValue]];

   for (NSInteger i = 0; i < [[ConstantsStatic scoresCount] integerValue]; ++i)
   {
       CCLabelTTF* tmp = [CCLabelTTF labelWithString:
               [NSString stringWithFormat:@"%d. %d", i+1, [[SharedHighScoreManager shared].scores[i] intValue]]
               fontName:[ConstantsStatic buttonsFontName]
               fontSize:20];

       [_topScores addObject:tmp]; //TODO ResourceManager
       [self addChild:tmp];
   }
}
-(void)cleanup
{
    [_labelForScore cleanup];
    _labelForScore = nil;
    [_labelForTittle cleanup];
    _labelForTittle = nil;
    _topScores = nil;
    [_startGame cleanup];
    _startGame = nil;
    [super cleanup];
}


@end