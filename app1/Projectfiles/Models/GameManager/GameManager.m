//
// Created by Victor on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GameManager.h"
#import "Candy.h"
#import "MyConstants.h"
#import "SharedHighScoreManager.h"


@implementation GameManager
{
	NSMutableArray *_candies;
	NSInteger _score;

	Candy *_candy1;
	Candy *_candy2;

	//fields for calculations and updating
	NSInteger _seriesMultiplier;
	NSMutableArray *_left;
	NSMutableArray *_right;
	NSMutableArray *_up;
	NSMutableArray *_down;
	NSMutableArray *_newBonuses;
	NSMutableArray *_newBonusesPosition;
}

//Designated initializer
- (GameManager *)init
{
	_candies = [NSMutableArray arrayWithCapacity:FIELD_SIZE * FIELD_SIZE];
	for (NSUInteger i = 0; i < FIELD_SIZE * FIELD_SIZE; ++i)
		_candies[i] = [[Candy alloc] initWithColorAndBonus:(enum ECandyColor) arc4random() % ECC_COUNT Bonus:ECBT_NOTHING];

	_score = 0;
	_candy1 = nil;
	_candy2 = nil;

	_seriesMultiplier = 1;
	_left = [NSMutableArray arrayWithCapacity:FIELD_SIZE * FIELD_SIZE];
	_right = [NSMutableArray arrayWithCapacity:FIELD_SIZE * FIELD_SIZE];
	_up = [NSMutableArray arrayWithCapacity:FIELD_SIZE * FIELD_SIZE];
	_down = [NSMutableArray arrayWithCapacity:FIELD_SIZE * FIELD_SIZE];
	_newBonuses = [NSMutableArray array];
	_newBonusesPosition = [NSMutableArray array];

	return self;
}

//methods

- (NSUInteger)getIndexOf:(Candy *)candy
{
	return [_candies indexOfObject:candy];
}

- (void)markCandyByIndex:(NSUInteger)index
{
	[_candies[index] markCandy];
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

	_candy1 = nil;
	_candy2 = nil;

	_left = nil;
	_right = nil;
	_up = nil;
	_down = nil;
	_newBonuses = nil;
	_newBonusesPosition = nil;
}

- (void)candyClick:(Candy *)candy
{
	if (_candy1 == nil)
		_candy1 = candy;
	else
	{
		NSUInteger index1 = [self getIndexOf:candy];
		NSUInteger index2 = [self getIndexOf:_candy1];
		NSUInteger x1 = index1 / FIELD_SIZE;
		NSUInteger y1 = index1 % FIELD_SIZE;
		NSUInteger x2 = index2 / FIELD_SIZE;
		NSUInteger y2 = index2 % FIELD_SIZE;
		if(abs(x1 - x2) + abs(y1 - y2) == 1)
		{
			_candy2 = candy;
			[self _swapCandies];
		}
		else
			_candy1 = candy;
	}
}

- (void)_swapCandies
{
	NSUInteger index1 = [self getIndexOf:_candy1];
	NSUInteger index2 = [self getIndexOf:_candy2];
	Candy *temp = _candies[index1];
	_candies[index1] = _candies[index2];
	_candies[index2] = temp;
	BOOL result = [self _tryToExplode];
	if (result)
		while ([self _tryToExplode]);
	else
	{
		temp = _candies[index1];
		_candies[index1] = _candies[index2];
		_candies[index2] = temp;
	}
	_candy1 = nil;
	_candy2 = nil;
}

- (BOOL)_tryToExplode
{
	BOOL result = NO;

	[self _calcNeighbours];
	[self _markExplosions];

	NSInteger scoredPoints = [self _calcScore];

	if (scoredPoints > 0)
	{
		result = YES;
		_score += scoredPoints;

		[self _findBonusesToAdd];
		[self _cleanMarked];
		[self _placeNewBonuses];
		[self _updateField];
	}
	else
		_seriesMultiplier = 1;

	return result;
}

