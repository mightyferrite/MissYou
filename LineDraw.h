//
//  LineDraw.h
//  JOHN
//
//  Created by John Reine on 3/13/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AsyncSocket.h"
#import "CCDragSprite.h"

@protocol LineDrawDelegate <NSObject>
@required
-(void)hideCountDown;
-(void)showCountDown;
@end

@interface LineDraw : CCNode <CCDragSpriteDelegate, AsyncSocketDelegate>
{
    id <LineDrawDelegate> _delegate;
    float lineWidth;
    CCDrawNode* drawNode;
    NSMutableArray *points;
    CGPoint lastPoint;
    
    NSTimer *refresh;
    CGRect dropZone;
    CCButton *clearButton;
    CCButton *sendButton;
    CCButton *colorButton;
    NSTimer *pingTimer;
    bool drawing;
    CCDragSprite *sprite;
    CCDragSprite *sprite2;
    AsyncSocket *clientSocket;
    NSMutableArray *messages;
    NSMutableArray *colorArray;
    CCRenderTexture *saveTexture;
    bool meConnected;
    bool herConnected;
    NSInteger lastIndex;
    NSInteger maxBuf;
    NSInteger currentWritePosition;
}
@property (nonatomic,strong) id delegate;
- (id)init;
-(void)updateIconPoint:(CGPoint)p;
-(NSString*) screenshotPathForFile:(NSString *)file;


@end
