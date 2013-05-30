//
//  StoreManager.m
//  AboutSex
//
//  Created by Shane Wen on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StoreManager.h"
#import "SharedVariables.h"

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"
#import "NSDate+MyDate.h"

#import "MobClick.h"

#import "StreamItem.h"

#import "SharedStates.h"

FMDatabase* ssFMDatabase = nil;

@implementation StoreManager

+ (NSString*) getPathForDBinDocunemtsDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0];   
    
    NSString* sPathForDB = [documentsDirectory stringByAppendingPathComponent:@"aboutsex.db"];

//    NSString* sPathForDB = [[NSBundle mainBundle]pathForResource:@"aboutsex" ofType:@"db" inDirectory:nil];

    return sPathForDB;
}

+ (NSString*) getPathForDocumentsStreamDataDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* sDocumentsStreamDataDir = [documentsDirectory stringByAppendingPathComponent:@"StreamData/"];
    return sDocumentsStreamDataDir;
}

+ (NSString*)  getPathForDocumentsFMItemsDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* sDocumentsStreamDataDir = [documentsDirectory stringByAppendingPathComponent:@"FMs/"];
    return sDocumentsStreamDataDir;
}

+ (NSString*) getPathForFMCacheDir
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES);
    NSString* sLibraryDirPath = [paths objectAtIndex:0];
    NSString* sFMCacheDirPath = [sLibraryDirPath stringByAppendingPathComponent:@"Caches/FMs/"];
    
    BOOL sIsDBFileExistent = [[NSFileManager defaultManager]fileExistsAtPath:sFMCacheDirPath];
    if (!sIsDBFileExistent)
    {
        BOOL sSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:sFMCacheDirPath withIntermediateDirectories:NO attributes:nil error:nil];
        if (!sSuccess)
        {
            return nil;
        }
    }
    
    return sFMCacheDirPath;
}

+ (NSString*) getPathForBundleStreamDataDir
{
    NSString* sBundlePath = [[NSBundle mainBundle] bundlePath];
    NSString* sBundleStreamDataDir = [sBundlePath stringByAppendingPathComponent:@"SampleStreamData/"];
    return sBundleStreamDataDir;
}

+ (NSString*) getPathForBundleFMsDir
{
    NSString* sBundlePath = [[NSBundle mainBundle] bundlePath];
    NSString* sBundleStreamDataDir = [sBundlePath stringByAppendingPathComponent:@"FMs/"];
    return sBundleStreamDataDir;
}

+ (BOOL) copyBundleFilesFromDir:(NSString*)aBundleDirPath toDocumentsDir:(NSString*)aDocumentsDir
{
    BOOL sStatus = [[NSFileManager defaultManager] createDirectoryAtPath:aDocumentsDir withIntermediateDirectories:NO attributes:nil error:nil];
    if (sStatus)
    {
        NSArray* sBundleFileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:aBundleDirPath error:nil];
        for (NSString* sBundleFileName in sBundleFileNames)
        {
            NSString* sBundleSampleStreamFile = [aBundleDirPath stringByAppendingPathComponent:sBundleFileName];
            NSString* sDocumentsSampleStreamFile = [aDocumentsDir stringByAppendingPathComponent:sBundleFileName];
            
            NSData *sBundleSampleStreamFileData = [NSData dataWithContentsOfFile:sBundleSampleStreamFile];
            [[NSFileManager defaultManager] createFileAtPath:sDocumentsSampleStreamFile
                                                    contents:sBundleSampleStreamFileData
                                                  attributes:nil];
        }
        return YES;
    }
    return NO;
}

