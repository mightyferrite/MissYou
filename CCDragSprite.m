//
//  CCDragSprite.m
//  Pattern Solver
//
//  Created by John Reine on 5/31/14.
//  Copyright 2014 MotileMedia. All rights reserved.
//

#import "CCDragSprite.h"

@implementation CCDragSprite

- (void)onEnter
{
    [super onEnter];
    self.userInteractionEnabled = true;
    //[self createAnimations];
    //[_ddelegate updatePoint:CGPointMake(200.0, 200.0)];
    //[self beginAnimating];
}

- (void)beginAnimating
{
    [self createAnimations];
    
    //float duration = (arc4random() % 20);
    //NSLog(@"duration for begin = %0.2f",(duration/10));
    id delay = [CCActionDelay actionWithDuration:0.1];
    id actionCallFunc = [CCActionCallFunc actionWithTarget:self selector:@selector(finishedBeginAnimatingDelay)];
    [self runAction:[CCActionSequence actions: delay, actionCallFunc, nil]];
    
    //[self finishedBeginAnimatingDelay];
}

- (void)finishedBeginAnimatingDelay
{
    //JTR - new to fix creashing issue wayne found!!!
    if([animations count] < 1)
    {
        [self createAnimations];
    }
    int num = arc4random() % [animations count];
    //NSLog(@"num %i", num);
    [self runAction:[CCActionRepeatForever actionWithAction:[animations objectAtIndex:num]]];
}

- (void)doBigAnimation
{
    if([touchAnimations count] < 1)
    {
        [self createTouchAnimations];
    }
    int num = arc4random() % [touchAnimations count];

    [self stopAllActions];
    id callbackAction = [CCActionCallFunc actionWithTarget: self selector: @selector(doBigAnimationCallback)];
    [self runAction:[CCActionSequence actions:[touchAnimations objectAtIndex:num], callbackAction, nil]];
    
}

- (void)doBigAnimationCallback
{
    [self stopAllActions];
    [self finishedBeginAnimatingDelay];
}
- (void)createAnimations
{
    animations = [[NSMutableArray alloc] init];
    CCActionRotateTo * rotLeft = [CCActionRotateBy actionWithDuration:0.1 angle:-8.0];
    CCActionRotateTo * rotCenter = [CCActionRotateBy actionWithDuration:0.1 angle:8.0];
    CCActionRotateTo * rotRight = [CCActionRotateBy actionWithDuration:0.1 angle:8.0];
    CCActionRotateTo * rotOneMore = [CCActionRotateBy actionWithDuration:0.1 angle:-8.0];
    CCActionSequence * rotSeq = [CCActionSequence actions:rotLeft, rotRight, rotCenter, rotOneMore, nil];
    [animations addObject:rotSeq];
    //int dd = 5;
    int dd = 4;//(arc4random() % 5);
    float duration = 0.2;//(arc4random() % 5);
    CCActionMoveTo * moveLeft = [CCActionMoveBy actionWithDuration:duration position:ccp(-dd,0.0)];
    CCActionMoveTo * moveCenter = [CCActionMoveBy actionWithDuration:duration position:ccp(dd,0)];
    CCActionMoveTo * moveRight = [CCActionMoveBy actionWithDuration:duration position:ccp(dd,0)];
    CCActionMoveTo * moveCenterAgain = [CCActionMoveBy actionWithDuration:duration position:ccp(-dd,0)];
    CCActionSequence *leftrightSeq = [CCActionSequence actions: moveLeft, moveCenter, moveRight, moveCenterAgain, nil];
    [animations addObject:leftrightSeq];
    
    dd = 3;//(arc4random() % 8);
    duration = 0.3;//(arc4random() % 5);

    CCActionMoveTo * moveUp = [CCActionMoveBy actionWithDuration:duration position:ccp(0,-dd)];
    CCActionMoveTo * moveUpCenter = [CCActionMoveBy actionWithDuration:duration position:ccp(0,dd)];
    CCActionMoveTo * moveDown = [CCActionMoveBy actionWithDuration:duration position:ccp(0,dd)];
    CCActionMoveTo * moveUpCenterAgain = [CCActionMoveBy actionWithDuration:duration position:ccp(0,-dd)];
    CCActionSequence *upDnSeq = [CCActionSequence actions: moveUp, moveUpCenter, moveDown, moveUpCenterAgain, nil];
    [animations addObject:upDnSeq];
    
    dd = 5;
    duration = 0.4;
    CCActionMoveTo * diagUp = [CCActionMoveBy actionWithDuration:duration position:ccp(-dd,-dd)];
    CCActionMoveTo * diagUpCenter = [CCActionMoveBy actionWithDuration:duration position:ccp(dd,dd)];
    CCActionMoveTo * diagDown = [CCActionMoveBy actionWithDuration:duration position:ccp(dd,dd)];
    CCActionMoveTo * diagUpCenterAgain = [CCActionMoveBy actionWithDuration:duration position:ccp(-dd,-dd)];
    CCActionSequence *diagSeq = [CCActionSequence actions: diagUp, diagUpCenter, diagDown, diagUpCenterAgain, nil];
    [animations addObject:diagSeq];
    
    dd = 6;
    duration = 0.3;
    CCActionMoveTo * odiagUp = [CCActionMoveBy actionWithDuration:duration position:ccp(dd,dd)];
    CCActionMoveTo * odiagUpCenter = [CCActionMoveBy actionWithDuration:duration position:ccp(-dd,-dd)];
    CCActionMoveTo * odiagDown = [CCActionMoveBy actionWithDuration:duration position:ccp(-dd,-dd)];
    CCActionMoveTo * odiagUpCenterAgain = [CCActionMoveBy actionWithDuration:duration position:ccp(dd,dd)];
    CCActionSequence *odiagSeq = [CCActionSequence actions: odiagUp, odiagUpCenter, odiagDown, odiagUpCenterAgain, nil];
    [self runAction:[CCActionRepeatForever actionWithAction:odiagSeq]];
    [animations addObject:odiagSeq];
    
}

