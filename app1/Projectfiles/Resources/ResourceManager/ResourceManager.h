//
// Created by Vladislav Babkin on 7/13/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "ECandyBonusType.h"
#import "ECandyColor.h"

@interface ResourceManager : NSObject

+(NSString*)getSoundOn;
+(NSString*)getSoundOff;
+(NSMutableArray*)getCandyImage: (enum ECandyColor)color type:(enum ECandyBonusType)type;
@end