+ (BOOL) openIfNecessary
{
    if (ssFMDatabase)
    {
        return YES;
    }
    
    NSString* sPathForDBinDocumensDir = [self getPathForDBinDocunemtsDir];

#ifdef DEBUG
//#define REMOVE_EXISTING_DB_ON_LAUNCH_IN_DEBUG_MODE
#endif
    
#ifdef REMOVE_EXISTING_DB_ON_LAUNCH_IN_DEBUG_MODE
    //test code, just remove aboutsex.db in Documents directory.
    {
        if ([[NSFileManager defaultManager]fileExistsAtPath:sPathForDBinDocumensDir])
        {
            NSError* sErr = nil;
            [[NSFileManager defaultManager] removeItemAtPath:sPathForDBinDocumensDir error:&sErr];
        }
    }
#endif 
    
//    //remove aboutsex.db in Documens directory for the first launch, and for 1.0.
    if ([[SharedStates getInstance] isFirstLaunchOfCurrentVersion]
        &&( [[SharedStates getInstance] getLastVersion] == nil
           || [[[SharedStates getInstance] getLastVersion] isEqualToString:@"1.0"]))
    {
        if ([[NSFileManager defaultManager]fileExistsAtPath:sPathForDBinDocumensDir])
        {
            NSError* sErr = nil;
            [[NSFileManager defaultManager] removeItemAtPath:sPathForDBinDocumensDir error:&sErr];
        }
    }
    
    //1. ensure the existence of aboutsex.db under Documents dir.
    BOOL sIsDBFileExistent = [[NSFileManager defaultManager]fileExistsAtPath:sPathForDBinDocumensDir];
    if (!sIsDBFileExistent)
    {
        //copy aboutsex.db from bundle to Documents directory
        {
            NSString* sPathForDBinBundle = [[NSBundle mainBundle]pathForResource:@"aboutsex" ofType:@"db" inDirectory:nil];
            sIsDBFileExistent = [[NSFileManager defaultManager]fileExistsAtPath:sPathForDBinBundle];
            if (!sIsDBFileExistent)
            {
#ifdef DEBUG
                NSLog(@"database %@ does not exist!", sPathForDBinBundle);
#endif
                return NO;
            }

            NSData *sDBFileData = [NSData dataWithContentsOfFile:sPathForDBinBundle]; 
            [[NSFileManager defaultManager] createFileAtPath:sPathForDBinDocumensDir 
                                                    contents:sDBFileData 
                                            attributes:nil];
        }
        
        sIsDBFileExistent = [[NSFileManager defaultManager]fileExistsAtPath:sPathForDBinDocumensDir];

        if (!sIsDBFileExistent)
        {
#ifdef DEBUG
            NSLog(@"database %@ does not exist!", sPathForDBinDocumensDir);
#endif
            return NO;
        }
    }
    
    //2. ensure the existence of sample stream files in StreamDataDir under Documents dir.
    NSString* sDocumentsStreamDataDir = [self getPathForDocumentsStreamDataDir];
    BOOL sIsDocumentsStreamDataDirExistent = [[NSFileManager defaultManager]fileExistsAtPath:sDocumentsStreamDataDir];
    if (!sIsDocumentsStreamDataDirExistent)
    {
        [self copyBundleFilesFromDir:[self getPathForBundleStreamDataDir]  toDocumentsDir:sDocumentsStreamDataDir];
    }
    
    
    //3. ensure the existence of FM in FMs directory under Documents dir.
    NSString* sDocumentsFMDir = [self getPathForDocumentsFMItemsDir];
    BOOL sIsDocumentsFMDirExistent = [[NSFileManager defaultManager]fileExistsAtPath:sDocumentsFMDir];
    if (!sIsDocumentsFMDirExistent)
    {
        [self copyBundleFilesFromDir:[self getPathForBundleFMsDir]  toDocumentsDir:sDocumentsFMDir];
    }
    
    if (ssFMDatabase)
    {
        [ssFMDatabase release];
        ssFMDatabase = nil;
    }
    ssFMDatabase = [FMDatabase databaseWithPath:sPathForDBinDocumensDir];
    [ssFMDatabase retain];

    if (![ssFMDatabase open])
    {
#ifdef DEBUG
        NSLog(@"database %@ cannot be opened", [ssFMDatabase databasePath]);
#endif
        return NO;
    }

    //if stream_items table not updated with 5 new columns, numLikes, numCollects, numComments, isLiked, comment, then update it.
    NSString* sColumnAddSQLStr = nil;
    if (![ssFMDatabase columnExists:@"numLikes" inTableWithName:@"stream_items"])
    {
        sColumnAddSQLStr = @"ALTER TABLE stream_items ADD COLUMN numLikes INTEGER DEFAULT(0)";
        [ssFMDatabase executeUpdate: sColumnAddSQLStr];
    }
    
    if (![ssFMDatabase columnExists:@"isLiked" inTableWithName:@"stream_items"])
    {
        sColumnAddSQLStr = @"ALTER TABLE stream_items ADD COLUMN isLiked BOOLEAN DEFAULT(0)";
        [ssFMDatabase executeUpdate: sColumnAddSQLStr];
    }

    if (![ssFMDatabase columnExists:@"numCollects" inTableWithName:@"stream_items"])
    {
        sColumnAddSQLStr = @"ALTER TABLE stream_items ADD COLUMN numCollects INTEGER DEFAULT(0)";
        [ssFMDatabase executeUpdate: sColumnAddSQLStr];
    }
    
    if (![ssFMDatabase columnExists:@"numComments" inTableWithName:@"stream_items"])
    {
        sColumnAddSQLStr = @"ALTER TABLE stream_items ADD COLUMN numComments INTEGER DEFAULT(0)";
        [ssFMDatabase executeUpdate: sColumnAddSQLStr];
    }
    
    if (![ssFMDatabase columnExists:@"comment" inTableWithName:@"stream_items"])
    {
        sColumnAddSQLStr = @"ALTER TABLE stream_items ADD COLUMN comment TEXT";
        [ssFMDatabase executeUpdate: sColumnAddSQLStr];
    }

    
////    BOOL sIsFirstLauchOfCurrentVersion = [[SharedStates getInstance] isFirstLaunchOfCurrentVersion];   
////    if (sIsFirstLauchOfCurrentVersion)
//    {
//        if (![ssFMDatabase tableExists:@"stream_items"])
//        {
//            NSString* sSQLStr = @"CREATE TABLE stream_items(itemID INTEGER PRIMARY KEY AUTOINCREMENT, itemName TEXT, location TEXT, isRead BOOLEAN, isMarked BOOLEAN, releasedTime INTEGER, markedTime INTEGER, iconURL TEXT, summary TEXT, numVisits INTEGER, tag INTEGER)";
//            [ssFMDatabase executeUpdate:sSQLStr];
//
//            NSString* sDocumentsStreamDataDir = [self getPathForDocumentsStreamDataDir];
//            NSArray* sSampleStreamFileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sDocumentsStreamDataDir error:nil];
//            for (NSString* sSampleFileName in sSampleStreamFileNames)
//            {
//                if (sSampleFileName.length>1)
//                {
//                    NSString* sDocumentsSampleStreamFile = [NSString stringWithFormat:@"%@%@", @"StreamData/", sSampleFileName];
//                    
//                    sSQLStr = @"INSERT INTO stream_items(itemName, location, isRead, isMarked, releasedTime, markedTime, iconURL, summary, numVisits, tag) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
//                    
//                    [ssFMDatabase executeUpdate:sSQLStr, sSampleFileName, sDocumentsSampleStreamFile,[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],  [NSDate distantPast], [NSDate distantPast], @"", NSLocalizedString(@"Summary unvailable due to network problems", nil), [NSNumber numberWithInt:-1], [NSNumber numberWithInt:-1]];
//                }
//            }
//        }
//    }
//
    
    return YES;
    
}

+ (void) close
{
    if (ssFMDatabase)
    {
        [ssFMDatabase close];
        [ssFMDatabase release];
        ssFMDatabase = nil;
    }
    return;
}

