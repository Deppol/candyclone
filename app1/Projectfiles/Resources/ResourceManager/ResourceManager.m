//
// Created by Vladislav Babkin on 7/13/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ResourceManager.h"


@implementation ResourceManager
{

}
+(NSString*)getSoundOn
{
    return @"musicOn.png";
}
+(NSString*)getSoundOff
{
    return @"musicOff.png";
}
+(NSMutableArray*)getCandyImage: (enum ECandyColor)color type:(enum ECandyBonusType)type
{
    NSMutableArray * ret = [NSMutableArray array];
    switch(color)
    {
        case ECC_BLUE:
        {
            if(type == ECBT_BOMB)
            {
                [ret addObject:@"bombBlue.png"];
            }
            else if(type == ECBT_COLOR_BOMB)
            {
                [ret addObject:@"colorBombBlue.png"];
            }
            else if(type == ECBT_NOTHING)
            {
                [ret addObject:@"candyBlue.png"];
            }
            else if(type == ECBT_HORIZONTAL_LINE)
            {
                [ret addObject:@"blueColor.png"];
                [ret addObject:@"blueLines.png"];
            }
            else if(type == ECBT_VERTICAL_LINE)
            {
                [ret addObject:@"blueColorV.png"];
                [ret addObject:@"blueLinesV.png"];
            }
            else
            {
                NSAssert(NO, @"Incorrect type");
            }
            break;
        }

        case ECC_RED:
        {
            if(type == ECBT_BOMB)
            {
                [ret addObject:@"bombRed.png"];
            }
            else if(type == ECBT_COLOR_BOMB)
            {
                [ret addObject:@"colorBombRed.png"];
            }
            else if(type == ECBT_NOTHING)
            {
                [ret addObject:@"candyRed.png"];
            }
            else if(type == ECBT_HORIZONTAL_LINE)
            {
                [ret addObject:@"redColor.png"];
                [ret addObject:@"redLines.png"];
            }
            else if(type == ECBT_VERTICAL_LINE)
            {
                [ret addObject:@"redColorV.png"];
                [ret addObject:@"redLinesV.png"];
            }
            else
            {
                NSAssert(NO, @"Incorrect type");
            }
            break;
        }

        case ECC_GREEN:
        {
            if(type == ECBT_BOMB)
            {
                [ret addObject:@"bombGreen.png"];
            }
            else if(type == ECBT_COLOR_BOMB)
            {
                [ret addObject:@"colorBombGreen.png"];
            }
            else if(type == ECBT_NOTHING)
            {
                [ret addObject:@"candyGreen.png"];
            }
            else if(type == ECBT_HORIZONTAL_LINE)
            {
                [ret addObject:@"greenColor.png"];
                [ret addObject:@"greenLines.png"];
            }
            else if(type == ECBT_VERTICAL_LINE)
            {
                [ret addObject:@"greenColorV.png"];
                [ret addObject:@"greenLinesV.png"];
            }
            else
            {
                NSAssert(NO, @"Incorrect type");
            }
            break;
        }

        case ECC_YELLOW:
        {
            if(type == ECBT_BOMB)
            {
                [ret addObject:@"bombYellow.png"];
            }
            else if(type == ECBT_COLOR_BOMB)
            {
                [ret addObject:@"colorBombYellow.png"];
            }
            else if(type == ECBT_NOTHING)
            {
                [ret addObject:@"candyYellow.png"];
            }
            else if(type == ECBT_HORIZONTAL_LINE)
            {
                [ret addObject:@"yellowColor.png"];
                [ret addObject:@"yellowLines.png"];
            }
            else if(type == ECBT_VERTICAL_LINE)
            {
                [ret addObject:@"yellowColorV.png"];
                [ret addObject:@"yellowLinesV.png"];
            }
            else
            {
                NSAssert(NO, @"Incorrect type");
            }
            break;
        }

        case ECC_PURPLE:
        {
            if(type == ECBT_BOMB)
            {
                [ret addObject:@"bombPurple.png"];
            }
            else if(type == ECBT_COLOR_BOMB)
            {
                [ret addObject:@"colorBombPurple.png"];
            }
            else if(type == ECBT_NOTHING)
            {
                [ret addObject:@"candyPurple.png"];
            }
            else if(type == ECBT_HORIZONTAL_LINE)
            {
                [ret addObject:@"purpleColor.png"];
                [ret addObject:@"purpleLines.png"];
            }
            else if(type == ECBT_VERTICAL_LINE)
            {
                [ret addObject:@"purpleColorV.png"];
                [ret addObject:@"purpleLinesV.png"];
            }
            else
            {
                NSAssert(NO, @"Incorrect type");
            }
            break;
        }

        case ECC_ORANGE:
        {
            if(type == ECBT_BOMB)
            {
                [ret addObject:@"bombOrange.png"];
            }
            else if(type == ECBT_COLOR_BOMB)
            {
                [ret addObject:@"colorBombOrange.png"];
            }
            else if(type == ECBT_NOTHING)
            {
                [ret addObject:@"candyOrange.png"];
            }
            else if(type == ECBT_HORIZONTAL_LINE)
            {
                [ret addObject:@"orangeColor.png"];
                [ret addObject:@"orangeLines.png"];
            }
            else if(type == ECBT_VERTICAL_LINE)
            {
                [ret addObject:@"orangeColorV.png"];
                [ret addObject:@"orangeLinesV.png"];
            }
            else
            {
                NSAssert(NO, @"Incorrect type");
            }
            break;
        }

        default:
            NSAssert(NO, @"Incorrect color");
    }
    return ret;
}
+(NSString*)getCandySelector
{
    return @"selector.png";
}
@end