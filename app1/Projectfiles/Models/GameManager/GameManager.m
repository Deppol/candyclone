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
	NSInteger _score;
	NSInteger _seriesMultiplier;
	Candy *_candy1;
	Candy *_candy2;
}

//Designated initializer
- (GameManager *)init
{
//	FIELD_SIZE = 7;
	_candies = [NSMutableArray arrayWithCapacity:FIELD_SIZE * FIELD_SIZE];
	for (NSUInteger i = 0; i < FIELD_SIZE * FIELD_SIZE; ++i)
		_candies[i] = [[Candy alloc] initWithColorAndBonus:(enum ECandyColor) arc4random() % ECC_COUNT Bonus:ECBT_NOTHING];
	_score = 0;
	_seriesMultiplier = 1;
	_candy1 = nil;
	_candy2 = nil;
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

- (void)markCandyByIndex:(CGPoint)coordinates
{
	[_candies[FIELD_SIZE * (NSInteger) coordinates.x + (NSInteger) coordinates.y] markCandy];
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

- (BOOL)_findExplosions
{
	BOOL result = NO;
	NSUInteger temp;
	NSMutableArray *left = [NSMutableArray arrayWithCapacity:FIELD_SIZE * FIELD_SIZE];
	NSMutableArray *right = [NSMutableArray arrayWithCapacity:FIELD_SIZE * FIELD_SIZE];
	NSMutableArray *up = [NSMutableArray arrayWithCapacity:FIELD_SIZE * FIELD_SIZE];
	NSMutableArray *down = [NSMutableArray arrayWithCapacity:FIELD_SIZE * FIELD_SIZE];
	NSUInteger currentSeries;

	for (NSUInteger i = 0; i < FIELD_SIZE; ++i)
	{
		//fill left
		temp = i * FIELD_SIZE;
		currentSeries = 1;
		left[temp] = [NSNumber numberWithInteger:currentSeries];
		for (NSUInteger j = 1; j < FIELD_SIZE; ++j)
		{
			if (((Candy *) _candies[temp + j]).color == ((Candy *) _candies[temp + j - 1]).color)
				++currentSeries;
			else
				currentSeries = 1;
			left[temp + j] = [NSNumber numberWithInteger:currentSeries];
		}

		//fill right
		currentSeries = 1;
		right[temp + FIELD_SIZE - 1] = [NSNumber numberWithInteger:currentSeries];
		for (NSInteger j = FIELD_SIZE - 2; j >= 0; --j)
		{
			if (((Candy *) _candies[temp + j]).color == ((Candy *) _candies[temp + j + 1]).color)
				++currentSeries;
			else
				currentSeries = 1;
			right[temp + j] = [NSNumber numberWithInteger:currentSeries];
		}
	}

	for (NSUInteger j = 0; j < FIELD_SIZE; ++j)
	{
		//fill up
		currentSeries = 1;
		up[j] = [NSNumber numberWithInteger:currentSeries];
		for (NSUInteger i = 1; i < FIELD_SIZE; ++i)
		{
			temp = i * FIELD_SIZE;
			if (((Candy *) _candies[temp + j]).color == ((Candy *) _candies[temp - FIELD_SIZE + j]).color)
				++currentSeries;
			else
				currentSeries = 1;
			up[temp + j] = [NSNumber numberWithInteger:currentSeries];
		}

		//fill down
		currentSeries = 1;
		down[(FIELD_SIZE - 1) * FIELD_SIZE + j] = [NSNumber numberWithInteger:currentSeries];
		for (NSInteger i = FIELD_SIZE - 2; i >= 0; --i)
		{
			temp = (NSUInteger) i * FIELD_SIZE;
			if (((Candy *) _candies[temp + j]).color == ((Candy *) _candies[temp + FIELD_SIZE + 1]).color)
				++currentSeries;
			else
				currentSeries = 1;
			right[temp + j] = [NSNumber numberWithInteger:currentSeries];
		}
	}

	[self _markExplosions:left Right:right Up:up Down:down];

	NSInteger scoredPoints = [self _calcScore:left Right:right Up:up Down:down];
	if (scoredPoints > 0)
	{
		result = YES;
		[self _cleanMarked];
		[self _updateField];
	}
	else
		_seriesMultiplier = 1;

	left = nil;
	right = nil;
	up = nil;
	down = nil;

	return result;
}

- (void)_markExplosions:(NSMutableArray *)left
                  Right:(NSMutableArray *)right
	                 Up:(NSMutableArray *)up
	               Down:(NSMutableArray *)down
{
	NSUInteger index;
	for (NSUInteger i = 0; i < FIELD_SIZE; ++i)
		for (NSUInteger j = 0; j < FIELD_SIZE; ++j)
		{
			index = i * FIELD_SIZE + j;
			if ([left[index] integerValue] + [right[index] integerValue] - 1 >= 3
					|| [up[index] integerValue] + [down[index] integerValue] - 1 >= 3)
				[_candies[index] markCandy];
		}
}


- (NSInteger)_calcScore:(NSMutableArray *)left
                  Right:(NSMutableArray *)right
	                 Up:(NSMutableArray *)up
	               Down:(NSMutableArray *)down
{
	NSInteger result = 0;
	NSUInteger index;
	for (NSUInteger i = 0; i < FIELD_SIZE; ++i)
		for (NSUInteger j = 0; j < FIELD_SIZE; ++j)
		{
			index = i * FIELD_SIZE + j;
			if ([left[index] integerValue] >= 3 && [right[index] integerValue] == 1)
				result += POINTS_FOR_ONE_CANDY * _seriesMultiplier++ * [left[index] integerValue] * ([left[index] integerValue] - 2);
			if ([up[index] integerValue] >= 3 && [down[index] integerValue] == 1)
				result += POINTS_FOR_ONE_CANDY * _seriesMultiplier++ * [up[index] integerValue] * ([up[index] integerValue] - 2);
		}

	NSInteger countInLines = 0;
	NSInteger countOfMarked = 0;
	for (NSUInteger i = 0; i < FIELD_SIZE; ++i)
		for (NSUInteger j = 0; j < FIELD_SIZE; ++j)
		{
			index = i * FIELD_SIZE + j;
			if ([left[index] integerValue] + [right[index] integerValue] - 1 >= 3
					|| [up[index] integerValue] + [down[index] integerValue] - 1 >= 3)
				++countInLines;
			if (((Candy *) _candies[index]).isMarked)
				++countOfMarked;
		}
	result += POINTS_FOR_ONE_CANDY * (countOfMarked - countInLines);

	return result;
}

- (void)_cleanMarked
{
	NSUInteger index;
	for (NSUInteger i = 0; i < FIELD_SIZE; ++i)
		for (NSUInteger j = 0; j < FIELD_SIZE; ++j)
		{
			index = i * FIELD_SIZE + j;
			if (((Candy *) _candies[index]).isMarked)
				[_candies[index] cleanup];
		}
}

- (void)_updateField
{
	NSUInteger index;
	for (NSUInteger i = 0; i < FIELD_SIZE; ++i)
		for (NSUInteger j = 0; j < FIELD_SIZE; ++j)
		{
			index = i * FIELD_SIZE + j;
			if (_candies[index] == nil)
				_candies[index] = [[Candy alloc] initWithColorAndBonus:(enum ECandyColor) arc4random() % ECC_COUNT Bonus:ECBT_NOTHING];
		}
}

@end