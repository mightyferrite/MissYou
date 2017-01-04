//
//  GlobalDataManager.m
//  MissYou
//
//  Created by John Reine on 3/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GlobalDataManager.h"

@implementation GlobalDataManager

+ (id)sharedManager
{
    static GlobalDataManager *globalDataManager = nil;
    @synchronized(self)
    {
        if (globalDataManager == nil)
            globalDataManager = [[self alloc] init];
    }
    return globalDataManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
        _dateKey = @"dateKey";
        _emailKey = @"emailKey";
        
        NSDate *lastRead = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:_dateKey];
        _emailAddress = [[NSUserDefaults standardUserDefaults] objectForKey:_emailKey];
        NSString *tt = [[NSUserDefaults standardUserDefaults] objectForKey:_emailKey];
        // [[dict objectForKey:@"max"] integerValue];
        NSInteger userdataVersion = [[[NSUserDefaults standardUserDefaults] objectForKey:@"USERDATA_VERSION"] integerValue];
        if (lastRead == nil)     // App first run: set up user defaults.
        {
            
            
            //[self setupUserDefaults];
        }
        else if(userdataVersion != USERDATA_VERSION)
        {
            //[self setupUserDefaults];
        }
        else
        {
            //[self loadUserDefaults];
        }
        
        if(_myName == nil)
        {
#ifdef ANDROID
            _myName = @"hala";
            _herName = @"john";
#else
            _myName = @"john";
            _herName = @"hala";
#endif
        }
        

        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:_dateKey];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:USERDATA_VERSION] forKey:@"USERDATA_VERSION"];
        
    }
    return self;
}
@end
