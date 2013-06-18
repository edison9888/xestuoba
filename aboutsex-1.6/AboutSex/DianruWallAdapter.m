////
////  DianruWallAdapter.m
////  AboutSex
////
////  Created by Wen Shane on 13-5-9.
////
////
//
//#import "DianruWallAdapter.h"
//#import "DianRuAdWall.h"
//
//#import "SharedVariables.h"
//
//#define DEFAULTS_DIANRU_POINTS      @"Dianru_Current_Points"
//
//@implementation DianruWallAdapter
//
//- (id) init
//{
//    self = [super init];
//    if (self)
//    {
//        [DianRuAdWall initAdWallWithDianRuAdWallDelegate:self];
//    }
//    return self;
//}
//
//- (BOOL) showWall
//{
//    [DianRuAdWall showAdWall:[self.mDelegate presentingViewController]];
//    
//    return YES;
//}
//
//- (void) getEarnedPoints
//{
//    [DianRuAdWall getRemainPoint];
//    return;
//}
//
//
//#pragma mark - DianRuAdWallDelegate
//-(void)didReceiveGetScoreResult:(int)aTotalPoints
//{
//    NSLog(@"--!!!!--Dianru---did receive earned points");
//    NSUserDefaults* sDefualts = [NSUserDefaults standardUserDefaults];
//    
//    NSInteger sCurrentPoints = [sDefualts integerForKey:DEFAULTS_DIANRU_POINTS];
//    
//    NSInteger sEarnedPoints = 0;
//    if (aTotalPoints > sCurrentPoints)
//    {
//        sEarnedPoints = aTotalPoints-sCurrentPoints;
//    }
//    [sDefualts setInteger:aTotalPoints forKey:DEFAULTS_DIANRU_POINTS];
//    [sDefualts synchronize];
//    
//    NSLog(@"--!!!!--Dianru---did receive earned %d points", sEarnedPoints);
//
//    if (sEarnedPoints > 0)
//    {
//
//        if ([self.mDelegate respondsToSelector:@selector(returnedEarendPoints:)])
//        {
//            [self.mDelegate returnedEarendPoints:sEarnedPoints];
//        }
//
//    }
//}
//
//-(void)didReceiveSpendScoreResult:(BOOL)isSuccess
//{
//    //
//}
//
//-(NSString *)applicationKey
//{
//    return AD_DIANRU_ID;
//}
//
//-(void)dianruAdWallClose
//{
//    
//}
//
//@end
