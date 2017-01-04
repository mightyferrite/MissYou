//
//  HomeScene.m
//  john
//
//  Created by John Reine on 3/11/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "HomeScene.h"
#import "GlobalDataManager.h"

#ifdef ANDROID
#import <AndroidKit/AndroidAlertDialogBuilder.h>
#endif
@implementation HomeScene

+ (HomeScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    [[OALSimpleAudio sharedInstance] preloadEffect:SOUND_CHEER];

    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
    [self addChild:background];
    
    titleLabel = [CCLabelTTF labelWithString:@"Countdown"
                                     fontName:@"Verdana"
                                     fontSize:20.0f];
    titleLabel.positionType = CCPositionTypeNormalized;
    titleLabel.color = [CCColor yellowColor];
    titleLabel.position = ccp(0.5f, 0.9f);
    titleLabel.visible = false;
    [self addChild:titleLabel];
    
    countdownLabel = [CCLabelTTF labelWithString:@""
                                    fontName:@"Verdana"
                                    fontSize:20.0f];
    countdownLabel.positionType = CCPositionTypeNormalized;
    countdownLabel.color = [CCColor yellowColor];
    countdownLabel.position = ccp(0.5f, 0.5f);
    countdownLabel.horizontalAlignment = CCTextAlignmentCenter;
    [self addChild:countdownLabel];

    countdownLabel2 = [CCLabelTTF labelWithString:@""
                                        fontName:@"Verdana"
                                        fontSize:20.0f];
    countdownLabel2.positionType = CCPositionTypeNormalized;
    countdownLabel2.color = [CCColor yellowColor];
    countdownLabel2.position = ccp(0.5f, 0.45f);
    countdownLabel2.horizontalAlignment = CCTextAlignmentCenter;
    [self addChild:countdownLabel2];
    
    lineDraw = [[LineDraw alloc] init];
    lineDraw.contentSizeInPoints = self.contentSizeInPoints;
    lineDraw.positionType = CCPositionTypeNormalized;
    lineDraw.delegate = self;
    //lineDraw.position = ccp(0.5,0.5);
    [self addChild:lineDraw];
    
    //[self initNetworkCommunication];
    
    refreshTimer = [self createTimer];
        
    return self;
}



- (void)timerTicked:(NSTimer*)timer
{
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 2015;
    dateComponents.month = 3;
    dateComponents.day = 25;
    dateComponents.hour = 8;
    dateComponents.minute = 0;
    dateComponents.second = 0;
    
    NSDate *referenceDate = [gregorian dateFromComponents: dateComponents];
    
    NSDate *now = [NSDate date];

    NSTimeInterval interval = [now timeIntervalSinceDate:referenceDate];
    if(interval < 0)
    {
        interval = -interval;
    }
    unsigned int seconds = (unsigned int)round(interval);
    /*
    NSInteger seconds = sec;
    NSInteger remainder = seconds % 3600;
    NSInteger hours = seconds / 3600;
    NSInteger minutes = remainder / 60;
    NSInteger forSeconds = remainder % 60;
    */
    int days = seconds / (60 * 60 * 24);
    seconds -= days * (60 * 60 * 24);
    int hours = seconds / (60 * 60);
    seconds -= hours * (60 * 60);
    int minutes = seconds / 60;
    seconds -= minutes * 60;
    
    [countdownLabel setString:[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%d days", days]]];
    [countdownLabel2 setString:[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%d hours %02d min %02d sec", hours, minutes, seconds]]];
}

- (void)hideCountDown
{
    countdownLabel.visible = false;
    countdownLabel2.visible = false;
    
    /*
    NSString *response  = @"iam:john";
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    */
}

-(void)showCountDown
{
    countdownLabel.visible = true;
    countdownLabel2.visible = true;
}

- (void)initNetworkCommunication
{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"45.56.109.197", 3333, &readStream, &writeStream);
    inputStream = (NSInputStream *)CFBridgingRelease(readStream);
    outputStream = (NSOutputStream *)CFBridgingRelease(writeStream);
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    //[inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //[outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

    [inputStream open];
    [outputStream open];
    
    if (readStream)
        CFRelease(readStream);
    
    if (writeStream)
        CFRelease(writeStream);
}

- (NSTimer*)createTimer
{
    return [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
}


@end
