//
// Created by Victor on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "ECandyColor.h"

@class Candy;


@interface GameManager : NSObject
{

}

//properties

//Designated initializer
- (GameManager *)init;

//methods

- (CGPoint)getIndexOf:(Candy *)candy;

- (void)markCandyByIndex:(CGPoint)coords;

- (void)markColor:(enum ECandyColor)candyColor;

- (void)cleanup;

@end