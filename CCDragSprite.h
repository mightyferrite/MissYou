//
//  CCDragSprite.h
//  Pattern Solver
//
//  Created by John Reine on 5/31/14.
//  Copyright 2014 MotileMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
//#import "GameStuff.h"


@protocol CCDragSpriteDelegate <NSObject>
@required
-(void)updateIconPoint:(CGPoint)p;
@end

@interface CCDragSprite : CCSprite
{
    id <CCDragSpriteDelegate> _ddelegate;
    NSMutableArray *animations;
    NSMutableArray *touchAnimations;
}
@property (nonatomic,strong) id ddelegate;
@property (getter=isIndex) NSInteger index;
@property (getter=isAnimationNumber) NSInteger animationNumber;
@property (getter=isChoosing) BOOL choosing;
@property (getter=isDraggable) BOOL draggable;
@property (getter=isAnimating) BOOL animating;
@property CGRect stayWithinThisRectWhileDragging;
@property BOOL stayWithinBox;

- (void)beginAnimating;
- (void)sendTouchNotification;
- (void)doBigAnimation;

@end
