//
//  LineDraw.m
//  JOHN
//
//  Created by John Reine on 3/13/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "LineDraw.h"
#import "CCDragSprite.h"
#import "XMLDictionary.h"
#import "GlobalDataManager.h"
#define BUF_SIZE 1000
@implementation LineDraw

- (id)init
{
    self = [super init];
    if (self)
    {
        self.userInteractionEnabled = true;
        GlobalDataManager *globalDataManager = [GlobalDataManager sharedManager];
        lastIndex = 0;
        meConnected = false;
        herConnected = false;
        dropZone = CGRectMake(0,0,self.contentSizeInPoints.width, self.contentSizeInPoints.height);
        NSLog(@"dropzone w=%f  h=%f",self.contentSizeInPoints.width, self.contentSizeInPoints.height);
        
        lineWidth = 2.0;
        drawing = false;
        drawNode = [[CCDrawNode alloc] init];
        [self addChild: drawNode];
        
        clearButton = [CCButton buttonWithTitle:@"clear" fontName:@"Arial" fontSize:18.0f];
        clearButton.positionType = CCPositionTypeNormalized;
        clearButton.scale = 1.0;
        clearButton.opacity = 0.50;
        clearButton.color = [CCColor grayColor];
        clearButton.position = ccp(0.08f, 0.03f);
        [clearButton setTarget:self selector:@selector(onClearClicked:)];
        [self addChild:clearButton];
        clearButton.visible = false;
        
        colorButton = [CCButton buttonWithTitle:@"color" fontName:@"Arial" fontSize:18.0f];
        colorButton.positionType = CCPositionTypeNormalized;
        colorButton.scale = 1.0;
        colorButton.opacity = 0.50;
        colorButton.color = [CCColor grayColor];
        colorButton.position = ccp(0.25f, 0.03f);
        [colorButton setTarget:self selector:@selector(onColorClicked:)];
        [self addChild:colorButton];
        colorButton.visible = false;

        sendButton = [CCButton buttonWithTitle:@"logout" fontName:@"Arial" fontSize:18.0f];
        sendButton.positionType = CCPositionTypeNormalized;
        sendButton.scale = 1.0;
        sendButton.opacity = 0.50;
        sendButton.color = [CCColor grayColor];
        sendButton.position = ccp(0.93f, 0.03f);
        [sendButton setTarget:self selector:@selector(onSendClicked:)];
        [self addChild:sendButton];
        sendButton.visible = false;

        sprite = [CCDragSprite spriteWithImageNamed:@"hala.png"];
        //sprite.positionType = CCPositionTypeNormalized;
        sprite.position = ccp(233.0f, 350.0f);

        //sprite.anchorPoint = ccp(0.0,0.0);
        sprite.name = @"hala";
        sprite.stayWithinBox = false;
        sprite.stayWithinThisRectWhileDragging = dropZone;
        sprite.index = 1;
        sprite.scale = 0.15;
        if([sprite.name isEqualToString: globalDataManager.myName])
        {
            sprite.draggable = true;
        }
        else
        {
            sprite.draggable = false;
        }
        sprite.choosing = false;
        sprite.ddelegate = self;
        sprite.visible = false;
        //[sprite beginAnimating];
        [self addChild:sprite];
        

        sprite2 = [CCDragSprite spriteWithImageNamed:@"john.png"];
        sprite2.position = ccp(77.0f, 350.0f);
        //sprite2.anchorPoint = ccp(0.0,0.0);
        sprite2.name = @"john";
        sprite2.stayWithinBox = false;
        sprite2.stayWithinThisRectWhileDragging = dropZone;
        sprite2.index = 2;
        sprite2.scale = 0.15;
        if([sprite2.name isEqualToString: globalDataManager.myName])
        {
            sprite2.draggable = true;
        }
        else
        {
            sprite2.draggable = false;
        }
        sprite2.ddelegate = self;
        sprite2.choosing = false;
        sprite2.visible = false;
        //[sprite beginAnimating];
        [self addChild:sprite2];
        
        clientSocket = [[AsyncSocket alloc] initWithDelegate:self];
        [clientSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        
        [self connectHost:@"45.56.109.197" port:9988];
        
        messages = [[NSMutableArray alloc] initWithCapacity:1];
        
        NSData *cmdData = [globalDataManager.myName dataUsingEncoding:NSUTF8StringEncoding];
        [clientSocket writeData:cmdData withTimeout:-1 tag:0];
        
        points = [[NSMutableArray alloc] initWithCapacity:BUF_SIZE];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AndroidKeyEventKeycodeBack:) name:@"AndroidKeyEventKeycodeBack" object: nil];
        
        refresh = [self createTimer];
        pingTimer = [self createNetworkPingTimer];
        
        colorArray = [[NSMutableArray alloc] initWithObjects:[CCColor redColor],[CCColor blueColor],[CCColor greenColor],nil];

    }
    
    return self;
}