//+ (Section*) getLatestStreamItems: (NSInteger) aMaxNumOfItems
//{
//    if (aMaxNumOfItems <= 0)
//    {
//        return nil;
//    }
//    [StoreManager openIfNecessary];
//
//    NSString* sSQLStr = @"SELECT * FROM sections WHERE sections.sectionName = ?";
//    FMResultSet* sRetSet = [ssFMDatabase executeQuery:sSQLStr, SECTION_NAME_STREAM];
//    
//    Section* sSection = nil;
//    if ([sRetSet next]) {
//        sSection = [[[Section alloc]init] autorelease];
//        sSection.mSectionID = [sRetSet intForColumn:@"sectionID"];
//        sSection.mName = [sRetSet stringForColumn:@"sectionName"];
//        sSection.mOffset = [sRetSet doubleForColumn:@"sectionOffset"];
//        sSection.mCategories = nil;
//    }
//    else 
//    {
//        return nil;
//    }
//    [sRetSet close];
//
//    
//    sSQLStr = @"SELECT * FROM categories WHERE categories.refSectionID = ?";
//    FMResultSet * sRetSetCats = [ssFMDatabase executeQuery:sSQLStr, [NSNumber numberWithInteger: sSection.mSectionID]];
//    NSMutableArray* sCategories = [[NSMutableArray alloc]init];
//    if ([sRetSetCats next])
//    {
//        Category* sCat = [[Category alloc]init];
//        sCat.mCategoryID = [sRetSetCats intForColumn:@"categoryID"];
//        sCat.mName = [sRetSetCats stringForColumn:@"categoryName"];
//        sCat.mItems = nil;
//        [sCategories addObject:sCat];
//        [sCat release];
//    }
//    [sRetSetCats close];
//    sSection.mCategories = sCategories;
//    [sCategories release];
//
//    
//    sSQLStr = @"SELECT * FROM items WHERE items.refCategoryID = ? ORDER BY releasedTime DESC LIMIT ?";
//    
//    if (sSection.mCategories.count > 0)
//    {
//        Category* sCategory = [sSection.mCategories objectAtIndex:0];
//        FMResultSet* sRetSetItems = [ssFMDatabase executeQuery:sSQLStr, [NSNumber numberWithInteger:sCategory.mCategoryID], 
//                                     [NSNumber numberWithInteger:aMaxNumOfItems]];
//        NSMutableArray* sItems = [[NSMutableArray alloc]init];
//        while ([sRetSetItems next])
//        {
//            Item* sItem = [[Item alloc]init];
//            sItem.mItemID = [sRetSetItems intForColumn:@"itemID"];
//            sItem.mName = [sRetSetItems stringForColumn:@"itemName"];
//            sItem.mLocation = [sRetSetItems stringForColumn:@"location"];
//            sItem.mIsRead = [sRetSetItems boolForColumn:@"isRead"];
//            sItem.mIsMarked = [sRetSetItems boolForColumn:@"isMarked"];
//            sItem.mReleasedTime = [sRetSetItems dateForColumn:@"releasedTime"];
//            sItem.mMarkedTime = [sRetSetItems dateForColumn:@"markedTime"];
//            sItem.mCategory = sCategory;
//            sItem.mSection = sSection;
//            
//            [sItems addObject:sItem];
//            [sItem release];
//        }
//        [sRetSetItems close];
//        sCategory.mItems = sItems;
//        [sItems release];
//    }
//    
//    [sSection initIndexOfTheFirstItemForEachCategory];
//    
//    return sSection;
//
//}

+ (NSInteger) addOrUpdateStreamItems: (NSMutableArray*)aStreamItemsArray
{
    [StoreManager openIfNecessary];
    
    NSString* sSQLStrCheckItemExistence = @"SELECT COUNT(*) FROM stream_items WHERE itemID=?";
    NSString* sSQLStrUpdateNumVisits = @"UPDATE stream_items SET numVisits=?, numLikes=?, numCollects=?, numComments=? WHERE itemID=?";
    NSString* sSQLStrInsertStreamItem = @"INSERT INTO stream_items(itemID, itemName, location, isRead, isMarked, releasedTime, markedTime, iconURL, summary, numVisits, tag, numLikes, numCollects, numComments, comment) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
//    BOOL sIsSuccess = [ssFMDatabase executeUpdate:sSQLStrUpdateNumVisits, aDate, [NSNumber numberWithInteger:aItemID]];

    NSInteger sItemsInserted = 0;
    
    for(StreamItem* sStreamItem in aStreamItemsArray)
    {
        NSInteger sItemID = sStreamItem.mItemID;
        NSInteger sNumVisits = sStreamItem.mNumVisits;
        NSInteger sNumLikes = sStreamItem.mNumLikes;
        NSInteger sNumCollects = sStreamItem.mNumCollects;
        NSInteger sNumComments = sStreamItem.mNumComments;

       
        FMResultSet* sItemExistenceCheckRet = [ssFMDatabase executeQuery:sSQLStrCheckItemExistence, [NSNumber numberWithInteger:sItemID]];
        //if the stream item with itemID equal to sItemID does not exisit yet, then insert it into database. otherwise update its numVisit field if unequal to sNumVisits. 
        if ([sItemExistenceCheckRet next]
            && [sItemExistenceCheckRet intForColumnIndex:0] > 0)
        {
//            if ([sItemExistenceCheckRet intForColumnIndex:1] != sNumVisits)
            {
                [ssFMDatabase executeUpdate:sSQLStrUpdateNumVisits, [NSNumber numberWithInteger:sNumVisits], [NSNumber numberWithInteger:sNumLikes], [NSNumber numberWithInteger:sNumCollects], [NSNumber numberWithInteger:sNumComments], [NSNumber numberWithInteger:sItemID]];
            }

        }
        else 
        {
            NSString* sItemName = sStreamItem.mName;
            NSString* sLocation = sStreamItem.mLocation;
            BOOL sIsRead = sStreamItem.mIsRead;
            BOOL sIsMarked = sStreamItem.mIsMarked;
            NSDate* sReleasedTime = sStreamItem.mReleasedTime;
            NSDate* sMarkedTime = sStreamItem.mMarkedTime;
            NSString* sIconURL = sStreamItem.mIconURL;
            NSString* sSummary = sStreamItem.mSummary;
            NSInteger sTag = sStreamItem.mTag;

            [ssFMDatabase executeUpdate:sSQLStrInsertStreamItem, [NSNumber numberWithInteger:sItemID], sItemName, sLocation, [NSNumber numberWithBool:sIsRead], [NSNumber numberWithBool:sIsMarked], sReleasedTime, sMarkedTime, sIconURL, sSummary,[NSNumber numberWithInteger:sNumVisits], [NSNumber numberWithInteger:sTag], [NSNumber numberWithInteger:sNumLikes], [NSNumber numberWithInteger:sNumCollects], [NSNumber numberWithInteger:sNumComments], sStreamItem.mComment, [NSNumber numberWithBool:sStreamItem.mIsLiked]];
            sItemsInserted++;
        }
        
        [sItemExistenceCheckRet close];
    }
    
    return sItemsInserted;
}

