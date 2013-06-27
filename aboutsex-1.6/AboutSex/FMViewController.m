//
//  FMViewController.m
//  AboutSex
//
//  Created by Wen Shane on 13-4-20.
//
//

#import "FMViewController.h"
#import "SharedVariables.h"
#import "StoreManagerEx.h"
#import "FMItem.h"
#import "SharedStates.h"
#import "NSDateFormatter+MyDateFormatter.h"
#import "TaggedButton.h"
#import "FMStoreController.h"
#import "SpotTimer.h"
//#import "MLPAccessoryBadgeArrow.h"
#import "UIColor+MLPFlatColors.h"
#import "MyProgressView.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "MobClick.h"


#define INVALID_INDEX  -1
#define REFRESH_TIME_INTERVAL 0.2

#define TAG_EDGE_STICK 100
#define TAG_TITLE_LABEL 101
#define TAG_DURATION_LABEL 102
#define TAG_DELETE_BUTTON 103

@interface FMViewController ()
{
    UITableView*    mTableView;
    NSMutableArray* mFMItems;
    NSInteger       mSelectedIndex;
    AVAudioPlayer*  mPlayer;
    
    
    //
    UIButton* mPlayButton;
    MyProgressView* mProgressView;
    UIImageView* mArtworkImageView;
    UILabel* mTitleLabel;
    UILabel* mCurrentTimeLabel;
    UILabel* mDurationLabel;
    
    NSTimer* mRefreshTimer;
    
    
    NSInteger mIndexToDelete;
    
    //
//    FMStoreController* mStoreController;

}
@property (nonatomic, retain)     UITableView* mTableView;
@property (nonatomic, retain)     NSMutableArray* mFMItems;
@property (nonatomic, assign)     NSInteger mSelectedIndex;
@property (nonatomic, retain)     AVAudioPlayer*  mPlayer;
@property (nonatomic, retain)     UIButton* mPlayButton;
@property (nonatomic, retain)     MyProgressView* mProgressView;
@property (nonatomic, retain)     UIImageView* mArtworkImageView;
@property (nonatomic, retain)     UILabel* mTitleLabel;
@property (nonatomic, retain)     UILabel* mCurrentTimeLabel;
@property (nonatomic, retain)     UILabel* mDurationLabel;

@property (nonatomic, retain)     NSTimer* mRefreshTimer;
@property (nonatomic, assign)     NSInteger mIndexToDelete;
//@property (nonatomic, retain)     FMStoreController* mStoreController;
@end

@implementation FMViewController
@synthesize mTableView;
@synthesize mFMItems;
@synthesize mSelectedIndex;
@synthesize mPlayer;
@synthesize mPlayButton;
@synthesize mProgressView;
@synthesize mArtworkImageView;
@synthesize mTitleLabel;
@synthesize mCurrentTimeLabel;
@synthesize mDurationLabel;
@synthesize mRefreshTimer;
@synthesize mIndexToDelete;
//@synthesize mStoreController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mSelectedIndex = INVALID_INDEX;
        self.mIndexToDelete = INVALID_INDEX;
    }
    return self;
}

- (id) initWithTitle:(NSString*)aTitle
{
    self = [super init];
    if (self)
    {
        if (aTitle)
        {
            self.navigationItem.title = aTitle;
            self.mFMItems = [NSMutableArray array];
            
            //
            [self reloadFMItems];
            
            NSInteger sLastSelectedIndex = [[SharedStates getInstance] getLastIndexOFFMItem];
            NSTimeInterval sLastCurrentTime = [[SharedStates getInstance] getLasCurrentTimeOfFMItem];
            
            if (sLastSelectedIndex != INVALID_INDEX)
            {
                self.mSelectedIndex = sLastSelectedIndex;
            }
            
            //prepare the player for the last fm item.
            if (sLastSelectedIndex != INVALID_INDEX)
            {
                dispatch_async( dispatch_get_main_queue(), ^
                {
                    [self view];//just force loadView to be invoked
                    [self waitItemAtIndex:sLastSelectedIndex At:sLastCurrentTime];
                });
            }
 
            //
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newFMDownloaded) name:NOTIFICATION_NEW_FM_DOWNLOADED object:nil];
        }
        
    }
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.mTableView = nil;
    self.mFMItems = nil;
    self.mPlayer = nil;
    self.mPlayButton = nil;
    self.mProgressView = nil;
    self.mArtworkImageView = nil;
    self.mTitleLabel = nil;
    self.mCurrentTimeLabel = nil;
    self.mDurationLabel = nil;
    self.mRefreshTimer = nil;
