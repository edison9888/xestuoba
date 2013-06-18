//
//  SharedVariables.h
//  AboutSex
//
//  Created by Shane Wen on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef AboutSex_SharedVariables_h
#define AboutSex_SharedVariables_h


#define APP_DIR [NSHomeDirectory() stringByAppendingString:@"/"]
#define DATA_PATH [NSHomeDirectory() stringByAppendingString:@"/data/"]
#define HEADER_HEIGHT 35

#define APP_KEY_UMENG   @"500833e652701557bd000054"
#define APP_ID          @"554642574"


#define TEST

#if defined(APP_STORE_RELEASE)
#define CHANNEL_ID  @"REAL_APP_STORE"
#define CHANNEL_ID_INT  1
#elif defined(WEI_PHONE_RELEASE)
#define CHANNEL_ID  @"Weiphone"
#define CHANNEL_ID_INT  2
#elif defined(_91STORE_RELEASE)
#define CHANNEL_ID  @"91store"
#define CHANNEL_ID_INT  3
#elif defined(TONGBU_RELEASE)
#define CHANNEL_ID  @"tongbu"
#define CHANNEL_ID_INT  4
#elif (defined(DEBUG) || defined(TEST))
#define CHANNEL_ID  @"test"
#define CHANNEL_ID_INT  1000
#else
#define CHANNEL_ID  @"Other"
#define CHANNEL_ID_INT  -1
#endif




#define SECTION_NAME_STREAM         @"stream"
//#define SECTION_NAME_COMMONSENSE    @"commonsense"
//#define SECTION_NAME_HELATH         @"health"
//#define SECTION_NAME_SKILLS         @"skills"
//#define SECTION_NAME_PSYCHOLOGY     @"psychology"


#define SECTION_NAME_PHYSILOGY      @"physiology"
#define SECTION_NAME_HEALTH         @"health"
#define SECTION_NAME_DIET           @"diet"
#define SECTION_NAME_LIFE           @"life"
#define SECTION_NAME_CONTRACEPTION  @"contraception"
#define SECTION_NAME_PREGNANCY      @"pregnancy"
#define SECIION_NAME_CULTURE        @"culture"
#define SECTION_NAME_TERMS          @"terms"



#define RGB_DIV_255(x)      ((CGFloat)(x/255.0))

#define RGBA_COLOR(r, g, b, a)   ([UIColor colorWithRed:RGB_DIV_255(r) green:RGB_DIV_255(g) blue:RGB_DIV_255(b) alpha:a])

//wood
#define MAIN_BGCOLOR        [UIColor colorWithRed:RGB_DIV_255(102) green:RGB_DIV_255(57) blue:RGB_DIV_255(26) alpha:1.0f]

#define MAIN_BGCOLOR_TRANSPARENT        [UIColor colorWithRed:RGB_DIV_255(102) green:RGB_DIV_255(57) blue:RGB_DIV_255(26) alpha:0.3f]

#define MAIN_BGCOLOR_SHALLOW          [UIColor colorWithRed:RGB_DIV_255(151) green:RGB_DIV_255(121) blue:RGB_DIV_255(100) alpha:1.0f]

#define COLOR_PROGRESS                  RGBA_COLOR(255, 118, 42, 1)

#define COLOR_OTHER                     RGBA_COLOR(145, 156, 118, 1)

//orange
//#define MAIN_BGCOLOR        [UIColor colorWithRed:RGB_DIV_255(255) green:RGB_DIV_255(81) blue:RGB_DIV_255(61) alpha:1.0f]

//
//#define MAIN_BGCOLOR        [UIColor colorWithRed:RGB_DIV_255(207) green:RGB_DIV_255(201) blue:RGB_DIV_255(172) alpha:1.0f]

//purple
//#define MAIN_BGCOLOR        [UIColor colorWithRed:RGB_DIV_255(82) green:RGB_DIV_255(40) blue:RGB_DIV_255(106) alpha:1.0f]

//#define CELL_BGCOLOR        [UIColor colorWithRed:RGB_DIV_255(248) green:RGB_DIV_255(203) blue:RGB_DIV_255(48) alpha:1.0f]

//#define CELL_BGCOLOR        [UIColor colorWithRed:RGB_DIV_255(234) green:RGB_DIV_255(182) blue:RGB_DIV_255(58) alpha:1.0f]

#define CELL_BGCOLOR        [UIColor colorWithRed:RGB_DIV_255(239) green:RGB_DIV_255(210) blue:RGB_DIV_255(84) alpha:1.0f]


//#define CELL_BGCOLOR        [UIColor colorWithRed:RGB_DIV_255(135) green:RGB_DIV_255(122) blue:RGB_DIV_255(85) alpha:1.0f]

//#define CELL_BGCOLOR    [UIColor colorWithRed:RGB_DIV_255(191) green:RGB_DIV_255(181) blue:RGB_DIV_255(152) alpha:1.0f]



//#define TAB_PAGE_BGCOLOR    [UIColor colorWithRed:RGB_DIV_255(223) green:RGB_DIV_255(223) blue:RGB_DIV_255(223) alpha:1.0f]

#define TAB_PAGE_BGCOLOR    [UIColor colorWithRed:RGB_DIV_255(255) green:RGB_DIV_255(255) blue:RGB_DIV_255(255) alpha:1.0f]