+ (NSMutableArray*) getLatestStreamItems: (NSInteger) aMaxNumOfItems Offset:(NSInteger)aOffset;
{
    [StoreManager openIfNecessary];
    
    NSString* sSQLStr = @"SELECT * FROM stream_items ORDER BY releasedTime DESC LIMIT ? OFFSET ?";
    FMResultSet *sItemsResult = [ssFMDatabase executeQuery:sSQLStr, [NSNumber numberWithInteger:aMaxNumOfItems], [NSNumber numberWithInteger:aOffset]];
    
    NSMutableArray* sStreamItems = [[[NSMutableArray alloc]init] autorelease];
    while ([sItemsResult next]) {
        StreamItem* sStreamItem = [[StreamItem alloc]init];
        sStreamItem.mItemID = [sItemsResult intForColumn:@"itemID"];
        sStreamItem.mName = [sItemsResult stringForColumn:@"itemName"];
        sStreamItem.mLocation = [sItemsResult stringForColumn:@"location"];
        sStreamItem.mIsRead = [sItemsResult boolForColumn:@"isRead"];
        sStreamItem.mIsMarked = [sItemsResult boolForColumn:@"isMarked"];
        sStreamItem.mReleasedTime = [sItemsResult dateForColumn:@"releasedTime"];
        sStreamItem.mMarkedTime = [sItemsResult dateForColumn:@"markedTime"];
        sStreamItem.mIconURL = [sItemsResult stringForColumn:@"iconURL"];
        sStreamItem.mSummary = [sItemsResult stringForColumn:@"summary"];
        sStreamItem.mNumVisits = [sItemsResult intForColumn:@"numVisits"];
        sStreamItem.mTag = [sItemsResult intForColumn:@"tag"];
        sStreamItem.mNumLikes = [sItemsResult intForColumn:@"numLikes"];
        sStreamItem.mNumCollects = [sItemsResult intForColumn:@"numCollects"];
        sStreamItem.mNumComments = [sItemsResult intForColumn:@"numComments"];
        sStreamItem.mComment = [sItemsResult stringForColumn:@"comment"];
        sStreamItem.mIsLiked = [sItemsResult boolForColumn:@"isLiked"];
        [sStreamItems addObject:sStreamItem]; 
        [sStreamItem release];
    }
    [sItemsResult close];
    
    return sStreamItems;
}

+ (UserInfo*) getUserInfoForStreamItem:(NSInteger)aStreamItemID
{
    [StoreManager openIfNecessary];
    
    NSString* sSQLStr = @"SELECT * FROM stream_items WHERE itemID = ?";
    FMResultSet *sRetSet = [ssFMDatabase executeQuery:sSQLStr, [NSNumber numberWithInteger:aStreamItemID]];
    

    UserInfo* sUserInfo = nil;
    if ([sRetSet next])
    {
        sUserInfo = [[[UserInfo alloc] init] autorelease];
        sUserInfo.mIsRead = [sRetSet boolForColumn:@"isRead"];;
        sUserInfo.mIsMarked = [sRetSet boolForColumn:@"isMarked"];;
        sUserInfo.mIsLiked = [sRetSet boolForColumn:@"isLiked"];;
        sUserInfo.mComment = [sRetSet stringForColumn:@"comment"];
    }
        
    [sRetSet close];
    
    return sUserInfo;

}