//    self.mStoreController = nil;
    
    [super dealloc];
}

- (void) loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    applicationFrame.size.height -= 49;
    
    UIView* sView = [[UIView alloc] initWithFrame:applicationFrame];
    sView.backgroundColor = [UIColor whiteColor];
    self.view = sView;
    [sView release];
   
    CGFloat sX = 0;
    CGFloat sY = 0;
    CGFloat sWidth = self.view.bounds.size.width;
    CGFloat sHeight = 65;
    
    //
    UINavigationBar *navBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,sWidth,sHeight)] autorelease];
    navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    navBar.tintColor = MAIN_BGCOLOR;
    [self.view addSubview:navBar];

    UIImageView* sImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
    sImageView.layer.cornerRadius = 2;
    sImageView.contentMode = UIViewContentModeScaleAspectFit;
    sImageView.layer.masksToBounds = YES; 
    [navBar addSubview:sImageView];
    
    self.mArtworkImageView = sImageView;
    [sImageView release];
    
    
    UILabel* sCurrentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, 35, 12)];
    sCurrentTimeLabel.backgroundColor = [UIColor clearColor];
    sCurrentTimeLabel.font = [UIFont systemFontOfSize:12];
    sCurrentTimeLabel.textAlignment = UITextAlignmentCenter;
    sCurrentTimeLabel.textColor = [UIColor grayColor];
    [navBar addSubview:sCurrentTimeLabel];
    self.mCurrentTimeLabel = sCurrentTimeLabel;
    [sCurrentTimeLabel release];

    UILabel* sSeperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 30, 1, 12)];
    sSeperatorLabel.backgroundColor = [UIColor grayColor];
    [navBar addSubview:sSeperatorLabel];
    [sSeperatorLabel release];
    
    UILabel* sDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(88, 30, 35, 12)];
    sDurationLabel.backgroundColor = [UIColor clearColor];
    sDurationLabel.font = [UIFont systemFontOfSize:12];
    sDurationLabel.textAlignment = UITextAlignmentCenter;
    sDurationLabel.textColor = [UIColor grayColor];
    [navBar addSubview:sDurationLabel];
    self.mDurationLabel = sDurationLabel;
    [sDurationLabel release];
    
    UILabel* sTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 230, 15)];
    sTitleLabel.backgroundColor = [UIColor clearColor];
    sTitleLabel.textColor = [UIColor whiteColor];
    sTitleLabel.font = [UIFont systemFontOfSize:13];
    [navBar addSubview:sTitleLabel];
    self.mTitleLabel = sTitleLabel;
    [sTitleLabel release];
    
    UIButton* sPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sPlayBtn setImage:[UIImage imageNamed:@"play36"] forState:UIControlStateNormal];
    [sPlayBtn setImage:[UIImage imageNamed:@"pause36"] forState:UIControlStateSelected];
    [sPlayBtn addTarget:self  action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [sPlayBtn setFrame:CGRectMake(140, 20, 36, 36)];
    [navBar addSubview:sPlayBtn];
    self.mPlayButton = sPlayBtn;
    
    UIButton* sNextTrack = [UIButton buttonWithType:UIButtonTypeCustom];
    [sNextTrack setImage:[UIImage imageNamed:@"nexttrack30"] forState:UIControlStateNormal];
    [sNextTrack addTarget:self action:@selector(nextTrack) forControlEvents:UIControlEventTouchUpInside];
    [sNextTrack setFrame:CGRectMake(190, 23, 32, 32)];
    [navBar addSubview:sNextTrack];
    
//    UIProgressView* sProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
//    [sProgressView setFrame:CGRectMake(50, 55, 230, 1)];
//    [sProgressView setTrackTintColor:MAIN_BGCOLOR];
//    [sProgressView setProgressTintColor:[UIColor grayColor]];
//    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, .3f);
//    sProgressView.transform = transform;
    MyProgressView* sProgressView= [[MyProgressView alloc] initWithFrame:CGRectMake(50, 57, 230, 1) andTrackColor:RGBA_COLOR(119, 79, 52, 1) ProgressColor:[UIColor grayColor]];
    //RGBA_COLOR(131, 98, 77, 1)
    //RGBA_COLOR(54, 158, 227, 1)
    //RGBA_COLOR(179, 157, 141, 1)
    [navBar addSubview:sProgressView];
    self.mProgressView = sProgressView;
    [sProgressView release];
    
    TaggedButton* sFMStoreButton = [TaggedButton buttonWithType:UIButtonTypeCustom];
    [sFMStoreButton setImage:[UIImage imageNamed:@"add24"] forState:UIControlStateNormal];

    sFMStoreButton.frame = CGRectMake(0, 0, 24, 24);
    sFMStoreButton.mMarginInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    [sFMStoreButton setCenter:CGPointMake(300, navBar.bounds.size.height/2)];
    //    sRefreshButton.showsTouchWhenHighlighted = YES;
    [sFMStoreButton addTarget:self action:@selector(presentFMStore) forControlEvents:UIControlEventTouchDown];
    [navBar addSubview:sFMStoreButton];
    
    
        
    sY += sHeight;
    sHeight = self.view.bounds.size.height - sY;
    //tableview
    UITableView* sTableView = [[UITableView alloc]initWithFrame:CGRectMake(sX, sY, sWidth, sHeight) style:UITableViewStylePlain];
    sTableView.dataSource = self;
    sTableView.delegate = self;
    [sTableView setBackgroundView:nil];
    [sTableView setBackgroundColor:[UIColor clearColor]];
    sTableView.rowHeight = 60;
//    sTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    sTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self.view addSubview:sTableView];
    self.mTableView = sTableView;
    [sTableView release];
    
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];

    [self updatePlayingInfo];
    [MobClick beginLogPageView:@"FMViewController"];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];

