//
//  NSURL+WithChanelID.m
//  AboutSex
//
//  Created by Wen Shane on 13-2-1.
//
//

#import "NSURL+WithChanelID.h"
#import "SharedVariables.h"
#import "SharedStates.h"

@implementation NSURL (WithChanelID)

+ (id)MyURLWithString:(NSString *)URLString
{
    if (!URLString)
    {
        return nil;
    }
    NSString* sVersionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleVersion"];
    NSString* sUUID = [[SharedStates getInstance] getUUID];
    
    NSString* sURLStr = [URLString stringByAppendingFormat:@"?version=%@&channel=%@&uuid=%@", sVersionStr, CHANNEL_ID, sUUID];
    NSURL* sURL = [NSURL URLWithString:sURLStr];
    return sURL;
}

@end