- (void)AndroidKeyEventKeycodeBack:(NSNotification *)notification;
{
    if ([[notification name] isEqualToString:@"AndroidKeyEventKeycodeBack"])
    {
        //NSDictionary *data = [notification userInfo];
        NSLog(@"AndroidKeyEventKeycodeBack");
        [self logout];
    }
}
- (void)onExitTransition
{
    NSLog(@"EXITING");
    [clientSocket disconnect];
}
- (void)showColorWheel
{
   
}

- (void)meDisconnectedToServer
{
    sendButton.visible = true;
    sprite.visible = false;
    sprite2.visible = false;
}
- (void)meConnectedToServer
{
    GlobalDataManager *globalDataManager = [GlobalDataManager sharedManager];
    sendButton.visible = true;
    if([sprite2.name isEqualToString: globalDataManager.myName])
    {
        sprite2.visible = true;
    }
    else
    {
        sprite2.visible = false;
    }
    if([sprite.name isEqualToString: globalDataManager.myName])
    {
        sprite.visible = true;
    }
    else
    {
        sprite.visible = false;
    }
}
- (void)herConnectedToServer
{
    GlobalDataManager *globalDataManager = [GlobalDataManager sharedManager];
    
    NSString *message = [NSString stringWithFormat:@"<root><name>%@</name><connection>connected</connection></root>", globalDataManager.myName];
    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
    [clientSocket writeData:cmdData withTimeout:-1 tag:0];
    
    [[OALSimpleAudio sharedInstance] playEffect:SOUND_CHEER];

    if([sprite2.name isEqualToString: globalDataManager.herName])
    {
        sprite2.visible = true;
    }
    else if([sprite.name isEqualToString: globalDataManager.herName])
    {
        sprite.visible = true;
    }
}
- (void)herDisconnectedToServer
{
    GlobalDataManager *globalDataManager = [GlobalDataManager sharedManager];
    
    if([sprite2.name isEqualToString: globalDataManager.herName])
    {
        sprite2.visible = false;
    }
    else if([sprite.name isEqualToString: globalDataManager.herName])
    {
        sprite.visible = false;
    }
    
}

- (void)connectHost:(NSString *)ip port:(NSUInteger)port
{
    if (![clientSocket isConnected])
    {
        NSError *error = nil;
        [clientSocket connectToHost:ip onPort:port withTimeout:-1 error:&error];
        if (error)
        {
            NSLog(@"connectToHost error %@",error);
            [clientSocket disconnect];
        }
        else
        {
            NSLog(@"connected!!!!!!!!!!!!!");
            
        }
    }
}

- (void)clearDrawing
{
    [drawNode clear];
    [_delegate showCountDown];
    sendButton.visible = true;
    clearButton.visible = false;
    //colorButton.visible = false;
    drawing = false;
}
- (void)onClearClicked:(id)sender
{
    
    [self updateDrawingPoint:CGPointMake(0.0,0.0) type:@"drawCleared"];
    [self clearDrawing];
}