//    [[SpotTimer shared] startWithDelay:30];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"FMViewController"];
    
//    [[SpotTimer shared] cancel];
}

- (void) newFMDownloaded
{
    [self reloadFMItems];
    [self updatePlayingInfo];
}

- (FMItem*) getSelectedItem
{
    FMItem* sItem = nil;
    if (self.mSelectedIndex >=0
        && self.mSelectedIndex < self.mFMItems.count)
    {
        sItem = [self.mFMItems objectAtIndex:self.mSelectedIndex];
    }
    return sItem;
}

- (void) reloadFMItems
{
    //
    NSMutableArray* sTempItems = [NSMutableArray array];
    
    NSString* sFMItemsDir = [[StoreManagerEx shared] getPathForDocumentsFMItemsDir];
    
    NSArray* sSampleStreamFileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sFMItemsDir error:nil];
    
    FMItem* sSelectedItem = [self getSelectedItem];
    NSInteger sNewSelectedIndex = INVALID_INDEX;
    
    //
    for (NSString* sSampleFileName in sSampleStreamFileNames)
    {
        if (sSampleFileName.length>1)
        {
            FMItem* sItem = [[FMItem alloc] initWithFilepath:[sFMItemsDir stringByAppendingPathComponent:sSampleFileName]];
            [sTempItems addObject:sItem];
            [sItem release];
        }
    }
    
    //sort by modification date
    [sTempItems sortUsingComparator: ^NSComparisonResult(id obj1, id obj2) {
        FMItem* sItem1 = (FMItem*)obj1;
        FMItem* sItem2 = (FMItem*)obj2;
        return [sItem1.mBoughtTime compare:sItem2.mBoughtTime];
    }];
    
    
    //update selected index accordingly
    NSInteger i = 0;
    for (FMItem* sItem in sTempItems)
    {
        if ([sSelectedItem isEqual:sItem])
        {
            sNewSelectedIndex = i;
            break;
        }
        i++;
    }
    
    //take effect
    self.mFMItems = sTempItems;
    self.mSelectedIndex = sNewSelectedIndex;

    //
    [self.mTableView reloadData];
}

- (void) ensureAudioSessioinActivite
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
    });
}

