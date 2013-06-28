//
//  SpotTimer.m
//  AboutSex
//
//  Created by Wen Shane on 13-5-14.
//
//

#import "SpotTimer.h"
#import "AdSpotManager.h"


#define SPOT_TIMER_TIME_INTERVAL 30
#define MAX_SPOT_TIMES      2

@interface SpotTimer()
{
    NSTimer* mTimer;
    NSInteger mSpotTimes;
}

@property (nonatomic, retain) NSTimer* mTimer;
@property (nonatomic, assign) NSInteger mSpotTimes;
@end

@implementation SpotTimer
@synthesize mTimer;
@synthesize mSpotTimes;


+ (void) initialize
{
    [AdSpotManager spotAdapter];
}

+ (SpotTimer*) shared
{
    static SpotTimer*  S_SpotTimer = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        S_SpotTimer = [[self alloc] init];
    });
    
    return S_SpotTimer;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        self.mSpotTimes = 0;
    }
    return self;
}

- (void) dealloc
{
    [self.mTimer invalidate];
    self.mTimer = nil;
    
    [super dealloc];
}

- (BOOL) startWithDelay:(NSTimeInterval)aDelay
{
    if (self.mSpotTimes >= MAX_SPOT_TIMES)
    {
        [self.mTimer invalidate];
        return NO;
    }
    
    NSLog(@"spot timer start...");
    
    if (self.mTimer)
    {
        [self.mTimer invalidate];
    }
    
    NSTimer* sTimer = [NSTimer scheduledTimerWithTimeInterval:aDelay target:self selector:@selector(showSpot) userInfo:nil repeats:NO];
    
    self.mTimer = sTimer;
    
    return YES;

}

- (void) cancel
{
    NSLog(@"spot timer cancelled...");
    if (self.mTimer)
    {
        [self.mTimer invalidate];
    }
}

- (void) showSpot
{
    if (self.mSpotTimes >= MAX_SPOT_TIMES)
    {
        [self.mTimer invalidate];
        return;
    }

    NSLog(@"spot timer show spot...%d", self.mSpotTimes);
    [[AdSpotManager spotAdapter] showSpot];
    
    self.mSpotTimes++;
}

@end
