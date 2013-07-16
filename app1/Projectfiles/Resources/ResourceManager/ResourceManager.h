//
// Created by Vladislav Babkin on 7/13/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "ECandyBonusType.h"
#import "ECandyColor.h"

@interface ResourceManager : NSObject

+ (NSString *)getBackground;

+ (NSString *)getBackgroundField;

+ (NSString *)buttonSoundOn;

+ (NSString *)getSoundOff;

+ (NSMutableArray *)getCandyImage:(ECandyColor)color type:(ECandyBonusType)type;

+ (NSString *)getCandySelector;

+ (NSString *)buttonPause;


+ (NSString *)getBackgroundMusic;

+ (NSString *)getRestart;

@end