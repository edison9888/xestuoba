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


#if defined(APP_STORE_RELEASE)
#define CHANNEL_ID  @"REAL_APP_STORE"
#elif defined(WEI_PHONE_RELEASE)
#define CHANNEL_ID  @"Weiphone"
#elif (defined(DEBUG) || defined(TEST))
#define CHANNEL_ID  @"test"
#else
#define CHANNEL_ID  @"Other"
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

//wood
#define MAIN_BGCOLOR        [UIColor colorWithRed:RGB_DIV_255(102) green:RGB_DIV_255(57) blue:RGB_DIV_255(26) alpha:1.0f]

#define MAIN_BGCOLOR_TRANSPARENT        [UIColor colorWithRed:RGB_DIV_255(102) green:RGB_DIV_255(57) blue:RGB_DIV_255(26) alpha:0.3f]


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
#define HOST_URL_STR                @"http://localhost/aboutsex"
#else
#define HOST_URL_STR                @"http://aboutsex.sinaapp.com/"
#endif

#define GET_CONF                    ([HOST_URL_STR stringByAppendingPathComponent: @"conf/get_conf.php"])
#define GET_RECOMMANDED_APP_INFO    ([HOST_URL_STR stringByAppendingPathComponent: @"conf/get_recommanded_app_info.php"])
//#define GET_CONF                 @"http://localhost/aboutsex/conf/get_conf.php"

#define GET_STREAM_URL_STR          ([HOST_URL_STR stringByAppendingPathComponent: @"stream/get_stream_json.php"])
#define GET_NEW_STREAM_NUMBER_URL_STR  ([HOST_URL_STR stringByAppendingPathComponent: @"stream/get_new_stream_num_json.php"])


#endif
