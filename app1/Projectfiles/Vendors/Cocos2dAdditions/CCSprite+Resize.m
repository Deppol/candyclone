//
// Created by Vladislav Babkin on 7/14/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CCSprite+Resize.h"


@implementation CCSprite (Resize)

-(void)resizeTo:(CGSize) theSize
{
    CGFloat newSize = max(theSize.width, theSize.height);

    float startSize = max(self.contentSize.width, self.contentSize.height);

    self.scale = newSize / startSize;

}

@end