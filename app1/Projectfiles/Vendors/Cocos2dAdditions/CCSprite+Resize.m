//
// Created by Vladislav Babkin on 7/14/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CCSprite+Resize.h"


@implementation CCSprite (Resize)

-(void)resizeTo:(CGSize) theSize
{
    CGFloat newWidth = theSize.width;

    float startWidth = self.contentSize.width;

    self.scale = newWidth/startWidth;

}

@end