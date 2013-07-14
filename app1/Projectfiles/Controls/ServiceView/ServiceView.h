//
// Created by Vladislav Babkin on 7/14/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "CCButtonDelegate.h"
#import "EButtonServiceType.h"


@interface ServiceView : NSObject <CCButtonDelegate>

@property (nonatomic, readonly) CCButton* button;

- (void)didButtonTouchBegan:(CCButton *)button touch:(UITouch *)touch;

- (void)didButtonTouchMoved:(CCButton *)button touch:(UITouch *)touch;

- (void)didButtonTouchEnded:(CCButton *)button touch:(UITouch *)touch;

- (void)didButtonTouchCanceled:(CCButton *)button touch:(UITouch *)touch;

- (id)initWithType:(EButtonServiceType)type;

- (void)cleanup;

+ (ServiceView *)createViewWithType:(EButtonServiceType)type;



@end