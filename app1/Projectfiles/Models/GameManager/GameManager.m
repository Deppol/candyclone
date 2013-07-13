//
// Created by Victor on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GameManager.h"
#import "Candy.h"
#import "MyConstants.h"


@implementation GameManager
{
	NSMutableArray *_candies;
}

//Designated initializer
- (GameManager *)init
{
//	FIELD_SIZE = 7;
	_candies = [NSMutableArray arrayWithCapacity:FIELD_SIZE * FIELD_SIZE];
	for (NSUInteger i = 0; i < FIELD_SIZE * FIELD_SIZE; ++i)
		_candies[i] = [[Candy alloc] initWithColorAndBonus:(enum ECandyColor) arc4random() % ECC_COUNT Bonus:ECBT_NOTHING];
	return self;
}

//methods

- (CGPoint)getIndexOf:(Candy *)candy
{
	CGPoint result;
	NSInteger position = [_candies indexOfObject:candy];
	result.x = position / FIELD_SIZE;
	result.y = position % FIELD_SIZE;
	return result;
}

- (void)markCandyByIndex:(CGPoint)coords
{
	[_candies[FIELD_SIZE * (NSInteger) coords.x + (NSInteger) coords.y] markCandy];
}

- (void)markColor:(enum ECandyColor)candyColor
{
	for (NSUInteger i = 0; i < FIELD_SIZE; ++i)
		for (NSUInteger j = 0; j < FIELD_SIZE; ++j)
		{
			Candy *cur = (Candy *) _candies[i * FIELD_SIZE + j];
			if (cur.color == candyColor)
				[cur markCandy];
		}
}

- (void)cleanup
{
	for (NSUInteger i = 0; i < FIELD_SIZE * FIELD_SIZE; ++i)
		[_candies[i] cleanup];
	_candies = nil;
}

@end