+ (Section*) getStreamSectionForRecentNDays:(NSInteger)aNumberOfDays
{
    if (aNumberOfDays <= 0)
    {
        return nil;
    }
    
    [StoreManager openIfNecessary];
    
    NSString* sSQLStr = @"SELECT * FROM sections WHERE sections.sectionName = ?";
    FMResultSet* sRetSet = [ssFMDatabase executeQuery:sSQLStr, SECTION_NAME_STREAM];
    
    Section* sSection = nil;
    if ([sRetSet next]) {
        sSection = [[[Section alloc]init] autorelease];
        sSection.mSectionID = [sRetSet intForColumn:@"sectionID"];
        sSection.mName = [sRetSet stringForColumn:@"sectionName"];
        sSection.mOffset = [sRetSet doubleForColumn:@"sectionOffset"];
        sSection.mCategories = nil;
    }
    else 
    {
        return nil;
    }
    
    [sRetSet close];

    // assignment for sSection.mCategories 
    sSQLStr = @"SELECT * FROM categories WHERE categories.refSectionID = ?";
    FMResultSet * sRetSetCats = [ssFMDatabase executeQuery:sSQLStr, [NSNumber numberWithInteger: sSection.mSectionID]];
    NSMutableArray* sCategories = [[NSMutableArray alloc]init];
    while ([sRetSetCats next])
    {
        Category* sCat = [[Category alloc]init];
        sCat.mCategoryID = [sRetSetCats intForColumn:@"categoryID"];
        sCat.mName = [sRetSetCats stringForColumn:@"categoryName"];
        sCat.mItems = nil;
        [sCategories addObject:sCat];
        [sCat release];
    }
    [sRetSetCats close];
    sSection.mCategories = sCategories;
    [sCategories release];
    
    for (NSInteger sCategoryIndex=sSection.mCategories.count-1; sCategoryIndex>=0; sCategoryIndex--)
    {
        Category* sCat = [sSection.mCategories objectAtIndex:sCategoryIndex];
        NSMutableArray* sItems = [[NSMutableArray alloc]init];
        
        
        NSString* sSQLStr = @"SELECT * FROM items WHERE items.refCategoryID = ? AND datetime(items.releasedTime, 'unixepoch')<= datetime('now','localtime') ORDER BY releasedTime DESC LIMIT ?";
        FMResultSet* sRetSetItems = [ssFMDatabase executeQuery:sSQLStr, [NSNumber numberWithInteger:sCat.mCategoryID], [NSNumber numberWithInteger:aNumberOfDays]];
        NSDate* sCurDate = [NSDate date];
        while ([sRetSetItems next])
        {
            NSDate* sReleasedDate = [sRetSetItems dateForColumn:@"releasedTime"];
            if (![sReleasedDate isInRecentDaysBefore: sCurDate NumberOfDays:aNumberOfDays])
            {
                break;
            }
            Item* sItem = [[Item alloc]init];
            sItem.mItemID = [sRetSetItems intForColumn:@"itemID"];
            sItem.mName = [sRetSetItems stringForColumn:@"itemName"];
            sItem.mLocation = [sRetSetItems stringForColumn:@"location"];
            sItem.mIsRead = [sRetSetItems boolForColumn:@"isRead"];
            sItem.mIsMarked = [sRetSetItems boolForColumn:@"isMarked"];
            sItem.mReleasedTime = [sRetSetItems dateForColumn:@"releasedTime"];
            sItem.mMarkedTime = [sRetSetItems dateForColumn:@"markedTime"];
            sItem.mCategory = sCat;
            sItem.mSection = sSection;
            
            [sItems addObject:sItem];
            [sItem release];
        }
        [sRetSetItems close];
        
        if (sItems.count<aNumberOfDays)
        {
            NSString* sSQLStr = @"SELECT * FROM items WHERE items.refCategoryID = ? AND items.releasedTime=? LIMIT ?;";
            FMResultSet* sRetSetItemsNew = [ssFMDatabase executeQuery:sSQLStr, 
                                            [NSNumber numberWithInteger:sCat.mCategoryID]
                                            , [NSDate distantFuture]
                                            , [NSNumber numberWithInteger:(aNumberOfDays-sItems.count)]];
            NSInteger sNumberOfDaysBefore = aNumberOfDays-sItems.count-1;
            while ([sRetSetItemsNew next])
            {
                NSDate* sNowDate = [NSDate date];
                NSDate* sReleasedTime = [[sNowDate startDateOfTheDayinLocalTimezone]dateByAddingTimeInterval:(-1)*sNumberOfDaysBefore*SECONDS_FOR_ONE_DAY+1];
                if (0  == sNumberOfDaysBefore)
                {
                    NSTimeInterval sDelta = ([sNowDate timeIntervalSinceDate:sReleasedTime])/(sSection.mCategories.count+1);
                    sReleasedTime = [sReleasedTime dateByAddingTimeInterval:sDelta*(sSection.mCategories.count-sCategoryIndex) ];
                }
                
                Item* sItem = [[Item alloc]init]; 
                sItem.mItemID = [sRetSetItemsNew intForColumn:@"itemID"];
                sItem.mName = [sRetSetItemsNew stringForColumn:@"itemName"];
                sItem.mLocation = [sRetSetItemsNew stringForColumn:@"location"];
                sItem.mIsRead = [sRetSetItemsNew boolForColumn:@"isRead"];
                sItem.mIsMarked = [sRetSetItemsNew boolForColumn:@"isMarked"];
                sItem.mReleasedTime = sReleasedTime;
                sItem.mMarkedTime = [sRetSetItemsNew dateForColumn:@"markedTime"];
                sItem.mCategory = sCat;
                sItem.mSection = sSection;
                
                [sItems insertObject:sItem atIndex:0];
                [sItem release];
                
                //update its releasedTime
                [self updateItemReleasedTime:sReleasedTime ItemID:sItem.mItemID];
                
                sNumberOfDaysBefore--;
            }
            [sRetSetItemsNew close];
        }
        
        sCat.mItems = sItems;
        [sItems release];

    }
    [sSection initIndexOfTheFirstItemForEachCategory];

    return sSection;
}


+ (Section*) getSectionByName: (NSString*) aName
{
    [StoreManager openIfNecessary];
    
    NSString* sSQLStr = @"SELECT * FROM sections WHERE sections.sectionName = ?";
    FMResultSet* sRetSet = [ssFMDatabase executeQuery:sSQLStr, aName];

    Section* sSection = nil;
    if ([sRetSet next]) {
        sSection = [[[Section alloc]init] autorelease];
        sSection.mSectionID = [sRetSet intForColumn:@"sectionID"];
        sSection.mName = [sRetSet stringForColumn:@"sectionName"];
        sSection.mOffset = [sRetSet doubleForColumn:@"sectionOffset"];
        sSection.mCategories = nil;
    }
    else 
    {
        return nil;
    }
    
    [sRetSet close];
    
    // assignment for sSection.mCategories 
    sSQLStr = @"SELECT * FROM categories WHERE categories.refSectionID = ?";
    FMResultSet * sRetSetCats = [ssFMDatabase executeQuery:sSQLStr, [NSNumber numberWithInteger: sSection.mSectionID]];
    NSMutableArray* sCategories = [[NSMutableArray alloc]init];
    while ([sRetSetCats next])
    {
        Category* sCat = [[Category alloc]init];
        sCat.mCategoryID = [sRetSetCats intForColumn:@"categoryID"];
        sCat.mName = [sRetSetCats stringForColumn:@"categoryName"];
        sCat.mItems = nil;
        [sCategories addObject:sCat];
        [sCat release];
    }
    [sRetSetCats close];
    sSection.mCategories = sCategories;
    [sCategories release];

    //
//    sSQLStr = @"SELECT * FROM items WHERE items.refCategoryID = ? ORDER BY releasedTime DESC";
    sSQLStr = @"SELECT * FROM items WHERE items.refCategoryID = ? ORDER BY itemID ASC";

    for (Category* sCat in sSection.mCategories)
    {
        //assignment for sCat.mItems
        FMResultSet* sRetSetItems = [ssFMDatabase executeQuery:sSQLStr, [NSNumber numberWithInteger:sCat.mCategoryID]];
        NSMutableArray* sItems = [[NSMutableArray alloc]init];
        while ([sRetSetItems next])
        {
            Item* sItem = [[Item alloc]init];
            sItem.mItemID = [sRetSetItems intForColumn:@"itemID"];
            sItem.mName = [sRetSetItems stringForColumn:@"itemName"];
            sItem.mLocation = [sRetSetItems stringForColumn:@"location"];
            sItem.mIsRead = [sRetSetItems boolForColumn:@"isRead"];
            sItem.mIsMarked = [sRetSetItems boolForColumn:@"isMarked"];
            sItem.mReleasedTime = [sRetSetItems dateForColumn:@"releasedTime"];
            sItem.mMarkedTime = [sRetSetItems dateForColumn:@"markedTime"];
            sItem.mCategory = sCat;
            sItem.mSection = sSection;
            
            [sItems addObject:sItem];
            [sItem release];
        }
        [sRetSetItems close];
        sCat.mItems = sItems;
        [sItems release];

    }
    
    [sSection initIndexOfTheFirstItemForEachCategory];
    return sSection;
}