- (void)onColorClicked:(id)sender
{
    
    for(int x=0; x< [colorArray count]; x++)
    {
        CCButton *tempButton = [CCButton buttonWithTitle:@"" spriteFrame:<#(CCSpriteFrame *)#>]
        //[CCButton buttonWithTitle:@"" fontName:@"Arial" fontSize:18.0f];
    }
    colorButton = [CCButton buttonWithTitle:@"color" fontName:@"Arial" fontSize:18.0f];
    colorButton.positionType = CCPositionTypeNormalized;
    colorButton.scale = 1.0;
    colorButton.opacity = 0.50;
    colorButton.color = [CCColor grayColor];
    colorButton.position = ccp(0.25f, 0.03f);
    [colorButton setTarget:self selector:@selector(onColorClicked:)];
    [self addChild:colorButton];
    colorButton.visible = false;

}

- (void)logout
{
    [clientSocket disconnect];
    meConnected = false;
    herConnected = false;
    colorButton.visible = false;
    [sendButton setTitle:@"login"];
}
- (void)onSendClicked:(id)sender
{
    if(meConnected)
    {
        [self logout];
    }
    else
    {
        [sendButton setTitle:@"logout"];
        [self connectHost:@"45.56.109.197" port:9988];
        GlobalDataManager *globalDataManager = [GlobalDataManager sharedManager];
        NSData *cmdData = [globalDataManager.myName dataUsingEncoding:NSUTF8StringEncoding];
        [clientSocket writeData:cmdData withTimeout:-1 tag:0];
        
    }
    /*
    [drawNode clear];
    [_delegate showCountDown];
    sendButton.visible = false;
    clearButton.visible = false;
    [saveTexture begin];
    [drawNode visit];
    [saveTexture end];
#ifdef ANDROID
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"shityea"];
    CGImageRef imageRef = [saveTexture newCGImage];
    if( ! imageRef ) {
        CCLOG(@"cocos2d: Error: Cannot create CGImage ref from texture");
   	}
    
#else
    [saveTexture saveToFile:@"shityea3.png" format:CCRenderTextureImageFormatPNG];
#endif
    //CGImageRef *image = [saveTexture newCGImage];
    drawing = false;
    
    //get the screenshot as raw data
    //NSData *data = [NSData dataWithContentsOfFile:@"shityea.png"];
    //create an image from the raw data
    //UIImage *img = [UIImage imageWithData:data];
    //save the image to the users Photo Library
    //UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
     */
}


-(NSString*) screenshotPathForFile:(NSString *)file
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* screenshotPath = [documentsDirectory
                                stringByAppendingPathComponent:file];
    NSLog(@"stored: %@", screenshotPath);
    return screenshotPath;
}
- (void)pingTimerTicked:(NSTimer*)timer
{
    if(!herConnected && meConnected)
    {
        GlobalDataManager *globalDataManager = [GlobalDataManager sharedManager];

        NSString *message = [NSString stringWithFormat:@"<root><name>%@</name><connection>connected</connection></root>", globalDataManager.myName];
        NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
        [clientSocket writeData:cmdData withTimeout:-1 tag:0];
    }
    else if(!meConnected)
    {
        [self meDisconnectedToServer];
        
    }
}
- (void)timerTicked:(NSTimer*)timer
{
    int x = 0;
    while([points count] > 0)
    {
        NSDictionary * dict = [points objectAtIndex:x];
        NSString *type = [dict valueForKeyPath:@"type"];
        if([type isEqualToString: @"drawMoved"])
        {
             NSString *xval = [dict valueForKeyPath:@"x"];
             NSString *yval = [dict valueForKeyPath:@"y"];
             //NSLog(@"draw: %@  %@",xval, yval);
             [self drawPointOnScreen:CGPointMake([xval floatValue], [yval floatValue])];
        }
        else if([type isEqualToString: @"drawBegan"])
        {
             NSString *xval = [dict valueForKeyPath:@"x"];
             NSString *yval = [dict valueForKeyPath:@"y"];
             //NSLog(@"draw: %@  %@",xval, yval);
             lastPoint = CGPointMake([xval floatValue], [yval floatValue]);
             [self drawPointOnScreen:lastPoint];
        }
        else if([type isEqualToString: @"drawEnded"])
        {
             NSString *xval = [dict valueForKeyPath:@"x"];
             NSString *yval = [dict valueForKeyPath:@"y"];
             //NSLog(@"draw: %@  %@",xval, yval);
             [self drawPointOnScreen:CGPointMake([xval floatValue], [yval floatValue])];
        }
        [points removeObjectAtIndex:x];
    }
    
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    if(herConnected)
    {
        lastPoint = location;
    
        [self updateDrawingPoint:location type:@"drawBegan"];
        [self drawPointOnScreen:location];
        [self prepareForDrawing];
    }
}

