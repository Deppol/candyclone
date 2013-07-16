//
// Created by Vladislav Babkin on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface ConstantsStatic : NSObject


/*
 * Game scene
 */

+ (NSUInteger)fieldSize;

+ (NSUInteger)pointsOneCandy;

+ (CGFloat)animationTimeSwap;

+ (CGFloat)animationTimeBonus;

+ (CGFloat)animatiopnTimeLineDrop;

+ (CGFloat)candyVisibleSize;

+ (NSInteger)gameTime;


/*
 * For SharedHighScoreManager
 */

+ (NSString *)scoresKeyName;

+ (NSNumber *)scoresCount;

/*
 * Fonts
 */

+ (NSString *)buttonsFontName;

+ (NSString *)gameTittle;

+ (NSString *)newGameConst;

+ (NSString *)highScoreConst;
@end