//
// Created by Vladislav Babkin on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ConstantsForModelsStatic.h"


@implementation ConstantsForModelsStatic
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


@end