- (void)createTouchAnimations
{
    touchAnimations = [[NSMutableArray alloc] init];
    CCActionScaleTo *scaleUp = [CCActionScaleTo actionWithDuration:0.7 scale:3.0];
    CCActionScaleTo *scaleDn = [CCActionScaleTo actionWithDuration:0.7 scale:1.0];
    CCActionScaleTo *scaleUpmini = [CCActionScaleTo actionWithDuration:0.2 scale:3.5];
    CCActionScaleTo *scaleDnMini = [CCActionScaleTo actionWithDuration:0.2 scale:2.5];
    
    CCActionSequence *scale = [CCActionSequence actions:[scaleUp copy], [scaleUpmini copy], [scaleDnMini copy], [scaleUpmini copy], [scaleDnMini copy],[scaleUpmini copy], [scaleDnMini copy],[scaleUpmini copy], [scaleDnMini copy],[scaleUpmini copy], [scaleDnMini copy], [scaleDn copy], nil];
    [touchAnimations addObject:scale];
    
    CCActionRotateTo * rotLeft = [CCActionRotateBy actionWithDuration:0.5 angle:360.0];
    CCActionSequence *scale2 = [CCActionSequence actions:[scaleUp copy], rotLeft, [scaleDn copy], nil];
    [touchAnimations addObject:scale2];
    
    CCActionRotateTo * rotRight = [CCActionRotateBy actionWithDuration:0.5 angle:-360.0];
    CCActionSequence *scale3 = [CCActionSequence actions:[scaleUp copy], rotRight, [scaleDn copy], nil];
    [touchAnimations addObject:scale3];
    
    int dd = 40;
    float duration = 0.1;
    CCActionMoveTo * diagUp2 = [CCActionMoveBy actionWithDuration:duration position:ccp(-dd,-dd)];
    CCActionMoveTo * diagUpCenter2 = [CCActionMoveBy actionWithDuration:duration position:ccp(dd,dd)];
    CCActionMoveTo * diagDown2 = [CCActionMoveBy actionWithDuration:duration position:ccp(dd,dd)];
    CCActionMoveTo * diagUpCenterAgain2 = [CCActionMoveBy actionWithDuration:duration position:ccp(-dd,-dd)];
    CCActionSequence *diag = [CCActionSequence actions: [scaleUp copy], [diagUp2 copy], [diagUpCenter2 copy], [diagDown2 copy], [diagUpCenterAgain2 copy], [diagUp2 copy], [diagUpCenter2 copy], [diagDown2 copy], [diagUpCenterAgain2 copy], [scaleDn copy], nil];
    [touchAnimations addObject:diag];

    CCActionMoveTo * diagUp3 = [CCActionMoveBy actionWithDuration:duration position:ccp(-dd,dd)];
    CCActionMoveTo * diagUpCenter3 = [CCActionMoveBy actionWithDuration:duration position:ccp(dd, -dd)];
    CCActionMoveTo * diagDown3 = [CCActionMoveBy actionWithDuration:duration position:ccp(dd,-dd)];
    CCActionMoveTo * diagUpCenterAgain3 = [CCActionMoveBy actionWithDuration:duration position:ccp(-dd,dd)];
    CCActionSequence *diag3 = [CCActionSequence actions: [scaleUp copy], [diagUp3 copy], [diagUpCenter3 copy], [diagDown3 copy], [diagUpCenterAgain3 copy], [diagUp3 copy], [diagUpCenter3 copy], [diagDown3 copy], [diagUpCenterAgain3 copy], [scaleDn copy], nil];
    [touchAnimations addObject:diag3];
    /*
    CCActionRotateTo * rotLeft = [CCActionRotateBy actionWithDuration:0.1 angle:-8.0];
    CCActionRotateTo * rotCenter = [CCActionRotateBy actionWithDuration:0.1 angle:8.0];
    CCActionRotateTo * rotRight = [CCActionRotateBy actionWithDuration:0.1 angle:8.0];
    CCActionRotateTo * rotOneMore = [CCActionRotateBy actionWithDuration:0.1 angle:-8.0];
    CCActionSequence * rotSeq = [CCActionSequence actions:rotLeft, rotRight, rotCenter, rotOneMore, nil];
    [animations addObject:rotSeq];
    //int dd = 5;
    int dd = 4;//(arc4random() % 5);
    float duration = 0.2;//(arc4random() % 5);
    CCActionMoveTo * moveLeft = [CCActionMoveBy actionWithDuration:duration position:ccp(-dd,0.0)];
    CCActionMoveTo * moveCenter = [CCActionMoveBy actionWithDuration:duration position:ccp(dd,0)];
    CCActionMoveTo * moveRight = [CCActionMoveBy actionWithDuration:duration position:ccp(dd,0)];
    CCActionMoveTo * moveCenterAgain = [CCActionMoveBy actionWithDuration:duration position:ccp(-dd,0)];
    CCActionSequence *leftrightSeq = [CCActionSequence actions: moveLeft, moveCenter, moveRight, moveCenterAgain, nil];
    [animations addObject:leftrightSeq];
    
    dd = 3;//(arc4random() % 8);
    duration = 0.3;//(arc4random() % 5);
    
    CCActionMoveTo * moveUp = [CCActionMoveBy actionWithDuration:duration position:ccp(0,-dd)];
    CCActionMoveTo * moveUpCenter = [CCActionMoveBy actionWithDuration:duration position:ccp(0,dd)];
    CCActionMoveTo * moveDown = [CCActionMoveBy actionWithDuration:duration position:ccp(0,dd)];
    CCActionMoveTo * moveUpCenterAgain = [CCActionMoveBy actionWithDuration:duration position:ccp(0,-dd)];
    CCActionSequence *upDnSeq = [CCActionSequence actions: moveUp, moveUpCenter, moveDown, moveUpCenterAgain, nil];
    [animations addObject:upDnSeq];
    
    dd = 5;
    duration = 0.4;
    CCActionMoveTo * diagUp = [CCActionMoveBy actionWithDuration:duration position:ccp(-dd,-dd)];
    CCActionMoveTo * diagUpCenter = [CCActionMoveBy actionWithDuration:duration position:ccp(dd,dd)];
    CCActionMoveTo * diagDown = [CCActionMoveBy actionWithDuration:duration position:ccp(dd,dd)];
    CCActionMoveTo * diagUpCenterAgain = [CCActionMoveBy actionWithDuration:duration position:ccp(-dd,-dd)];
    CCActionSequence *diagSeq = [CCActionSequence actions: diagUp, diagUpCenter, diagDown, diagUpCenterAgain, nil];
    [animations addObject:diagSeq];
    
    dd = 6;
    duration = 0.3;
    CCActionMoveTo * odiagUp = [CCActionMoveBy actionWithDuration:duration position:ccp(dd,dd)];
    CCActionMoveTo * odiagUpCenter = [CCActionMoveBy actionWithDuration:duration position:ccp(-dd,-dd)];
    CCActionMoveTo * odiagDown = [CCActionMoveBy actionWithDuration:duration position:ccp(-dd,-dd)];
    CCActionMoveTo * odiagUpCenterAgain = [CCActionMoveBy actionWithDuration:duration position:ccp(dd,dd)];
    CCActionSequence *odiagSeq = [CCActionSequence actions: odiagUp, odiagUpCenter, odiagDown, odiagUpCenterAgain, nil];
    [self runAction:[CCActionRepeatForever actionWithAction:odiagSeq]];
    [animations addObject:odiagSeq];
     */
    
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    //[[OALSimpleAudio sharedInstance] playEffect:SOUND_TIPTOE];
    //[self sendBeginTouch];
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    // we want to know the location of our touch in this scene
    //CGPoint touchLocation = [touch locationInView:[touch view]];
    //touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    CGPoint touchLocation = [touch locationInNode:self.parent];
    //NSLog(@"touchLocation x=%f  y=%f",touchLocation.x, touchLocation.y);
    if(_draggable)
    {
        if(touchLocation.y > 480)
        {
            touchLocation.y = 480;
        }
        [_ddelegate updateIconPoint:touchLocation];
        self.position = touchLocation;
    }
    /*
    if(_stayWithinBox && _draggable)
    {
        float x = _stayWithinThisRectWhileDragging.origin.x;
        float y = _stayWithinThisRectWhileDragging.origin.y;
        float w = _stayWithinThisRectWhileDragging.size.width;
        float h = _stayWithinThisRectWhileDragging.size.height;
        float newX = touchLocation.x;
        float newY = touchLocation.y;
        
        if(touchLocation.x < x)
        {
            newX = x;
        }
        else if(touchLocation.x > x + w - self.contentSizeInPoints.width)
        {
            newX = x + w - self.contentSizeInPoints.width;
        }
        if(touchLocation.y < y)
        {
            newY = y;
        }
        else if(touchLocation.y > y + h - self.contentSizeInPoints.height)
        {
            newY = y + h - self.contentSizeInPoints.height;
        }
        self.position = CGPointMake(newX,newY);
    }
    else if(_draggable)
    {
        self.position = touchLocation;
    }
     */
}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if(_draggable)
    {
        //[self doBigAnimation];
        //[self sendTouchNotification];
    }
}
- (void)sendBeginTouch
{
    if(_choosing)
    {
        NSDictionary *touchDict = [NSMutableDictionary
                                   dictionaryWithDictionary:@{
                                                              @"index" : [NSNumber numberWithLong:_index]
                                                            }];
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:@"choosingSpriteTouched" object:nil userInfo:touchDict];
    }
}
- (void)sendTouchNotification
{
    NSDictionary *touchDict = [NSMutableDictionary
                               dictionaryWithDictionary:@{
                            @"stickerName" : self.name,
                            @"stickerX" : [NSNumber numberWithInt:self.positionInPoints.x],
                            @"stickerY" : [NSNumber numberWithInt:self.positionInPoints.y],
                            @"stickerWidth" : [NSNumber numberWithFloat:self.contentSizeInPoints.width],
                            @"stickerHeight" : [NSNumber numberWithFloat:self.contentSizeInPoints.height],
                            @"choosingSprite" : [NSNumber numberWithBool:_choosing],
                            @"index" : [NSNumber numberWithLong:_index]
                                                          }];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:@"newChalkSpriteCoordinates"
                                      object:nil
                                    userInfo:touchDict];
 
}

@end
