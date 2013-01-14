//
//  MyURLConnection.m
//  AboutSex
//
//  Created by Shane Wen on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyURLConnection.h"

@implementation MyURLConnection

@synthesize mDelegate;
@synthesize mWebData;
@synthesize mRequest;
@synthesize mURLConnection;

- (id) initWithDelegate: (NSMutableURLRequest*)aRequest withDelegate:(id<MyURLConnectionDelegate>) aDelegate
{
    self = [super init];
    if (self)
    {
        self.mRequest = aRequest;
        self.mDelegate = aDelegate;
    }
    return self;
}


- (void) dealloc
{
    self.mDelegate = nil;
    self.mWebData = nil;
    self.mRequest = nil;
    self.mURLConnection = nil;
    
    [super dealloc];
}

- (BOOL) start
{
    BOOL sRet = NO;
    
    NSURLConnection* sURLConnection = [[NSURLConnection alloc] initWithRequest:self.mRequest delegate:self startImmediately:YES];
    
    if (sURLConnection)
    {
        self.mWebData = [NSMutableData data];
        sRet = YES;
    }
    else 
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];   
        sRet = NO;
    }
    
    self.mURLConnection = sURLConnection;
    [sURLConnection release];
    
    return sRet;
}

- (void) stop
{
    if (self.mURLConnection)
    {
        [self.mURLConnection cancel];
    }
}

#pragma mark -
#pragma mark delegate methods for NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *sHTTPResponse = (NSHTTPURLResponse *)response;
    NSInteger sStatusCode = [sHTTPResponse statusCode];
    if (404 == sStatusCode
        || 500 == sStatusCode)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; 
        [connection cancel];
        if ([self.mDelegate respondsToSelector:@selector(failWithServerError:)])
        {
            [[self mDelegate] failWithServerError:sStatusCode];
        }
#ifdef DEBUG
        NSLog(@"server error.");
#endif
    }
    else 
    {
        [self.mWebData setLength:0];
    }
    
    return;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.mWebData appendData:data];
    return;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if ([self.mDelegate respondsToSelector:@selector(succeed:)])
    {
        [self.mDelegate succeed:self.mWebData];
    }
    self.mWebData = nil;
    return;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
#ifdef  DEBUG
    NSLog(@"urlconnection failure!");
#endif
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; 
    if ([self.mDelegate respondsToSelector:@selector(failWithConnectionError:)])
    {
        [self.mDelegate failWithConnectionError:error];
    }
    return;
}


@end