- (void) play:(UIButton*)aPlayBtn
{
    if (self.mPlayer)
    {
        if (self.mPlayer.playing)
        {
            [self.mPlayer pause];
            [self.mRefreshTimer invalidate];
        }
        else
        {
            [self ensureAudioSessioinActivite];
            
            [self.mPlayer play];
            [self startUpdatingProgress];
            
            [MobClick event:@"UEID_PLAY"];
        }
        [self.mPlayButton setSelected:self.mPlayer.playing];
    }
    //
//    [[SpotTimer shared] startWithDelay:30];

}

- (BOOL)canGoToNextTrack
{
	if (self.mSelectedIndex == INVALID_INDEX
        || self.mSelectedIndex >= self.mFMItems.count-1)
    {
   		return NO;
    }
	else
    {
  		return YES;
    }
}

- (void) nextTrack
{
    if ([self canGoToNextTrack])
    {
        NSInteger sNewSelectedIndex = self.mSelectedIndex+1;
        [self playItemAtIndex:sNewSelectedIndex];
    }
    else
    {
        NSLog(@"There is no next track.");
    }
    
    return;
}

- (void) startUpdatingProgress
{
    [self.mRefreshTimer invalidate];    
    self.mRefreshTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:REFRESH_TIME_INTERVAL target:self selector:@selector(updataPlayingProgress) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.mRefreshTimer forMode:NSRunLoopCommonModes];
}

- (void) updataPlayingProgress
{
    if (self.mPlayer.playing)
    {
        float sProgress = 0;
        if (self.mPlayer.duration > 0)
        {
            sProgress = self.mPlayer.currentTime/self.mPlayer.duration;
        }
        [self.mProgressView setProgress:sProgress];
        
        self.mCurrentTimeLabel.text = [NSDateFormatter mmssFromSeconds:self.mPlayer.currentTime];
    }
}

- (void) updatePlayingInfo
{    
    [self.mPlayButton setSelected:self.mPlayer.playing];
    
    FMItem* sSelectedItem = [self getSelectedItem];
    if (sSelectedItem)
    {
        self.mTitleLabel.text = [sSelectedItem getTitle];
        self.mCurrentTimeLabel.text = [NSDateFormatter mmssFromSeconds:self.mPlayer.currentTime];
        self.mDurationLabel.text = [NSDateFormatter mmssFromSeconds:[sSelectedItem getDuration]];
        self.mArtworkImageView.image = [sSelectedItem getCoverImage];
    }
    else
    {
        self.mTitleLabel.text = NSLocalizedString(@"No item played", nil);
        self.mCurrentTimeLabel.text = @"--:--";
        self.mDurationLabel.text = @"--:--";
        self.mArtworkImageView.image = [UIImage imageNamed:@"music32"];
    }
    
    if (!self.mArtworkImageView.image)
    {
        self.mArtworkImageView.image = [UIImage imageNamed:@"music32"];
    }
    
    if (self.mFMItems.count == 0)
    {
        UIView* sView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        UILabel* sLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 220, 100)];
        sLabel.numberOfLines = 2;
        sLabel.text = NSLocalizedString(@"You have no fms yet", nil);
        sLabel.textColor = [UIColor lightGrayColor];
        sLabel.textAlignment = UITextAlignmentCenter;
        sLabel.backgroundColor = [UIColor clearColor];
        [sView addSubview:sLabel];
        [sLabel release];
        
        self.mTableView.tableHeaderView = sView;
        [sView release];
    }
    else
    {
        self.mTableView.tableHeaderView = nil;
    }
    
    [self.mTableView reloadData];
    return;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) presentFMStore
{
    [[FMStoreController shared] setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:[FMStoreController shared] animated:YES];
    
    [MobClick event:@"UEID_FM_STORE_VIEW"];
    
    return;
}

- (void) waitItemAtIndex:(NSInteger)aIndex At:(NSTimeInterval)aCurrentTime
{
    if (aIndex < 0
        || aIndex >= self.mFMItems.count)
    {
        return;
    }

    [self goToItemAtIndex:aIndex AtTime:aCurrentTime playImmediately:NO];
    
}

- (void) playItemAtIndex:(NSInteger)aIndex
{
    if (aIndex < 0
        || aIndex >= self.mFMItems.count)
    {
        return;
    }
    
    if (self.mPlayer)
    {
        [self.mPlayer stop];
    }
    
    [self goToItemAtIndex:aIndex AtTime:0 playImmediately:YES];
    [MobClick event:@"UEID_PLAY"];

//    [[SpotTimer shared] startWithDelay:30];
}