- (void)prepareForDrawing
{
    if(drawing == false)
    {
        clearButton.visible = true;
        colorButton.visible = true;
        sendButton.visible = true;
        [_delegate hideCountDown];
        drawing = true;
        //saveTexture = [[CCRenderTexture alloc] initWithWidth:self.contentSizeInPoints.width height:self.contentSizeInPoints.height pixelFormat:CCTexturePixelFormat_RGBA8888];
    }

}
- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if (ccpDistance(lastPoint, location) > 12 && herConnected)
    {
        if(location.y > 480)
        {
            location.y = 480;
        }
        [self updateDrawingPoint:location type:@"drawMoved"];
        [self drawPointOnScreen:location];
    }
}
- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    if(herConnected)
    {
        [self updateDrawingPoint:location type:@"drawEnded"];
        [self drawPointOnScreen:location];
    }
}

- (void)drawPointOnScreen:(CGPoint)p
{
    
    [self drawCurPoint:p PrevPoint:lastPoint];
    lastPoint = p;
    [self prepareForDrawing];

}

- (void) drawCurPoint:(CGPoint)curPoint PrevPoint:(CGPoint)prevPoint
{
    //ccColor4F red = ccc4f(209.0/255.0, 75.0/255.0, 75.0/255.0, 1.0);
    
    //These lines will calculate 4 new points, depending on the width of the line and the saved points
    CGPoint dir = ccpSub(curPoint, prevPoint);
    CGPoint perpendicular = ccpNormalize(ccpPerp(dir));
    CGPoint A = ccpAdd(prevPoint, ccpMult(perpendicular, lineWidth / 2));
    CGPoint B = ccpSub(prevPoint, ccpMult(perpendicular, lineWidth / 2));
    CGPoint C = ccpAdd(curPoint, ccpMult(perpendicular, lineWidth / 2));
    CGPoint D = ccpSub(curPoint, ccpMult(perpendicular, lineWidth / 2));
    
    CGPoint poly[4] = {A, C, D, B};
    
    //Then draw the poly, and a circle at the curPoint to get smooth corners
    //ccDrawSolidPoly(poly, 4, red);
    //ccDrawSolidCircle(curPoint, lineWidth/2.0, 20);
    
    [drawNode drawPolyWithVerts:poly count:4 fillColor:[CCColor yellowColor] borderWidth:lineWidth borderColor:[CCColor redColor]];
    //[drawNode drawDot:curPoint radius:lineWidth/2.0 color:[CCColor blueColor]];
    
}

- (void) drawDot
{
    if ([points count] > 0) {
        //ccGLEnable(GL_LINE_STRIP);
        
        //ccColor4F red = ccc4f(209.0/255.0, 75.0/255.0, 75.0/255.0, 1.0);
        //ccDrawColor4F(red.r, red.g, red.b, red.a);
        ccColor3B red = ccc3(209.0/255.0, 75.0/255.0, 75.0/255.0);
        
        float _lineWidth = 6.0 * __ccContentScaleFactor;
        
        glLineWidth(_lineWidth);
        
        int count = [points count];
        
        for (int i = 0; i < (count - 1); i++){
            CGPoint pos1 = [[points objectAtIndex:i] CGPointValue];
            CGPoint pos2 = [[points objectAtIndex:i+1] CGPointValue];
            
            [self drawCurPoint:pos2 PrevPoint:pos1];
        }
    }
}

