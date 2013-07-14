//
// Created by Vladislav Babkin on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ConstantsStatic.h"


@implementation ConstantsStatic
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

+(NSUInteger)buttonsFontSize
{
    return 40;
}

+ (NSString *)gameTittle
{
    NSString* temp = [[NSString alloc] initWithString:@"Candy Clone"];
    return temp;
}

+ (NSString *)newGameConst
{
    NSString* temp = [[NSString alloc] initWithString:@"New Game"];
    return temp;
}

+ (NSString *)highScoreConst
{
    NSString* temp = [[NSString alloc] initWithString:@"High Scores"];
    return temp;
}
@end