- (void) goToItemAtIndex:(NSInteger)aIndex AtTime:(NSTimeInterval)aTime playImmediately:(BOOL)aPlayImmediately
{
    FMItem* sItem = [self.mFMItems objectAtIndex:aIndex];
    AVAudioPlayer*  sPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:sItem.mFileURL error:nil];
	
	sPlayer.delegate = self;
    //	sPlayer.volume = volumeSlider.value;
	[sPlayer prepareToPlay];
    
	if (aTime > 0
        && aTime < sPlayer.duration)
    {
        sPlayer.currentTime = aTime;
    }
    
    self.mPlayer = sPlayer;
    [sPlayer release];
  
    self.mSelectedIndex = aIndex;
    [self updatePlayingInfo];

    if (aPlayImmediately)
    {
        [self ensureAudioSessioinActivite];

        [self.mPlayer play];
        [self.mPlayButton setSelected:YES];
        [self startUpdatingProgress];
    }
    
    //
    [[SharedStates getInstance] setFMItemIndex:self.mSelectedIndex];
}


#pragma mark -
#pragma mark AVAudioPlayer delegate


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag
{
	if (flag == NO)
		NSLog(@"Playback finished unsuccessfully");
	
	if ([self canGoToNextTrack])
    {
        [self nextTrack];
    }
    else
    {
        [self.mRefreshTimer invalidate];
        [self updatePlayingInfo];
    }
}

- (void)playerDecodeErrorDidOccur:(AVAudioPlayer *)p error:(NSError *)error
{
	NSLog(@"ERROR IN DECODE: %@\n", error);	
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
	// perform any interruption handling here
	printf("(apbi) Interruption Detected\n");
	[[NSUserDefaults standardUserDefaults] setFloat:[self.mPlayer currentTime] forKey:@"Interruption"];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
	// resume playback at the end of the interruption
	printf("(apei) Interruption ended\n");
	[self.mPlayer play];
	
	// remove the interruption key. it won't be needed
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Interruption"];
}

- (void) removeItem:(TaggedButton*)aButton
{
    if (aButton.mIndexPath.row>=0
        && aButton.mIndexPath.row < self.mFMItems.count)
    {
        self.mIndexToDelete = aButton.mIndexPath.row;
        
        
        FMItem* sItem = [self.mFMItems objectAtIndex: aButton.mIndexPath.row];
        NSString* sMessage = [NSString stringWithFormat:@"%@\n\"%@\"", NSLocalizedString(@"Do you really want to delete", nil), sItem.getTitle];
        UIAlertView* sAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Notice", nil) message:sMessage  delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Ok", nil), nil];
        [sAlertView show];
        [sAlertView release];
        
        return;
    }
}

#pragma mark -
#pragma mark delegate for update checking's alertview
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        self.mIndexToDelete = INVALID_INDEX;
        return;
    }
    else
    {
        if (self.mIndexToDelete >= 0
            && self.mIndexToDelete < self.mFMItems.count)
        {
            if (self.mIndexToDelete == self.mSelectedIndex)
            {
                [self.mPlayer stop];
                self.mPlayer = nil;
                [self.mProgressView setProgress:.0f];
                self.mSelectedIndex = INVALID_INDEX;
            }
            
            //delete the file on disk
            FMItem* sItem = [self.mFMItems objectAtIndex:self.mIndexToDelete];
            if ([sItem suicideOnDisk])
            {
                //delete items in memory
                [self.mFMItems removeObjectAtIndex:self.mIndexToDelete];
                
                //
                if (self.mFMItems.count <= 0)
                {
                    [self.mPlayer stop];
                    self.mPlayer = nil;
                }
                
                //delete row
                NSArray *sIndexPathes = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.mIndexToDelete inSection:0]];
                [self.mTableView deleteRowsAtIndexPaths:sIndexPathes withRowAnimation:UITableViewRowAnimationRight];
                
                [self reloadFMItems];
                [self updatePlayingInfo];
                
            }

        }
    }
}

