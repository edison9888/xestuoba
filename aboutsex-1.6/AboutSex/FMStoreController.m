//
//  FMStoreTabController.m
//  AboutSex
//
//  Created by Wen Shane on 13-6-14.
//
//

#import "FMStoreController.h"
#import "FMListController.h"

@interface FMStoreController ()

@end

@implementation FMStoreController

+ (UIViewController*) shared
{
    static FMStoreController* S_FMStoreTabController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FMListController* sAffectionController = [[[FMListController alloc] initWithType:ENUM_FM_LIST_TYPE_AFFECTION] autorelease];
        FMListController* sSexController = [[[FMListController alloc] initWithType:ENUM_FM_LIST_TYPE_SEX] autorelease];
        FMListController* sHealthController = [[[FMListController alloc] initWithType:ENUM_FM_LIST_TYPE_HEALTH] autorelease];
        FMListController* sMusicController = [[[FMListController alloc] initWithType:ENUM_FM_LIST_TYPE_MUSIC] autorelease];
        [sAffectionController setSimpleTabBarItem:[SimpleTabBarItem itemWithTitle: NSLocalizedString(@"Affection mp3", nil)]];
        [sSexController setSimpleTabBarItem:[SimpleTabBarItem itemWithTitle: NSLocalizedString(@"Sex mp3", nil)]];
        [sHealthController setSimpleTabBarItem:[SimpleTabBarItem itemWithTitle: NSLocalizedString(@"Health mp3", nil)]];
        [sMusicController setSimpleTabBarItem:[SimpleTabBarItem itemWithTitle: NSLocalizedString(@"Music mp3", nil)]];

        NSArray* sViewControllers = [NSArray arrayWithObjects: sAffectionController, sSexController, sHealthController, sMusicController, nil];

        S_FMStoreTabController = [[self alloc] initWithViewControllers:sViewControllers style:ENUM_SIMPLE_TAB_CONTROLLER_STYLE1 yOffset:0 InitSelectedIndex:0];
    });
    return S_FMStoreTabController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"FM Store", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
