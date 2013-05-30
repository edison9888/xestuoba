//
//  NewStreamSniffer.m
//  AboutSex
//
//  Created by Shane Wen on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewStreamSniffer.h"
#import "SharedVariables.h"
#import "AFNetworking.h"
#import "NSURL+WithChanelID.h"
#import "JSONWrapper.h"


#define SECONDS_OF_SNIFFER_STARTING_WORK_SINCE_CONSTRUCT (3*60)
//#define SECONDS_OF_SNIFFER_STARTING_WORK_SINCE_CONSTRUCT (10)

#define SECONDS_OF_SINFFER_INTERVAL (5*60)
//#define SECONDS_OF_SINFFER_INTERVAL (10)


@interface NewStreamSniffer ()
{
    NSTimer* mTimer;
}
@property (nonatomic, retain) NSTimer* mTimer;

- (void) getNewStreamNumber;

@end

@implementation NewStreamSniffer

@synthesize mDelegate; 
@synthesize mTimer;


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
    NSTimeInterval sStartingTime = [[self.mDelegate getStartingDate] timeIntervalSince1970];
    NSMutableDictionary* sStartingTimeDict = [NSMutableDictionary dictionary];
    [sStartingTimeDict setValue:[NSNumber numberWithDouble:sStartingTime] forKey:@"startingTime"];
    NSError* sErr = nil;
    NSData* sData = [JSONWrapper dataWithJSONObject:sStartingTimeDict options:NSJSONReadingMutableContainers error:&sErr];
    
    NSMutableURLRequest* sRequest = [NSMutableURLRequest requestWithURL:[NSURL MyURLWithString:GET_NEW_STREAM_NUMBER_URL_STR]];
    [sRequest setHTTPMethod:@"POST"];
    [sRequest setHTTPBody:sData];
    [sRequest setValue:[NSString stringWithFormat:@"%d", [sData length]] forHTTPHeaderField:@"Content-length"];
        
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:sRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self postSuccessfully:JSON];
    } failure:^( NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON ){
        //
    }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
    [operation start];
}
//

- (void) postSuccessfully: (id)aJSONObj
{    
    if ([aJSONObj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *sDict = (NSDictionary *)aJSONObj;
        NSInteger sNumOfNewStreams = [(NSNumber*)[sDict objectForKey:@"numOfNewStream"] integerValue];
                
        [self.mDelegate newStreamFound:sNumOfNewStreams];
    }
    
    return;
}


@end