#pragma mark - tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger sNumItems = self.mFMItems.count;
    
    return sNumItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* sCellID = @"cell";
    
    
    UILabel* sEdgeStick = nil;
    UILabel* sTitleLabel = nil;
    UILabel* sDurationLabel = nil;
    TaggedButton* sDelButton = nil;
    UITableViewCell* sCell = [tableView dequeueReusableCellWithIdentifier:sCellID];
    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: sCellID] autorelease];
        sCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        sEdgeStick = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 3, 32)];
        [sEdgeStick setCenter:CGPointMake(sEdgeStick.center.x, tableView.rowHeight/2+2)];
        sEdgeStick.backgroundColor = MAIN_BGCOLOR;
        sEdgeStick.tag = TAG_EDGE_STICK;
        sEdgeStick.hidden = YES;
        
        [sCell.contentView addSubview:sEdgeStick];
        [sEdgeStick release];
        
        
        sTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 250, 25)];
        sTitleLabel.backgroundColor = [UIColor clearColor];
        sTitleLabel.tag = TAG_TITLE_LABEL;
        sTitleLabel.font = [UIFont systemFontOfSize:15];
//        sTitleLabel.textColor = MAIN_BGCOLOR;
        [sCell.contentView addSubview:sTitleLabel];
        [sTitleLabel release];
        
        sDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 35, 250, 15)];
        sDurationLabel.backgroundColor = [UIColor clearColor];
        sDurationLabel.tag = TAG_DURATION_LABEL;
        sDurationLabel.font = [UIFont systemFontOfSize:11];
        sDurationLabel.textColor = [UIColor lightGrayColor];
        [sCell.contentView addSubview:sDurationLabel];
        [sDurationLabel release];

        
        sDelButton = [TaggedButton buttonWithType:UIButtonTypeCustom];
        [sDelButton setFrame:CGRectMake(290, 0, 17, 17)];
        sDelButton.mMarginInsets = UIEdgeInsetsMake(10, 10, 15, 10);
        [sDelButton setCenter:CGPointMake(sDelButton.center.x, sCell.bounds.size.height/2)];
        [sDelButton setImage:[UIImage imageNamed:@"recyle24"] forState:UIControlStateNormal];
        [sDelButton addTarget:self  action:@selector(removeItem:) forControlEvents:UIControlEventTouchUpInside];
        sDelButton.tag = TAG_DELETE_BUTTON;
        
        [sCell.contentView addSubview:sDelButton];
        
        
        UIView* sSeperatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, tableView.rowHeight-1, sCell.bounds.size.width, 1)];
        sSeperatorLineView.backgroundColor = RGBA_COLOR(222, 222, 222, 1);
        sSeperatorLineView.layer.shadowColor = [RGBA_COLOR(224, 224, 224, 1) CGColor];
        sSeperatorLineView.layer.shadowOffset = CGSizeMake(0, -10);
        sSeperatorLineView.layer.shadowOpacity = .5f;
        sSeperatorLineView.layer.shadowRadius = 2.0f;
        sSeperatorLineView.clipsToBounds = NO;
        sSeperatorLineView.layer.cornerRadius = 2;
        
        [sCell.contentView addSubview:sSeperatorLineView];
        [sSeperatorLineView release];
    }
    else
    {
        sEdgeStick = (UILabel*)[sCell.contentView viewWithTag:TAG_EDGE_STICK];
        sTitleLabel = (UILabel*)[sCell.contentView viewWithTag:TAG_TITLE_LABEL];
        sDurationLabel = (UILabel*)[sCell.contentView viewWithTag:TAG_DURATION_LABEL];
        sDelButton = (TaggedButton*)[sCell.contentView viewWithTag:TAG_DELETE_BUTTON];
    }
    
    FMItem* sItem = [self.mFMItems objectAtIndex:indexPath.row];
    
    sTitleLabel.text = [sItem getTitle];
    
    sDurationLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Duration", nil), [NSDateFormatter mmssFromSeconds:[sItem getDuration]]];
    sDelButton.mIndexPath = indexPath;
    
    if (indexPath.row == self.mSelectedIndex)
    {
        sEdgeStick.hidden = NO;
    }
    else
    {
        sEdgeStick.hidden = YES;
    }

    return sCell;
}

#pragma mark - tableview delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger sNewSelectedIndex = indexPath.row;
    [self playItemAtIndex:sNewSelectedIndex];
}


@end
