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

FMDatabase* ssFMDatabase;

@implementation StoreManager

+ (NSString*) getPathForDBinDocunemtsDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0];   
    
    NSString* sPathForDB = [documentsDirectory stringByAppendingPathComponent:@"aboutsex.db"];

//    NSString* sPathForDB = [[NSBundle mainBundle]pathForResource:@"aboutsex" ofType:@"db" inDirectory:nil];

    return sPathForDB;
}

+ (BOOL) openIfNecessary
{
    if (ssFMDatabase)
    {
        return YES;
    }
    
    NSString* sPathForDBinDocumensDir = [self getPathForDBinDocunemtsDir];

#ifdef DEBUG
#define REMOVE_EXISTING_DB_ON_LAUNCH
#endif
    
#ifdef REMOVE_EXISTING_DB_ON_LAUNCH
    //test code, just remove aboutsex.db in Documents directory.
    {
        
        if ([[NSFileManager defaultManager]fileExistsAtPath:sPathForDBinDocumensDir])
        {
            NSError* sErr = nil;
            [[NSFileManager defaultManager] removeItemAtPath:sPathForDBinDocumensDir error:&sErr];
            
        }

    }
#endif    
    
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
    ssFMDatabase = [FMDatabase databaseWithPath:sPathForDBinDocumensDir];

    if (![ssFMDatabase open])
    {
#ifdef DEBUG
        NSLog(@"database %@ cannot be opened", [ssFMDatabase databasePath]);
#endif
        return NO;
    }

    [ssFMDatabase retain];

    NSString* sSQLStr = nil;
    
    if (![ssFMDatabase tableExists:@"sections"])
    {
        sSQLStr = @"CREATE TABLE sections(sectionID INTEGER PRIMARY KEY AUTOINCREMENT,sectionName VARCHAR(50), sectionOffset DOUBLE)";
        [ssFMDatabase executeUpdate:sSQLStr];
        
        sSQLStr = @"INSERT INTO sections(sectionName, sectionOffset) VALUES(?,?)";
        [ssFMDatabase executeUpdate:sSQLStr, SECTION_NAME_STREAM, [NSNumber numberWithDouble:0.0]];
        [ssFMDatabase executeUpdate:sSQLStr, SECTION_NAME_COMMONSENSE, [NSNumber numberWithDouble:0.0]];
        [ssFMDatabase executeUpdate:sSQLStr, SECTION_NAME_HELATH, [NSNumber numberWithDouble:0.0]];
        [ssFMDatabase executeUpdate:sSQLStr, SECTION_NAME_SKILLS, [NSNumber numberWithDouble:0.0]];
        [ssFMDatabase executeUpdate:sSQLStr, SECTION_NAME_PSYCHOLOGY, [NSNumber numberWithDouble:0.0]];
        
    };

    if (![ssFMDatabase tableExists:@"categories"])
    {
        sSQLStr = @"CREATE TABLE categories(categoryID INTEGER PRIMARY KEY AUTOINCREMENT, categoryName VARCHAR(100) NOT NULL, refSectionID INTEGER, FOREIGN KEY(refSectionID) REFERENCES sections(sectionID))";
        [ssFMDatabase executeUpdate:sSQLStr];
        
        sSQLStr = @"INSERT INTO categories(categoryName, refSectionID) VALUES(?, ?)";
        [ssFMDatabase executeUpdate:sSQLStr, @"无类别", [NSNumber numberWithInt:1]];
        
        [ssFMDatabase executeUpdate:sSQLStr, @"青春期", [NSNumber numberWithInt:2]];
        [ssFMDatabase executeUpdate:sSQLStr, @"更年期", [NSNumber numberWithInt:2]];
        [ssFMDatabase executeUpdate:sSQLStr, @"安全期", [NSNumber numberWithInt:2]];
        [ssFMDatabase executeUpdate:sSQLStr, @"男性器官", [NSNumber numberWithInt:2]];
        [ssFMDatabase executeUpdate:sSQLStr, @"女性器官", [NSNumber numberWithInt:2]];

    };
//    
    if (![ssFMDatabase tableExists:@"items"])
    {
        sSQLStr = @"CREATE TABLE items(itemID INTEGER PRIMARY KEY AUTOINCREMENT, itemName TEXT, location TEXT, isRead BOOLEAN, isMarked BOOLEAN, releasedTime INTEGER, markedTime INTEGER, refCategoryID INTEGER, FOREIGN KEY(refCategoryID) REFERENCES categories(cagegoryID))";
        [ssFMDatabase executeUpdate:sSQLStr];
        
        sSQLStr = @"INSERT INTO items(itemName, location, isRead, isMarked, releasedTime, markedTime, refCategoryID) VALUES(?, ?,?,?,?,?,?)";
        
        [ssFMDatabase executeUpdate:sSQLStr, @"梦见和小叔子发生关系 正常吗", @"data/dict/1.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],  [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:1]];
        [ssFMDatabase executeUpdate:sSQLStr, @"老公和豪放女练床技 害我守活寡", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:1]];
        [ssFMDatabase executeUpdate:sSQLStr, @"寂寞富婆与花样美男的故事", @"data/dict/3.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:1]];
        [ssFMDatabase executeUpdate:sSQLStr, @"老公给保姆纹身竟趁机偷腥", @"data/dict/4.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],  [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:1]];
        [ssFMDatabase executeUpdate:sSQLStr, @"揭秘两性性差异 男性每月两天性欲旺盛", @"data/dict/1.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],  [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:1]];
        [ssFMDatabase executeUpdate:sSQLStr, @"好聚好散的“离婚茶”", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:1]];
        [ssFMDatabase executeUpdate:sSQLStr, @"约会时男人有哪些歪脑筋", @"data/dict/3.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:1]];
        [ssFMDatabase executeUpdate:sSQLStr, @"最受男人欢迎的“减压性爱”(组图) ", @"data/dict/4.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],  [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:1]];
        [ssFMDatabase executeUpdate:sSQLStr, @"性游戏”要适度 5大规则教你玩尽性", @"data/dict/1.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],  [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:1]];
        [ssFMDatabase executeUpdate:sSQLStr, @"女人都是结婚狂：谁在诱惑女人们结婚", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],  [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:1]];
        [ssFMDatabase executeUpdate:sSQLStr, @"让老公宠你一辈子的技巧", @"data/dict/3.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],  [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:1]];
        [ssFMDatabase executeUpdate:sSQLStr, @"男人女人什么年龄最容易出轨？", @"data/dict/4.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:1]];
        [ssFMDatabase executeUpdate:sSQLStr, @"男人靠什么吸引女人", @"data/dict/1.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:1]];
        [ssFMDatabase executeUpdate:sSQLStr, @"婚外恋是一种能传染的心理疾病", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],  [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:1]];
        [ssFMDatabase executeUpdate:sSQLStr, @"盘点中国式妻子的10大坏习惯", @"data/dict/3.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:1]];
        [ssFMDatabase executeUpdate:sSQLStr, @"老公街上凶老婆，大家一起凶老公", @"data/dict/4.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:1]];
        
        
        [ssFMDatabase executeUpdate:sSQLStr, @"青春期的冲动是怎么一回事？", @"data/dict/1xx.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:2]];
        [ssFMDatabase executeUpdate:sSQLStr, @"女性乳房的构造", @"data/dict/2xx.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:2]];
        [ssFMDatabase executeUpdate:sSQLStr, @"男性应该知道的性知识", @"data/dict/3xx.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:2]];
        [ssFMDatabase executeUpdate:sSQLStr, @"大姨妈说法的由来", @"data/dict/4xx.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:2]];
        
        [ssFMDatabase executeUpdate:sSQLStr, @"更年期1", @"data/dict/1.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],  [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:3]];
        [ssFMDatabase executeUpdate:sSQLStr, @"更年期2", @"data/dict/1.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],  [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:3]];
        [ssFMDatabase executeUpdate:sSQLStr, @"更年期3", @"data/dict/1.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],  [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:3]];
        [ssFMDatabase executeUpdate:sSQLStr, @"更年期4", @"data/dict/1.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],  [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:3]];
        [ssFMDatabase executeUpdate:sSQLStr, @"更年期5", @"data/dict/1.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:3]];
        [ssFMDatabase executeUpdate:sSQLStr, @"更年期6", @"data/dict/1.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],  [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:3]];
        [ssFMDatabase executeUpdate:sSQLStr, @"更年期7", @"data/dict/1.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],  [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:3]];
        [ssFMDatabase executeUpdate:sSQLStr, @"更年期8", @"data/dict/1.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:3]];
        [ssFMDatabase executeUpdate:sSQLStr, @"更年期9", @"data/dict/1.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:3]];
        
        [ssFMDatabase executeUpdate:sSQLStr, @"安全期1", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:4]];
        [ssFMDatabase executeUpdate:sSQLStr, @"安全期2", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:4]];
        [ssFMDatabase executeUpdate:sSQLStr, @"安全期3", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:4]];
        [ssFMDatabase executeUpdate:sSQLStr, @"安全期4", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:4]];
        [ssFMDatabase executeUpdate:sSQLStr, @"安全期5", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:4]];
        [ssFMDatabase executeUpdate:sSQLStr, @"安全期6", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:4]];
        [ssFMDatabase executeUpdate:sSQLStr, @"安全期7", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:4]];
        [ssFMDatabase executeUpdate:sSQLStr, @"安全期8", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:4]];
        [ssFMDatabase executeUpdate:sSQLStr, @"安全期9", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:4]];
        [ssFMDatabase executeUpdate:sSQLStr, @"安全期10", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:4]];
        
        
        [ssFMDatabase executeUpdate:sSQLStr, @"男性生理1", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:5]];
        [ssFMDatabase executeUpdate:sSQLStr, @"男性生理2", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:5]];
        [ssFMDatabase executeUpdate:sSQLStr, @"男性生理3", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:5]];
        [ssFMDatabase executeUpdate:sSQLStr, @"男性生理4", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:5]];
        [ssFMDatabase executeUpdate:sSQLStr, @"男性生理5", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:5]];
        
        
        [ssFMDatabase executeUpdate:sSQLStr, @"女性生理1", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:6]];
        [ssFMDatabase executeUpdate:sSQLStr, @"女性生理2", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:6]];
        [ssFMDatabase executeUpdate:sSQLStr, @"女性生理3", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:6]];
        [ssFMDatabase executeUpdate:sSQLStr, @"女性生理4", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:6]];
        [ssFMDatabase executeUpdate:sSQLStr, @"女性生理5", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:6]];
        [ssFMDatabase executeUpdate:sSQLStr, @"女性生理6", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:6]];
        [ssFMDatabase executeUpdate:sSQLStr, @"女性生理7", @"data/dict/2.html",[ NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],   [NSDate date], [NSDate distantFuture], [NSNumber numberWithInt:6]];
        
    }
    
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

    sSQLStr = @"SELECT * FROM items WHERE items.refCategoryID = ? ORDER BY releasedTime DESC";
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
    return -1;
}

+ (NSMutableArray*) getAllFavoriteItems
{
    [StoreManager openIfNecessary];
    
    NSString* sSQLStr = @"SELECT * FROM items WHERE isMarked=1 ORDER BY markedTime DESC";
    FMResultSet *sItemsResult = [ssFMDatabase executeQuery:sSQLStr];
    
    NSMutableArray* sItems = [[[NSMutableArray alloc]init] autorelease];
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
    return sItems;
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
    
//    BOOL sIsSuccess = [ssFMDatabase executeUpdate:sSQLStr, [NSNumber numberWithBool:aIsMarked], [NSDate distantFuture], [NSNumber numberWithInteger:aItemID]];    
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


