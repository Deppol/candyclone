//
// Created by Victor on 7/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GameManager.h"
#import "Candy.h"
#import "MyConstants.h"
#import "SharedHighScoreManager.h"
#import "DelegateContainer.h"


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
    _animationIsRunning = NO;
	_candies = [NSMutableArray arrayWithCapacity:FIELD_SIZE * FIELD_SIZE];
	for (NSUInteger i = 0; i < FIELD_SIZE * FIELD_SIZE; ++i)
		_candies[i] = [[Candy alloc] initWithColorAndBonus:(enum ECandyColor) arc4random() % ECC_COUNT Bonus:ECBT_NOTHING];

	_score = 0;
	_candy1 = nil;
	_candy2 = nil;

	_seriesMultiplier = 1;

	_left = [NSMutableArray arrayWithCapacity:FIELD_SIZE * FIELD_SIZE];
	for (NSUInteger i = 0; i < FIELD_SIZE * FIELD_SIZE; ++i)
		_left[i] = [NSNumber numberWithInteger:0];

	_right = [NSMutableArray arrayWithCapacity:FIELD_SIZE * FIELD_SIZE];
	for (NSUInteger i = 0; i < FIELD_SIZE * FIELD_SIZE; ++i)
		_right[i] = [NSNumber numberWithInteger:0];

	_up = [NSMutableArray arrayWithCapacity:FIELD_SIZE * FIELD_SIZE];
	for (NSUInteger i = 0; i < FIELD_SIZE * FIELD_SIZE; ++i)
		_up[i] = [NSNumber numberWithInteger:0];

	_down = [NSMutableArray arrayWithCapacity:FIELD_SIZE * FIELD_SIZE];
	for (NSUInteger i = 0; i < FIELD_SIZE * FIELD_SIZE; ++i)
		_down[i] = [NSNumber numberWithInteger:0];

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
	for (NSUInteger index = 0; index < FIELD_SIZE * FIELD_SIZE; ++index)
	{
		if (((Candy *) _candies[index]).color == candyColor)
			[_candies[index] markCandy];
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
    {
		_candy1 = candy;
        [DelegateContainer callSetSelection:_candy1];
    }
	else
	{
		if (candy != _candy1)
		{
			NSUInteger index1 = [self getIndexOf:candy];
			NSUInteger index2 = [self getIndexOf:_candy1];

			NSUInteger x1 = index1 / FIELD_SIZE;
			NSUInteger y1 = index1 % FIELD_SIZE;
			NSUInteger x2 = index2 / FIELD_SIZE;
			NSUInteger y2 = index2 % FIELD_SIZE;

			if (abs(x1 - x2) + abs(y1 - y2) == 1)
			{
				_candy2 = candy;
                [self _swap2];
			}
			else
            {
                [DelegateContainer callUnsetSelection:_candy1];
				_candy1 = candy;
                [DelegateContainer callSetSelection:_candy1];
            }
		}
	}
}

-(void)_swap2
{
    [NSThread detachNewThreadSelector:@selector(_swapCandies) toTarget:self withObject:nil];
}

- (void)doInitialUpdate
{
    [NSThread detachNewThreadSelector:@selector(_doInitialUpdate) toTarget:self withObject:nil];

}
- (void)_doInitialUpdate
{
    _animationIsRunning = YES;
    while([self _tryToExplode]);
    _animationIsRunning = NO;
}

- (void)_swapCandies
{
    _animationIsRunning = YES;
    [DelegateContainer callUnsetSelection:_candy1];
    [DelegateContainer callSwap:_candy1 candy2:_candy2];
    [NSThread sleepForTimeInterval:SWAP_ANIMATION_TIME+0.04f];
    NSUInteger index1 = [self getIndexOf:_candy1];
	NSUInteger index2 = [self getIndexOf:_candy2];

	Candy *temp = _candies[index1];
	_candies[index1] = _candies[index2];
	_candies[index2] = temp;

	BOOL result = [self _tryToExplode];

	if (result)
    {
		while ([self _tryToExplode]);
    }
	else
	{
		temp = _candies[index1];
		_candies[index1] = _candies[index2];
		_candies[index2] = temp;
	}
    if (!result)
    {
        [DelegateContainer callSwap:_candy1 candy2:_candy2];
        [NSThread sleepForTimeInterval:SWAP_ANIMATION_TIME+0.04f];
    }
    _candy1 = nil;
    _candy2 = nil;
    _animationIsRunning = NO;
}