-(void)updateDrawingPoint:(CGPoint)p type:(NSString *)t
{
#ifndef ANDROID
    //NSString *message = NSStringFromCGPoint(p);
    NSString *message = [NSString stringWithFormat:@"<root><name>hala</name><type>%@</type><x>%.2f</x><y>%.2f</y></root>", t, p.x, p.y];
    //NSLog(@"IOS sending: %@",message);
#else
    //NSString *message = [NSString stringWithFormat:@"{%.2f,%.2f}", p.x, p.y];
    NSString *message = [NSString stringWithFormat:@"<root><name>john</name><type>%@</type><x>%.2f</x><y>%.2f</y></root>", t, p.x, p.y];
    //NSLog(@"Android sending: %@",message);
    //NSString *message = @"boo"; //"NSStringFromCGPoint(p);
#endif
    
    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
    [clientSocket writeData:cmdData withTimeout:-1 tag:0];
    
}
-(void)updateIconPoint:(CGPoint)p
{
    
#ifndef ANDROID
    //NSString *message = NSStringFromCGPoint(p);
    NSString *message = [NSString stringWithFormat:@"<root><name>hala</name><type>icon</type><x>%.2f</x><y>%.2f</y></root>", p.x, p.y];
    //NSLog(@"IOS sending: %@",message);
#else
    //NSString *message = [NSString stringWithFormat:@"{%.2f,%.2f}", p.x, p.y];
    NSString *message = [NSString stringWithFormat:@"<root><name>john</name><type>icon</type><x>%.2f</x><y>%.2f</y></root>", p.x, p.y];
    //NSLog(@"Android sending: %@",message);
    //NSString *message = @"boo"; //"NSStringFromCGPoint(p);
#endif

    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
    [clientSocket writeData:cmdData withTimeout:-1 tag:0];
    //[messages insertObject:[NSString stringWithFormat:@"client:%@",message] atIndex:0];
    
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    GlobalDataManager *globalDataManager = [GlobalDataManager sharedManager];
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"MSG: %@", msg);
    
    NSDictionary * dict = [NSDictionary dictionaryWithXMLString:msg];
    if(dict != nil)
    {
        NSString *name = [dict valueForKeyPath:@"name"];
        if([name isEqualToString: globalDataManager.myName])
        {
            NSString *type = [dict valueForKeyPath:@"type"];
            if([type isEqualToString: @"icon"])
            {
                NSString *xval = [dict valueForKeyPath:@"x"];
                NSString *yval = [dict valueForKeyPath:@"y"];
                NSLog(@"moveicon: %@  %@",xval, yval);
                if([name isEqualToString: sprite2.name])
                {
                    sprite.positionInPoints = CGPointMake([xval floatValue], [yval floatValue]);
                }
                else if([name isEqualToString: sprite.name])
                {
                    sprite2.positionInPoints = CGPointMake([xval floatValue], [yval floatValue]);
                }
            }
            else if([type isEqualToString: @"drawMoved"])
            {
                [points addObject:dict];
            }
            else if([type isEqualToString: @"drawBegan"])
            {
                [points addObject:dict];
               
            }
            else if([type isEqualToString: @"drawEnded"])
            {
                [points addObject:dict];
                
            }
            else if([type isEqualToString: @"drawCleared"])
            {
                [self clearDrawing];
            }
            else if(!meConnected)
            {
                NSString *con = [dict valueForKeyPath:@"connection"];
                if([con isEqualToString: @"connected"])
                {
                    NSLog(@"me CONNECTED");
                    meConnected = true;
                    [self meConnectedToServer];
                }
            }
        }
        else if([name isEqualToString: globalDataManager.herName])
        {
            NSString *con = [dict valueForKeyPath:@"connection"];
            if([con isEqualToString: @"connected"] && !herConnected)
            {
                NSLog(@"her CONNECTED");
                herConnected = true;
                [self herConnectedToServer];
            }
            else if([con isEqualToString: @"disconnected"])
            {
                NSLog(@"her  NOT CONNECTED");
                herConnected = false;
                [self herDisconnectedToServer];
            }
        }
    }
    
    [sock readDataWithTimeout:-1 tag:0];
}

-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //NSLog(@"client didWriteDataWithTag:%ld",tag);
    [sock readDataWithTimeout:-1 tag:0];
}


- (NSTimer*)createTimer
{
    return [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
}

- (NSTimer*)createNetworkPingTimer
{
    return [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(pingTimerTicked:) userInfo:nil repeats:YES];
}
@end