- (void)_calcNeighbours
{
	NSUInteger index;
	NSUInteger currentSeries;

	for (NSUInteger i = 0; i < FIELD_SIZE; ++i)
	{
		//fill _left
		currentSeries = 1;
		_left[i * FIELD_SIZE] = [NSNumber numberWithInteger:currentSeries];
		for (NSUInteger j = 1; j < FIELD_SIZE; ++j)
		{
			index = i * FIELD_SIZE + j;
			if (((Candy *) _candies[index]).color == ((Candy *) _candies[index - 1]).color)
				++currentSeries;
			else
				currentSeries = 1;
			_left[index] = [NSNumber numberWithInteger:currentSeries];
		}

		//fill _right
		currentSeries = 1;
		_right[i * FIELD_SIZE + FIELD_SIZE - 1] = [NSNumber numberWithInteger:currentSeries];
		for (NSInteger j = FIELD_SIZE - 2; j >= 0; --j)
		{
			index = i * FIELD_SIZE + j;
			if (((Candy *) _candies[index]).color == ((Candy *) _candies[index + 1]).color)
				++currentSeries;
			else
				currentSeries = 1;
			_right[index] = [NSNumber numberWithInteger:currentSeries];
		}
	}

	for (NSUInteger j = 0; j < FIELD_SIZE; ++j)
	{
		//fill _up
		currentSeries = 1;
		_up[j] = [NSNumber numberWithInteger:currentSeries];
		for (NSUInteger i = 1; i < FIELD_SIZE; ++i)
		{
			index = i * FIELD_SIZE + j;
			if (((Candy *) _candies[index]).color == ((Candy *) _candies[index - FIELD_SIZE]).color)
				++currentSeries;
			else
				currentSeries = 1;
			_up[index] = [NSNumber numberWithInteger:currentSeries];
		}

		//fill _down
		currentSeries = 1;
		_down[(FIELD_SIZE - 1) * FIELD_SIZE + j] = [NSNumber numberWithInteger:currentSeries];
		for (NSInteger i = FIELD_SIZE - 2; i >= 0; --i)
		{
			index = (NSUInteger) i * FIELD_SIZE + j;
			if (((Candy *) _candies[index]).color == ((Candy *) _candies[index + FIELD_SIZE]).color)
				++currentSeries;
			else
				currentSeries = 1;
			_down[index] = [NSNumber numberWithInteger:currentSeries];
		}
	}
}

- (void)_markExplosions
{
	NSUInteger index;
	for (NSUInteger i = 0; i < FIELD_SIZE; ++i)
		for (NSUInteger j = 0; j < FIELD_SIZE; ++j)
		{
			index = i * FIELD_SIZE + j;
			if ([_left[index] integerValue] + [_right[index] integerValue] - 1 >= 3
					|| [_up[index] integerValue] + [_down[index] integerValue] - 1 >= 3)
				[_candies[index] markCandy];
		}
}

- (NSInteger)_calcScore
{
	NSInteger result = 0;
	NSUInteger index;
	for (NSUInteger i = 0; i < FIELD_SIZE; ++i)
		for (NSUInteger j = 0; j < FIELD_SIZE; ++j)
		{
			index = i * FIELD_SIZE + j;
			if ([_left[index] integerValue] >= 3 && [_right[index] integerValue] == 1)
				result += POINTS_FOR_ONE_CANDY * _seriesMultiplier++ * [_left[index] integerValue] * ([_left[index] integerValue] - 2);
			if ([_up[index] integerValue] >= 3 && [_down[index] integerValue] == 1)
				result += POINTS_FOR_ONE_CANDY * _seriesMultiplier++ * [_up[index] integerValue] * ([_up[index] integerValue] - 2);
		}

	NSInteger countInLines = 0;
	NSInteger countOfMarked = 0;
	for (NSUInteger i = 0; i < FIELD_SIZE; ++i)
		for (NSUInteger j = 0; j < FIELD_SIZE; ++j)
		{
			index = i * FIELD_SIZE + j;
			if ([_left[index] integerValue] + [_right[index] integerValue] - 1 >= 3
					|| [_up[index] integerValue] + [_down[index] integerValue] - 1 >= 3)
				++countInLines;
			if (((Candy *) _candies[index]).isMarked)
				++countOfMarked;
		}
	result += POINTS_FOR_ONE_CANDY * (countOfMarked - countInLines);

	return result;
}

