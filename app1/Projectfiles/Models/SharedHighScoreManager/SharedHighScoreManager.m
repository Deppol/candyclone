//
// Created by Vladislav Babkin on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SharedHighScoreManager.h"
#import "ConstantsStatic.h"


@implementation SharedHighScoreManager


static SharedHighScoreManager *_instance;

+ (SharedHighScoreManager *)shared
{
    @synchronized (self)
    {
        if (!_instance)
        {
            _instance = [[SharedHighScoreManager alloc] init];
        }
    }

    return _instance;
}

//!designated initializer
- (id)init
{
    NSAssert(_instance == nil, @"This is singleton. Please, use 'shared' method");
    self = [super init];

    if (self)
    {
        [self _load];
    }

    return self;
}

- (void)dealloc
{
    [self cleanup];

}

- (void)cleanup
{
    _scores = nil;
    _instance = nil;
}

- (void)addScore:(NSNumber *)newScore
{
    for (int i = 0; i < [ConstantsStatic scoresCount].intValue; i++)
    {
        if (((NSNumber *) [_scores objectAtIndex:i]).intValue < newScore.intValue)
        {
            [_scores insertObject:newScore atIndex:i];
            [_scores removeLastObject];
            break;
        }
    }

    [self _save];
}

- (void)_load
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *_scoreArray = [defaults arrayForKey:[ConstantsStatic scoresKeyName]];
    if ([_scoreArray count] == 0)
    {
        NSMutableArray *_generatedScores = [NSMutableArray array];
        for (int i = 0; i < [ConstantsStatic scoresCount].intValue; i++)
        {
            [_generatedScores addObject:[NSNumber numberWithInt:0]];
        }

        [defaults setObject:_generatedScores forKey:[ConstantsStatic scoresKeyName]];
        [defaults synchronize];

        _scoreArray = [defaults arrayForKey:[ConstantsStatic scoresKeyName]];
        NSAssert([_scoreArray count] != 0, @"Can't load scores for some reason");

        _scores = _generatedScores;
        return;
    }
    _scores = [NSMutableArray arrayWithArray:_scoreArray];

}

- (void)_save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_scores forKey:[ConstantsStatic scoresKeyName]];
    [defaults synchronize];
}

@end