+ (NSInteger) getReadCountInSection: (NSString*) aSectionName
{    
    [StoreManager openIfNecessary];
    NSString* sSQLStr = @"SELECT COUNT(*) FROM items, categories, sections WHERE items.isRead=1 AND sections.sectionName=? AND sections.sectionID=categories.refSectionID AND categories.categoryID=items.refCategoryID";
    FMResultSet *rs = [ssFMDatabase executeQuery:sSQLStr, aSectionName];
    
    if ([rs next])
    {
        return [rs intForColumnIndex:0];
    }
    [rs close];
    
    return -1;    
}

+ (NSInteger) getTotalOfItemsInsection:(NSString*) aSectionName
{    
    [StoreManager openIfNecessary];
    NSString* sSQLStr = @"SELECT COUNT(*) FROM items, categories, sections WHERE sections.sectionName=? AND sections.sectionID=categories.refSectionID AND categories.categoryID=items.refCategoryID";
    FMResultSet *rs = [ssFMDatabase executeQuery:sSQLStr, aSectionName];
    
    if ([rs next])
    {
        return [rs intForColumnIndex:0];
    }
    [rs close];
    
    return -1;
}

+ (NSInteger) getTotalOfCategoriesInSection:(NSString*) aSectionName
{
    [StoreManager openIfNecessary];
    NSString* sSQLStr = @"SELECT COUNT(*) FROM categories, sections WHERE sections.sectionName=? AND sections.sectionID=categories.refSectionID";
    FMResultSet *rs = [ssFMDatabase executeQuery:sSQLStr, aSectionName];
    
    if ([rs next])
    {
        return [rs intForColumnIndex:0];
    }
    [rs close];
    
    return -1;

}

+ (NSMutableArray*) getAllFavoriteItems
{
    [StoreManager openIfNecessary];
    
    NSString* sSQLStr = @"SELECT * FROM items WHERE isMarked=1 ORDER BY markedTime DESC";
    FMResultSet *sItemsResult = [ssFMDatabase executeQuery:sSQLStr];
    
    NSMutableArray* sItems = [[NSMutableArray alloc]init];
    while ([sItemsResult next]) {
        Item* sItem = [[Item alloc]init];
        sItem.mItemID = [sItemsResult intForColumn:@"itemID"];
        sItem.mName = [sItemsResult stringForColumn:@"itemName"];
        sItem.mLocation = [sItemsResult stringForColumn:@"location"];
        sItem.mIsRead = [sItemsResult boolForColumn:@"isRead"];
        sItem.mIsMarked = [sItemsResult boolForColumn:@"isMarked"];
        sItem.mReleasedTime = [sItemsResult dateForColumn:@"releasedTime"];
        sItem.mMarkedTime = [sItemsResult dateForColumn:@"markedTime"];
        sItem.mCategory = nil;
        sItem.mSection = nil;
        
        [sItems addObject:sItem]; 
        [sItem release];
    }
    [sItemsResult close];
    
    sSQLStr = @"SELECT * FROM stream_items WHERE isMarked=1 ORDER BY markedTime DESC";
    FMResultSet *sStreamItemsResult = [ssFMDatabase executeQuery:sSQLStr];
    
    NSMutableArray* sStreamItems = [[NSMutableArray alloc]init];
    while ([sStreamItemsResult next]) {
        StreamItem* sStreamItem = [[StreamItem alloc]init];
        sStreamItem.mItemID = [sStreamItemsResult intForColumn:@"itemID"];
        sStreamItem.mName = [sStreamItemsResult stringForColumn:@"itemName"];
        sStreamItem.mLocation = [sStreamItemsResult stringForColumn:@"location"];
        sStreamItem.mIsRead = [sStreamItemsResult boolForColumn:@"isRead"];
        sStreamItem.mIsMarked = [sStreamItemsResult boolForColumn:@"isMarked"];
        sStreamItem.mReleasedTime = [sStreamItemsResult dateForColumn:@"releasedTime"];
        sStreamItem.mMarkedTime = [sStreamItemsResult dateForColumn:@"markedTime"];
        sStreamItem.mIconURL = [sStreamItemsResult stringForColumn:@"iconURL"];
        sStreamItem.mSummary = [sStreamItemsResult stringForColumn:@"summary"];
        sStreamItem.mNumVisits = [sStreamItemsResult intForColumn:@"numVisits"];
        sStreamItem.mTag = [sStreamItemsResult intForColumn:@"tag"];
        
        [sStreamItems addObject:sStreamItem]; 
        [sStreamItem release];
    }
    [sStreamItemsResult close];
    
    //merge sItems and sStreamItems into sAllFavorites, in DESC order by mMarkedTime.
    NSMutableArray* sAllFavorites = [[[NSMutableArray alloc]initWithCapacity:(sItems.count+sStreamItems.count)]autorelease];
    NSInteger i=0;
    NSInteger j=0;
    while (i<sItems.count
           || j<sStreamItems.count)
    {
        if (i == sItems.count)
        {
            while (j < sStreamItems.count)
            {
                [sAllFavorites addObject:[sStreamItems objectAtIndex:j]];
                j++;
            }
            break;
        }
        else if (j == sStreamItems.count)
        {
            while (i < sItems.count)
            {
                [sAllFavorites addObject:[sItems objectAtIndex:i]];
                i++;
            }
            break;
        }
        else 
        {
            Item* sItem1 = (Item*)[sItems objectAtIndex:i];
            StreamItem* sStreamItem1 = (StreamItem*)[sStreamItems objectAtIndex:j];
            NSComparisonResult sComparisonResult = [sItem1.mMarkedTime compare:sStreamItem1.mMarkedTime];
            if (NSOrderedDescending == sComparisonResult
                || NSOrderedSame == sComparisonResult)
            {
                [sAllFavorites addObject:sItem1];
                i++;
            }
            else 
            {
                [sAllFavorites addObject:sStreamItem1];
                j++;
            }
        }
    }
    
    
    [sItems release];
    [sStreamItems release];
    return sAllFavorites;
}