- (void)_findBonusesToAdd
{
	NSUInteger index;
	NSInteger horizontal, vertical;
	for (NSUInteger i = 0; i < FIELD_SIZE; ++i)
		for (NSUInteger j = 0; j < FIELD_SIZE; ++j)
		{
			index = i * FIELD_SIZE + j;
			horizontal = [_left[index] integerValue] > [_right[index] integerValue] ? [_left[index] integerValue] : [_right[index] integerValue];
			vertical = [_up[index] integerValue] > [_down[index] integerValue] ? [_up[index] integerValue] : [_down[index] integerValue];
			if (horizontal >= 3 && vertical >= 3)
			{
				[_newBonusesPosition addObject:[NSNumber numberWithInteger:index]];
				[_newBonuses addObject:[[Candy alloc] initWithColorAndBonus:((Candy *) _candies[index]).color Bonus:ECBT_BOMB]];
			}
		}
	for (NSUInteger i = 0; i < FIELD_SIZE; ++i)
		for (NSUInteger j = 0; j < FIELD_SIZE; ++j)
		{
			index = i * FIELD_SIZE + j;
			if ([_right[index] integerValue] == 4 && [_left[index] integerValue] == 1)
			{
				for (NSUInteger delta = 0; delta < 4; ++delta)
				{
					if (![_newBonusesPosition containsObject:[NSNumber numberWithInteger:index + delta]])
					{
						index += delta;
						break;
					}
				}
				[_newBonusesPosition addObject:[NSNumber numberWithInteger:index]];
				[_newBonuses addObject:[[Candy alloc] initWithColorAndBonus:((Candy *) _candies[index]).color Bonus:ECBT_HORIZONTAL_LINE]];
			}
		}
	for (NSUInteger i = 0; i < FIELD_SIZE; ++i)
		for (NSUInteger j = 0; j < FIELD_SIZE; ++j)
		{
			index = i * FIELD_SIZE + j;
			if ([_down[index] integerValue] == 4 && [_up[index] integerValue] == 1)
			{
				for (NSUInteger delta = 0; delta < 4; ++delta)
				{
					if (![_newBonusesPosition containsObject:[NSNumber numberWithInteger:index + delta * FIELD_SIZE]])
					{
						index += delta * FIELD_SIZE;
						break;
					}
				}
				[_newBonusesPosition addObject:[NSNumber numberWithInteger:index]];
				[_newBonuses addObject:[[Candy alloc] initWithColorAndBonus:((Candy *) _candies[index]).color Bonus:ECBT_VERTICAL_LINE]];
			}
		}
	for (NSUInteger i = 0; i < FIELD_SIZE; ++i)
		for (NSUInteger j = 0; j < FIELD_SIZE; ++j)
		{
			index = i * FIELD_SIZE + j;
			if ([_right[index] integerValue] == 5 && [_left[index] integerValue] == 1)
			{
				for (NSUInteger delta = 0; delta < 5; ++delta)
				{
					if (![_newBonusesPosition containsObject:[NSNumber numberWithInteger:index + delta]])
					{
						index += delta;
						break;
					}
				}
				[_newBonusesPosition addObject:[NSNumber numberWithInteger:index]];
				[_newBonuses addObject:[[Candy alloc] initWithColorAndBonus:((Candy *) _candies[index]).color Bonus:ECBT_COLOR_BOMB]];
			}
		}
	for (NSUInteger i = 0; i < FIELD_SIZE; ++i)
		for (NSUInteger j = 0; j < FIELD_SIZE; ++j)
		{
			index = i * FIELD_SIZE + j;
			if ([_down[index] integerValue] == 5 && [_up[index] integerValue] == 1)
			{
				for (NSUInteger delta = 0; delta < 5; ++delta)
				{
					if (![_newBonusesPosition containsObject:[NSNumber numberWithInteger:index + delta * FIELD_SIZE]])
					{
						index += delta * FIELD_SIZE;
						break;
					}
				}
				[_newBonusesPosition addObject:[NSNumber numberWithInteger:index]];
				[_newBonuses addObject:[[Candy alloc] initWithColorAndBonus:((Candy *) _candies[index]).color Bonus:ECBT_COLOR_BOMB]];
			}
		}
}

- (void)_cleanMarked
{
	NSUInteger index;
	for (NSUInteger i = 0; i < FIELD_SIZE; ++i)
		for (NSUInteger j = 0; j < FIELD_SIZE; ++j)
		{
			index = i * FIELD_SIZE + j;
			if (((Candy *) _candies[index]).isMarked)
			{
				[_candies[index] cleanup];
				_candies[index] = nil;
			}
		}
}

- (void)_placeNewBonuses
{
	NSUInteger count = [_newBonuses count];
	for (NSUInteger i = 0; i < count; ++i)
		_candies[(NSUInteger) [_newBonusesPosition[i] integerValue]] = _newBonuses[i];

	_newBonuses = nil;
	_newBonuses = [NSMutableArray array];

	_newBonusesPosition = nil;
	_newBonusesPosition = [NSMutableArray array];
}

- (void)_updateField
{
	NSUInteger index;
	NSUInteger newIndex;
	for (NSUInteger j = 0; j < FIELD_SIZE; ++j)
	{
		newIndex = (FIELD_SIZE - 1) * FIELD_SIZE + j;
		for (NSInteger i = FIELD_SIZE - 1; i >= 0; --i)
		{
			index = (NSUInteger) i * FIELD_SIZE + j;
			if (_candies[index] != nil)
			{
				if (newIndex != index)
				{
					_candies[newIndex] = _candies[index];
					_candies[index] = nil;
					newIndex -= FIELD_SIZE;
				}
			}
		}
	}
	for (NSUInteger i = 0; i < FIELD_SIZE; ++i)
		for (NSUInteger j = 0; j < FIELD_SIZE; ++j)
		{
			index = i * FIELD_SIZE + j;
			if (_candies[index] == nil)
				_candies[index] = [[Candy alloc] initWithColorAndBonus:(enum ECandyColor) arc4random() % ECC_COUNT Bonus:ECBT_NOTHING];
		}
}

- (void)_finishGame
{
	[[SharedHighScoreManager shared] addScore:[NSNumber numberWithInteger:_score]];
}

@end