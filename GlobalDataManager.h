//
//  GlobalDataManager.h
//  MissYou
//
//  Created by John Reine on 3/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USERDATA_VERSION        1
#define SOUND_CHEER @"yee_hah_1.wav"

@interface GlobalDataManager : NSObject
{
    
}

+ (id)sharedManager;

@property NSString *emailAddress;
@property NSString *emailKey;
@property NSString *dateKey;

@property NSString *myName;
@property NSString *herName;

@end
