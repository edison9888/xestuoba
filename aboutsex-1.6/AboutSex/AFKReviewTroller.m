//
//  AFKReviewTroller.m
//  AFKReviewTroller
//
//  Created by Marco Tabini on 11-02-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AFKReviewTroller.h"
#import "SharedStates.h"
#import "MobClick.h"

#define kAFKReviewTrollerRunCountDefault @"kAFKReviewTrollerRunCountDefault"


@implementation AFKReviewTroller

+ (void) load {
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
        
    int numberOfExecutions = [standardDefaults integerForKey:kAFKReviewTrollerRunCountDefault] + 1;
    
    [[[AFKReviewTroller alloc] initWithNumberOfExecutions:numberOfExecutions] performSelector:@selector(setup) withObject:Nil afterDelay:1.0];
    
    [standardDefaults setInteger:numberOfExecutions forKey:kAFKReviewTrollerRunCountDefault];
    [standardDefaults synchronize];

    [pool release];
}


+ (int) numberOfExecutions {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kAFKReviewTrollerRunCountDefault];
}


- (id) initWithNumberOfExecutions:(int) executionCount {
    if ((self = [super init])) {
        numberOfExecutions = executionCount;
    }
    
    return self;
}


- (void) setup {
    NSDictionary *bundleDictionary = [[NSBundle mainBundle] infoDictionary];
    if (numberOfExecutions == [[bundleDictionary objectForKey:kAFKReviewTrollerRunCount] intValue]
         && [[SharedStates getInstance] getCommentURL].length > 0 )
    {
        NSString *title = NSLocalizedString(@"Review me, please.", nil);
        NSString *message = NSLocalizedString(@"Would you like to review AboutSex?", Nil);
        
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:title 
                                                             message:message 
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"No", Nil) 
                                                   otherButtonTitles:NSLocalizedString(@"Yes", Nil), Nil] 
                                  autorelease];
        [alertView show];
    }
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[SharedStates getInstance] getCommentURL]]];
        
        NSDictionary* sDict = [NSDictionary dictionaryWithObject:@"YES" forKey:@"Accept"];
        [MobClick event:@"UEID_PASSIVE_COMMENT" attributes: sDict];
    }
    else if (buttonIndex == 0)
    {
        NSDictionary* sDict = [NSDictionary dictionaryWithObject:@"NO" forKey:@"Accept"];
        [MobClick event:@"UEID_PASSIVE_COMMENT" attributes: sDict];
    }
    else
    {
        
    }
}


- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self release];
}


@end
