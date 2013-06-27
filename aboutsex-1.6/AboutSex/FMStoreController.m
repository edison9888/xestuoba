//
//  FMStoreTabController.m
//  AboutSex
//
//  Created by Wen Shane on 13-6-14.
//
//

#import "FMStoreController.h"
#import "SharedVariables.h"
#import "NSDateFormatter+MyDateFormatter.h"

@interface FMStoreController ()
{
    NSDate* mUpdateDate;
    UILabel* mDateLabel;
}

@property (nonatomic, retain) NSDate* mUpdateDate;
@property (nonatomic, retain) UILabel* mDateLabel;
@end

@implementation FMStoreController
@synthesize mUpdateDate;
@synthesize mDateLabel;


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

        S_FMStoreTabController = [[self alloc] initWithViewControllers:sViewControllers style:ENUM_SIMPLE_TAB_CONTROLLER_STYLE1 yOffset:44 InitSelectedIndex:0];
    
        //
        sAffectionController.mDelegate = S_FMStoreTabController;
        sSexController.mDelegate = S_FMStoreTabController;
        sHealthController.mDelegate = S_FMStoreTabController;
        sMusicController.mDelegate = S_FMStoreTabController;
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

- (void) dealloc
{
    self.mUpdateDate = nil;
    self.mDateLabel = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UINavigationBar *sNavBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320,44)] autorelease];
    sNavBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    sNavBar.tintColor = MAIN_BGCOLOR;
    [self.view addSubview:sNavBar];

    //
    UINavigationItem* sPreviousItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"FM", nil)];
    UINavigationItem* sCurrentItem = [[UINavigationItem alloc] initWithTitle:self.title];

    UILabel* sLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    sLabel.font = [UIFont systemFontOfSize:10];
    sLabel.textColor = [UIColor lightGrayColor];
    sLabel.numberOfLines = 0;
    sLabel.backgroundColor = [UIColor clearColor];
    sLabel.textAlignment = UITextAlignmentRight;
    UIBarButtonItem* sUpdateDateItem = [[UIBarButtonItem alloc] initWithCustomView:sLabel];
    [sCurrentItem setRightBarButtonItem:sUpdateDateItem];
    self.mDateLabel = sLabel;
    
    [sNavBar setItems:[NSArray arrayWithObjects:sPreviousItem, sCurrentItem, nil]
                   animated:YES];
    sNavBar.delegate = self;

    [sPreviousItem release];
    [sCurrentItem release];
    [sUpdateDateItem release];
    [sLabel release];
    
    //
    [self addObserver:self forKeyPath:@"mUpdateDate" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
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

#pragma mark - NSKeyValueObserving protocol
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        
        if([keyPath isEqualToString:@"mUpdateDate"])
        {
            if (self.mUpdateDate)
            {
                NSString* sDateStr = [NSDateFormatter lastUpdateTimeStringForDate:self.mUpdateDate];
                [self.mDateLabel setText:[NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"FMStore Update time", nil), sDateStr]];
            }
            else
            {
                [self.mDateLabel setText:@""];
            }
        }
        else
        {
            //nothing done.
        }
    });
}

#pragma mark - FMListControllerDelegate
- (void) notifyUpdateDate:(NSDate*)aDate
{
    self.mUpdateDate = aDate;
}

#pragma mark -  UINavigationBarDelegate
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

@end
