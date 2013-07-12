//
// Created by Vladislav Babkin on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface SharedHighScoreManager : NSObject

+ (SharedHighScoreManager *) shared;

@property(nonatomic, readonly) NSMutableArray * scores;


//!designated initializer
- (id)init;
- (void)cleanup;
- (void)addScore: (NSNumber*)newScore;

@end