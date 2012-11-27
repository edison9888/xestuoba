//
//  NewStreamSniffer.m
//  AboutSex
//
//  Created by Shane Wen on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewStreamSniffer.h"
#import "MyURLConnection.h"
#import "SharedVariables.h"


#define SECONDS_OF_SNIFFER_STARTING_WORK_SINCE_CONSTRUCT (3*60)
//#define SECONDS_OF_SNIFFER_STARTING_WORK_SINCE_CONSTRUCT (10)

#define SECONDS_OF_SINFFER_INTERVAL (5*60)
//#define SECONDS_OF_SINFFER_INTERVAL (10)


@interface NewStreamSniffer ()
{
    NSTimer* mTimer;
    NSMutableURLRequest* mRequest;
}
@property (nonatomic, retain) NSTimer* mTimer;
@property (nonatomic, retain) NSMutableURLRequest* mRequest;

- (void) getNewStreamNumber;

@end

@implementation NewStreamSniffer

@synthesize mDelegate; 
@synthesize mTimer;
@synthesize mRequest;


- (id) initWithDelegate: (id<NewStreamSnifferDelegate>) aDelegate
{
    self = [super init];
    if (self)
    {
        self.mDelegate = aDelegate;
    }
    return self;
}

- (void) dealloc
{
    self.mTimer = nil;
    self.mRequest = nil;
    [super dealloc];
}

- (void) start
{
    if (!self.mTimer)
    {
        mTimer = [[NSTimer alloc]initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:SECONDS_OF_SNIFFER_STARTING_WORK_SINCE_CONSTRUCT]  interval:SECONDS_OF_SINFFER_INTERVAL target:self selector:@selector(getNewStreamNumber) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:mTimer forMode:NSDefaultRunLoopMode];
    }

}

- (void) getNewStreamNumber
{
    if (!self.mRequest)
    {
        NSMutableURLRequest* sRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:GET_NEW_STREAM_NUMBER_URL_STR]];
        [sRequest setHTTPMethod:@"POST"];
        self.mRequest = sRequest;
        [sRequest release];
    }
    
    NSTimeInterval sStartingTime = [[self.mDelegate getStartingDate] timeIntervalSince1970];
    NSMutableDictionary* sStartingTimeDict = [NSMutableDictionary dictionary];
    [sStartingTimeDict setValue:[NSNumber numberWithDouble:sStartingTime] forKey:@"startingTime"];
    
    NSError* sErr = nil;
    NSData* sData = [NSJSONSerialization dataWithJSONObject:sStartingTimeDict options:NSJSONReadingMutableContainers error:&sErr];
    
    [self.mRequest setHTTPBody:sData];
    [self.mRequest setValue:[NSString stringWithFormat:@"%d", [sData length]] forHTTPHeaderField:@"Content-length"];

    
    MyURLConnection* sURLConnection = [[MyURLConnection alloc]initWithDelegate:self.mRequest withDelegate:self];
    if (![sURLConnection start])
    {
#ifdef DEBUG
        NSLog(@"conncetion creation error.");
#endif
    }
    [sURLConnection release];
    return; 
}
//

- (void) failWithConnectionError: (NSError*)aErr
{
    return;
}

- (void) failWithServerError: (NSInteger)aStatusCode
{
    return;
}

- (void) succeed: (NSMutableData*)aData
{
    NSError* sErr = nil;
    
    //api for json is only available on ios 5.0 and later, so you should do it yourself on versions before 5.0.
    id sJSONObject =  [NSJSONSerialization JSONObjectWithData: aData 
                                                      options:NSJSONReadingMutableContainers
                                                        error:&sErr];
    if ([sJSONObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *sDict = (NSDictionary *)sJSONObject;
        NSInteger sNumOfNewStreams = [(NSNumber*)[sDict objectForKey:@"numOfNewStream"] integerValue];
        
        [self.mDelegate newStreamFound:sNumOfNewStreams];
    }     
    return;
}


@end