+ (BOOL) updateItemMarkedStatus:(BOOL)aIsMarked ItemID:(NSInteger)aItemID
{
    return [StoreManager updateItemMarkedStatus:aIsMarked Time:[NSDate date] ItemID:aItemID]; 
    
    //test
//    return [StoreManager updateItemMarkedStatus:aIsMarked Time:[NSDate dateWithTimeIntervalSinceNow:-30*24*60*60] ItemID:aItemID]; 

//        return [StoreManager updateItemMarkedStatus:aIsMarked Time:[NSDate distantFuture] ItemID:aItemID]; 
    //test
}

+ (BOOL) updateItemReleasedTime:(NSDate*)aDate ItemID:(NSInteger)aItemID
{
    [StoreManager openIfNecessary];
    
    NSString* sSQLStr = @"UPDATE items SET releasedTime=? WHERE items.itemID=?";
    BOOL sIsSuccess = [ssFMDatabase executeUpdate:sSQLStr, aDate, [NSNumber numberWithInteger:aItemID]];
    
    return sIsSuccess;
}

+ (BOOL) updateItemMarkedStatus:(BOOL)aIsMarked Time:(NSDate*)aDate ItemID:(NSInteger)aItemID;
{
    [StoreManager openIfNecessary];
    
    NSString* sSQLStr = @"UPDATE items SET isMarked=?, markedTime=? WHERE items.itemID=?";
    BOOL sIsSuccess = [ssFMDatabase executeUpdate:sSQLStr, [NSNumber numberWithBool:aIsMarked], aDate, [NSNumber numberWithInteger:aItemID]];
      
    if (aIsMarked)
    {        
        NSDictionary* sDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSString stringWithFormat:@"%d", aItemID], @"itemID", nil];
        [MobClick event:@"UEID_COLLECT" attributes: sDict];
    }
    else 
    {
        [MobClick event:@"UEID_UNCOLLECT"];
    }
    
    return sIsSuccess;
}

+ (BOOL) updateItemReadStatus:(BOOL)aIsRead ItemID:(NSInteger)aItemID
{
    [StoreManager openIfNecessary];
    
    NSString* sSQLStr = @"UPDATE items SET isRead=? WHERE items.itemID=?";
    BOOL sIsSuccess = [ssFMDatabase executeUpdate:sSQLStr, [NSNumber numberWithBool:aIsRead],[NSNumber numberWithInteger:aItemID]];
    
    return sIsSuccess;
}

+ (BOOL) updateStreamItemReadStatus:(BOOL)aIsRead ItemID:(NSInteger)aItemID
{    
    [StoreManager openIfNecessary];
    UserInfo* sUserInfo = [self getUserInfoForStreamItem:aItemID];
    if (sUserInfo.mIsRead == YES
        || !aIsRead)
    {
        return NO;
    }
    
    NSString* sSQLStr = @"UPDATE stream_items SET isRead=?, numVisits=numVisits+1 WHERE stream_items.itemID=?";
    BOOL sIsSuccess = [ssFMDatabase executeUpdate:sSQLStr, [NSNumber numberWithBool:aIsRead],[NSNumber numberWithInteger:aItemID]];
    
    return sIsSuccess;
}

+ (BOOL) updateStreamItemMarkedStatus:(BOOL)aIsMarked ItemID:(NSInteger)aItemID
{
    return [StoreManager updateStreamItemMarkedStatus:aIsMarked Time:[NSDate date] ItemID:aItemID]; 
}

+ (BOOL) updateStreamItemMarkedStatus:(BOOL)aIsMarked Time:(NSDate*)aDate ItemID:(NSInteger)aItemID
{
    [StoreManager openIfNecessary];
    
    UserInfo* sUserInfo = [self getUserInfoForStreamItem:aItemID];
    if (sUserInfo.mIsMarked == aIsMarked)
    {
        return NO;
    }

    
    NSString* sSQLStr = nil;
    if (aIsMarked)
    {
        sSQLStr = @"UPDATE stream_items SET isMarked=?, markedTime=? , numCollects=numCollects+1 WHERE stream_items.itemID=?";
    }
    else
    {
        sSQLStr = @"UPDATE stream_items SET isMarked=?, markedTime=? , numCollects=numCollects-1 WHERE stream_items.itemID=?";
    }
    BOOL sIsSuccess = [ssFMDatabase executeUpdate:sSQLStr, [NSNumber numberWithBool:aIsMarked], aDate, [NSNumber numberWithInteger:aItemID]];
        
    return sIsSuccess;
}

+ (BOOL) updateStreamItemLikedStatus:(BOOL)aLiked ItemID:(NSInteger)aItemID
{
    [StoreManager openIfNecessary];
    
    UserInfo* sUserInfo = [self getUserInfoForStreamItem:aItemID];
    if (sUserInfo.mIsLiked == aLiked)
    {
        return NO;
    }
    
    NSString* sSQLStr = nil;
    if (aLiked)
    {
        sSQLStr = @"UPDATE stream_items SET isLiked=?, numLikes=numLikes+1 WHERE stream_items.itemID=?";
    }
    else
    {
        sSQLStr = @"UPDATE stream_items SET isLiked=?, numLikes=numLikes-1 WHERE stream_items.itemID=?";
    }
    BOOL sIsSuccess = [ssFMDatabase executeUpdate:sSQLStr, [NSNumber numberWithBool:aLiked], [NSNumber numberWithInteger:aItemID]];
    
    return sIsSuccess;

}

