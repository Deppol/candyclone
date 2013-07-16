//
// Created by Vladislav Babkin on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ConstantsStatic.h"


@implementation ConstantsStatic

+ (NSUInteger)fieldSize
{
    return 7;
}

+ (NSUInteger)pointsOneCandy
{
    return 30;
}

+ (CGFloat)animationTimeSwap
{
    return 0.4f;
}

+ (CGFloat)animationTimeBonus
{
    return 0.2f;
}

+ (CGFloat)animatiopnTimeLineDrop
{
    return 0.9f;
}

+ (CGFloat)candyVisibleSize
{
    return 40.0f;
}

+ (NSInteger)gameTime
{
    return 240;
}

/*
 * For SharedHighScoreManager
 */
+ (NSString *)scoresKeyName
{
    return @"CANDYCLONE_HIGHSCORES";
}

+ (NSNumber *)scoresCount
{
    return [NSNumber numberWithInt:5];
}

/*
 * Fonts
 */
+ (NSString *)buttonsFontName
{
    return @"Ubuntu Condensed";
}

+ (NSString *)gameTittle
{
    return @"Candy Clone";
}

+ (NSString *)newGameConst
{
    return @"New Game";
}

+ (NSString *)highScoreConst
{
    return @"High Scores";
}
@end