//#define TAB_PAGE_BGCOLOR    [UIColor colorWithRed:RGB_DIV_255(229) green:RGB_DIV_255(224) blue:RGB_DIV_255(186) alpha:1.0f]


//#define TAB_PAGE_BGCOLOR    [UIColor colorWithRed:RGB_DIV_255(135) green:RGB_DIV_255(122) blue:RGB_DIV_255(85) alpha:1.0f]

//#define TAB_PAGE_BGCOLOR    [UIColor colorWithRed:RGB_DIV_255(191) green:RGB_DIV_255(191) blue:RGB_DIV_255(191) alpha:1.0f]


//#define TAB_PAGE_BGCOLOR    [UIColor colorWithRed:RGB_DIV_255(238) green:RGB_DIV_255(238) blue:RGB_DIV_255(238) alpha:1.0f]


//#define SELECTED_CELL_COLOR  [UIColor colorWithRed:RGB_DIV_255(214) green:RGB_DIV_255(214) blue:RGB_DIV_255(214) alpha:1.0f]

#define SELECTED_CELL_COLOR  [UIColor colorWithRed:RGB_DIV_255(230) green:RGB_DIV_255(223) blue:RGB_DIV_255(195) alpha:1.0f]


#define POPOVER_HEADER_COLOR  [UIColor colorWithRed:RGB_DIV_255(230) green:RGB_DIV_255(223) blue:RGB_DIV_255(195) alpha:1.0f]

#define POPOVER_TABLEVIEW_COLOR  [UIColor colorWithRed:RGB_DIV_255(246) green:RGB_DIV_255(246) blue:RGB_DIV_255(236) alpha:1.0f]

#define COLOR_ACTIVITY_INDICATOR    [UIColor colorWithRed:RGB_DIV_255(102) green:RGB_DIV_255(57) blue:RGB_DIV_255(26) alpha:0.7f]

#ifdef LOCAL_SERVER
#define HOST_URL_STR                @"http://localhost/aboutsex/"
#else
#define HOST_URL_STR                @"http://aboutsex.sinaapp.com/"
#endif

#define GET_CONF                    ([HOST_URL_STR stringByAppendingString: @"conf/get_conf.php"])
#define GET_RECOMMANDED_APP_INFO    ([HOST_URL_STR stringByAppendingString: @"conf/get_recommanded_app_info.php"])
//#define GET_CONF                 @"http://localhost/aboutsex/conf/get_conf.php"

#define GET_STREAM_URL_STR              ([HOST_URL_STR stringByAppendingString: @"stream/get_stream_json.php"])
#define GET_NEW_STREAM_NUMBER_URL_STR   ([HOST_URL_STR stringByAppendingString: @"stream/get_new_stream_num_json.php"])

#define URL_GET_COMMENTS(itemID,pageIndex,pageSize) [HOST_URL_STR stringByAppendingFormat:@"stream/get_comments.php?itemID=%d&pageIndex=%d&pageSize=%d",itemID,pageIndex,pageSize]

#define URL_GET_HOT_STREAM             ([HOST_URL_STR stringByAppendingString: @"stream/get_hot_stream.php"])

#define URL_GET_HOT_COMMENTS            [HOST_URL_STR stringByAppendingFormat:@"stream/get_hot_comments.php"]

#define URL_GET_GROUP_STREAM           ([HOST_URL_STR stringByAppendingString: @"stream/get_group_stream.php"])

#define URL_POST_COMMENT            ([HOST_URL_STR stringByAppendingString: @"stream/post_comments.php"])

#define URL_COLLECT_ITEM            ([HOST_URL_STR stringByAppendingString: @"stream/collect_item.php"])
#define URL_LIKE_ITEM               ([HOST_URL_STR stringByAppendingString: @"stream/like_item.php"])

#define URL_DING_COMMENT(itemID)        [HOST_URL_STR stringByAppendingFormat:@"stream/ding_comment.php?commentID=%d",itemID]

#define URL_CAI_COMMENT(itemID)           [HOST_URL_STR stringByAppendingFormat:@"stream/cai_comment.php?commentID=%d",itemID]

#define URL_GET_FMS(pageIndex,pageSize, type) [HOST_URL_STR stringByAppendingFormat:@"fm/get_fms.php?pageIndex=%d&pageSize=%d&type=%d",pageIndex,pageSize, type]


#define KEY_ADSMOGO             @"9e668f6ebf204b3290eda237d46e2d16"

#define SECRET_KEY_GUOMENG      @"nir0wu1a2kqgsj5253"

#define  SECRET_ID_YOUMI            @"409af00a69e0d5c4" // youmi default app id //not used
#define  SECRET_KEY_YOUMI       @"2903fc23a8fb13f3" // youmi default app secret //not used

#define AD_MIIDI_ID         @"12555"
#define AD_MIIID_KEY        @"yxoqqivrmcc8meuv"

#define AD_DIANRU_ID           @"0000AE0D0E0000CE"

#define AD_WAPS_ID          @"c6a921055699715be98b3d01bcc748bb"

#define MOBWIN_ID           @"5E9765F3D4447CD5021547EF8C3BC382"

#define CACHE_FILE_HOT_STREAMS @"hot_streams.data"
#define CACHE_FILE_HOT_COMMENTS @"hot_comments.data"



//notification
#define NOTIFICATION_NEW_FM_DOWNLOADED          @"FM_Downloaded"



//
#define DEFAULTS_CURRENT_POINTS         @"defaults_current_points"

#endif