+ (BOOL) updateStreamItemComment:(NSString*)aComment ItemID:(NSInteger)aItemID
{
    [StoreManager openIfNecessary];
    
    UserInfo* sUserInfo = [self getUserInfoForStreamItem:aItemID];
    
    NSString* sSQLStr = nil;
    if (sUserInfo
        && sUserInfo.mComment.length > 0)
    {
        if (aComment.length > 0)
        {
            sSQLStr = @"UPDATE stream_items SET comment=? WHERE stream_items.itemID=?";  
        }
        else
        {
            sSQLStr = @"UPDATE stream_items SET comment=?, numComments=numComments-1 WHERE stream_items.itemID=?";
        }
    }
    else
    {
        if (aComment.length > 0)
        {
            sSQLStr = @"UPDATE stream_items SET comment=?, numComments=numComments+1 WHERE stream_items.itemID=?";
        }
        else
        {
            return NO;
        }
    }
    BOOL sIsSuccess = [ssFMDatabase executeUpdate:sSQLStr, aComment, [NSNumber numberWithInteger:aItemID]];
    
    return sIsSuccess;

}

+ (BOOL) updateStreamItemLocation:(NSString*)aNewLoc ItemID:(NSInteger)aItemID
{
    [StoreManager openIfNecessary];
    
    NSString* sSQLStr = @"UPDATE stream_items SET location=? WHERE stream_items.itemID=?";
    BOOL sIsSuccess = [ssFMDatabase executeUpdate:sSQLStr, aNewLoc, [NSNumber numberWithInteger:aItemID]];
    
    return sIsSuccess;

}

+ (BOOL) removeUncollectedStreamItemsIfExceeds:(NSInteger)aMaxCount aMinCount:(NSInteger)aMinCount
{
    if (aMinCount >= aMaxCount)
    {
        return FALSE;
    }
    
    [StoreManager openIfNecessary];
    NSString* sSQLStr1 = @"SELECT COUNT(*) FROM stream_items";
    FMResultSet *rs = [ssFMDatabase executeQuery:sSQLStr1];
    
    if ([rs next])
    {
        NSInteger sCount = [rs intForColumnIndex:0];
        
        if (sCount > aMaxCount)
        {
            NSString* sSQLStr2 = @"DELETE FROM stream_items WHERE itemID in (SELECT itemID FROM stream_items WHERE isMarked=0 ORDER BY releasedTime ASC LIMIT ?)";
            BOOL sIsSuccess = [ssFMDatabase executeUpdate:sSQLStr2, [NSNumber numberWithInteger:(sCount-aMaxCount)]]; 
            return sIsSuccess;
        }
    }
    
    [rs close];
    return  FALSE;
}


+ (BOOL) updateSectionOffset:(CGFloat)aOffset ForSection:(NSInteger)aSectionID
{    
    [StoreManager openIfNecessary];
    
    NSString* sSQLStr = @"UPDATE sections SET sectionOffset=? WHERE sections.sectionID=?";
    BOOL sIsSuccess = [ssFMDatabase executeUpdate:sSQLStr, [NSNumber numberWithDouble:aOffset],[NSNumber numberWithInteger:aSectionID]];
    
    return sIsSuccess;
}



//+ (NSMutableArray*) getAllItemsForSection:(NSString*)aSectionName
//{
//    [StoreManager open];
//    
//    NSString* sSQLStr = @"SELECT items.itemID, items.itemName, items.location, items.isRead, items.isMarked, items., items.markedTime, categories.categoryID, categories.categoryName, sections.sectionID, sections.sectionName FROM items, categories, sections WHERE sections.sectionName=? AND sections.sectionID=categories.refSectionID AND categories.categoryID=items.refCategoryID";
//    FMResultSet *rs = [ssFMDatabase executeQuery:sSQLStr, aSectionName];
////    FMResultSet* rs = [ssFMDatabase executeQuery: @"SELECT items.itemID, items.itemName, items.location, items.isRead, items.isMarked, items.mReleasedTime, items.markedTime, categories.categoryID, categories.categoryName, sections.sectionID, sections.sectionName FROM items, categories, sections WHERE sections.sectionName=\'stream\' AND sections.sectionID=categories.refSectionID AND categories.categoryID=items.refCategoryID"];
//    
//    NSMutableArray* sResut = [[[NSMutableArray alloc]initWithCapacity:20] autorelease];
//    if ([ssFMDatabase hadError])
//    {
//        NSLog(@"err: %@", ssFMDatabase.lastErrorMessage);
//    }
//    
//    while ([rs next]) {
//        Item* sItem = [[Item alloc]init];
//        
//        sItem.mItemID = [rs intForColumn:@"itemID"];
//        sItem.mName = [rs stringForColumn:@"itemName"];
//        sItem.mLocation = [rs stringForColumn:@"location"];
//        sItem.mIsRead = [rs boolForColumn:@"isRead"];
//        sItem.mIsMarked = [rs boolForColumn:@"isMarked"];
//        sItem.mReleasedTime = (NSDate*)[rs objectForColumnName:@"releasedTime"];
//        sItem.mMarkedTime = (NSDate*)[rs objectForColumnName:@"markedTime"];
//        
//        Category* sCategory = [[Category alloc]init];
//        sCategory.mCategoryID = [rs intForColumn:@"categoryID"];
//        sCategory.mName = [rs stringForColumn:@"categoryName"];
//        sItem.mCategory = sCategory;
//        [sCategory release];
//        
//        Section* sSection = [[Section alloc]init];
//        sSection.mSectionID = [rs intForColumn:@"sectionID"];
//        sSection.mName = [rs stringForColumn:@"sectionName"];
//        sItem.mSection = sSection;
//        [sSection release];
//
//        
//        [sResut addObject:sItem];
//        [sItem release];
//    }
//    [rs close];
//    
//    return sResut;
//}



@end


