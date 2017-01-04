//
//  HomeScene.h
//  john
//
//  Created by John Reine on 3/11/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "LineDraw.h"

#ifdef ANDROID
#import <AndroidKit/AndroidActivity.h>
#endif


@interface HomeScene : CCScene <LineDrawDelegate, NSStreamDelegate>
{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;

    LineDraw *lineDraw;
    CCLabelTTF *titleLabel;
    CCLabelTTF *countdownLabel;
    CCLabelTTF *countdownLabel2;
    NSTimer *refreshTimer;
    
    NSDate *halaFirstKiss;
}
+ (HomeScene *)scene;
- (id)init;
- (void)hideCountDown;
- (void)showCountDown;

@end
