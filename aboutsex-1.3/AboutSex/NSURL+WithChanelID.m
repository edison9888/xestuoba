//
//  NSURL+WithChanelID.m
//  AboutSex
//
//  Created by Wen Shane on 13-2-1.
//
//

#import "NSURL+WithChanelID.h"
#import "SharedVariables.h"

@implementation NSURL (WithChanelID)

+ (id)MyURLWithString:(NSString *)URLString
{
    if (!URLString)
    {
        return nil;
    }
    
    NSString* sURLStr = [URLString stringByAppendingFormat:@"?channed_id=%@", CHANNEL_ID];
    NSURL* sURL = [NSURL URLWithString:sURLStr];
    return sURL;
}

@end
