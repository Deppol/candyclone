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
    CGFloat newHeight = theSize.height;


    float startWidth = self.contentSize.width;
    float startHeight = self.contentSize.height;

    self.scale = newWidth/startWidth;
    //float newScaleX = newWidth/startWidth;
    //float newScaleY = newHeight/startHeight;

    //self.scaleX = newScaleX;
    //self.scaleY = newScaleY;

}

@end