- (BOOL)_tryToExplode
{
//	NSMutableString *s = [NSMutableString string];
//	for (NSUInteger i = 0; i < FIELD_SIZE; ++i)
//	{
//		for (NSUInteger j = 0; j < FIELD_SIZE; ++j)
//		{
//			[s appendString:[NSString stringWithFormat:@"%d ", (NSInteger) ((Candy *) _candies[i * FIELD_SIZE + j]).color]];
//		}
//		NSLog(s);
//		s = nil;
//		s = [[NSMutableString alloc] init];
//	}
//	NSLog(@"/////////////////////");
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
	for (NSUInteger index = 0; index < FIELD_SIZE * FIELD_SIZE; ++index)
	{
		if ([_left[index] integerValue] + [_right[index] integerValue] - 1 >= 3
				|| [_up[index] integerValue] + [_down[index] integerValue] - 1 >= 3)
			[_candies[index] markCandy];
	}
}

- (NSInteger)_calcScore
{
	NSInteger result = 0;

	for (NSUInteger index = 0; index < FIELD_SIZE * FIELD_SIZE; ++index)
	{
		if ([_left[index] integerValue] >= 3 && [_right[index] integerValue] == 1)
			result += POINTS_FOR_ONE_CANDY * _seriesMultiplier++ * [_left[index] integerValue] * ([_left[index] integerValue] - 2);

		if ([_up[index] integerValue] >= 3 && [_down[index] integerValue] == 1)
			result += POINTS_FOR_ONE_CANDY * _seriesMultiplier++ * [_up[index] integerValue] * ([_up[index] integerValue] - 2);
	}

	NSInteger countInLines = 0;
	NSInteger countOfMarked = 0;

	for (NSUInteger index = 0; index < FIELD_SIZE * FIELD_SIZE; ++index)
	{
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
	NSInteger horizontal, vertical;

	//find bombs
	for (NSUInteger index = 0; index < FIELD_SIZE * FIELD_SIZE; ++index)
	{
		horizontal = [_left[index] integerValue] > [_right[index] integerValue] ? [_left[index] integerValue] : [_right[index] integerValue];
		vertical = [_up[index] integerValue] > [_down[index] integerValue] ? [_up[index] integerValue] : [_down[index] integerValue];

		if (horizontal >= 3 && vertical >= 3)
		{
			[_newBonusesPosition addObject:[NSNumber numberWithInteger:index]];
			[_newBonuses addObject:[[Candy alloc] initWithColorAndBonus:((Candy *) _candies[index]).color Bonus:ECBT_BOMB]];
		}
	}

	NSUInteger delta;

	//find horizontal lines
	for (NSUInteger index = 0; index < FIELD_SIZE * FIELD_SIZE; ++index)
	{
		if ([_right[index] integerValue] == 4 && [_left[index] integerValue] == 1)
		{
			for (delta = 0; delta < 4; ++delta)
			{
				if (![_newBonusesPosition containsObject:[NSNumber numberWithInteger:index + delta]])
					break;
			}

			[_newBonusesPosition addObject:[NSNumber numberWithInteger:index + delta]];
			[_newBonuses addObject:[[Candy alloc] initWithColorAndBonus:((Candy *) _candies[index + delta]).color Bonus:ECBT_HORIZONTAL_LINE]];
		}
	}

	//find vertical lines
	for (NSUInteger index = 0; index < FIELD_SIZE * FIELD_SIZE; ++index)
	{
		if ([_down[index] integerValue] == 4 && [_up[index] integerValue] == 1)
		{
			for (delta = 0; delta < 4; ++delta)
			{
				if (![_newBonusesPosition containsObject:[NSNumber numberWithInteger:index + delta * FIELD_SIZE]])
					break;
			}

			[_newBonusesPosition addObject:[NSNumber numberWithInteger:index + delta * FIELD_SIZE]];
			[_newBonuses addObject:[[Candy alloc] initWithColorAndBonus:((Candy *) _candies[index + delta * FIELD_SIZE]).color Bonus:ECBT_VERTICAL_LINE]];
		}
	}

	//find color bombs
	for (NSUInteger index = 0; index < FIELD_SIZE * FIELD_SIZE; ++index)
	{
		if ([_right[index] integerValue] == 5 && [_left[index] integerValue] == 1)
		{
			for (delta = 0; delta < 5; ++delta)
			{
				if (![_newBonusesPosition containsObject:[NSNumber numberWithInteger:index + delta]])
					break;
			}

			[_newBonusesPosition addObject:[NSNumber numberWithInteger:index + delta]];
			[_newBonuses addObject:[[Candy alloc] initWithColorAndBonus:((Candy *) _candies[index + delta]).color Bonus:ECBT_COLOR_BOMB]];
		}

		if ([_down[index] integerValue] == 5 && [_up[index] integerValue] == 1)
		{
			for (delta = 0; delta < 5; ++delta)
			{
				if (![_newBonusesPosition containsObject:[NSNumber numberWithInteger:index + delta * FIELD_SIZE]])
					break;
			}

			[_newBonusesPosition addObject:[NSNumber numberWithInteger:index + delta * FIELD_SIZE]];
			[_newBonuses addObject:[[Candy alloc] initWithColorAndBonus:((Candy *) _candies[index + delta * FIELD_SIZE]).color Bonus:ECBT_COLOR_BOMB]];
		}
	}
}

- (void)_cleanMarked
{
	for (NSUInteger index = 0; index < FIELD_SIZE * FIELD_SIZE; ++index)
	{
		if (((Candy *) _candies[index]).isMarked)
		{
			[_candies[index] cleanup];
			_candies[index] = [NSNull null];
		}
	}
}

- (void)_placeNewBonuses
{
	NSUInteger count = [_newBonuses count];
	for (NSUInteger i = 0; i < count; ++i)
    {
		_candies[(NSUInteger) [_newBonusesPosition[i] integerValue]] = _newBonuses[i];
        [DelegateContainer callAddBonus:_newBonuses[i]];
    }

	_newBonuses = nil;
	_newBonuses = [NSMutableArray array];

	_newBonusesPosition = nil;
	_newBonusesPosition = [NSMutableArray array];
}

- (void)_updateField
{
	NSUInteger index;
	NSUInteger newIndex;

	//fall for existing candies
	for (NSUInteger j = 0; j < FIELD_SIZE; ++j)
	{
		newIndex = (FIELD_SIZE - 1) * FIELD_SIZE + j;

		for (NSInteger i = FIELD_SIZE - 1; i >= 0; --i)
		{
			index = (NSUInteger) i * FIELD_SIZE + j;

			if (_candies[index] != [NSNull null])
			{
				if (newIndex != index)
				{
                    //[DelegateContainer performSelectorOnMainThread:@selector(callFallFromField:point:) withObject:<#(id)arg#> waitUntilDone:<#(BOOL)wait#>];
                    [DelegateContainer callFallFromField:_candies[index] point:newIndex];
					_candies[newIndex] = _candies[index];
					_candies[index] = [NSNull null];
				}
				newIndex -= FIELD_SIZE;
			}
		}
	}

	//fill deleted candies
	for (index = 0; index < FIELD_SIZE * FIELD_SIZE; ++index)
	{
		if (_candies[index] == [NSNull null])
        {
			_candies[index] = [[Candy alloc] initWithColorAndBonus:(enum ECandyColor) arc4random() % ECC_COUNT Bonus:ECBT_NOTHING];
            [DelegateContainer callFallFromOutside:_candies[index] point:index];
        }
	}
    [NSThread sleepForTimeInterval:LINE_DROP_ANIMATION_TIME + 0.04f];
}

- (void)_finishGame
{
	[[SharedHighScoreManager shared] addScore:[NSNumber numberWithInteger:_score]];
}

@end