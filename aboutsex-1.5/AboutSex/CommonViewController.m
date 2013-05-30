////
////  CommonViewController.m
////  AboutSex
////
////  Created by Wen Shane on 12-11-28.
////
////
//
//#import "CommonViewController.h"
//#import "SharedStates.h"
//
//@interface CommonViewController ()
//{
//    UIView* mMainView;
//}
//
//
//@end
//
//@implementation CommonViewController
//
//@synthesize mMainView;
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void) dealloc
//{
//    
//    self.mMainView = nil;
//    [super dealloc];
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//	// Do any additional setup after loading the view.
//}
//
//- (void) viewDidUnload
//{
//    [super viewDidUnload];
//    self.mMainView = nil;
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
//- (void) loadView
//{
//    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
//    UIView* sView = [[UIView alloc] initWithFrame:applicationFrame];
// 
//    self.view = sView;
//    [sView release];
//    
//    UIView* sBGView = [[[UIView alloc] initWithFrame:self.view.bounds] autorelease];
//    sBGView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:sBGView];
//    
//    UIView* sBackgroundColorviewForApp = [[SharedStates getInstance] getABGColorView];
//    ;
//    [self.view addSubview:sBackgroundColorviewForApp];
//    
//    self.mMainView = [[[UIView alloc] initWithFrame:self.view.bounds] autorelease];
//    self.mMainView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:self.mMainView];
//
//    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    self.mMainView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    
//}
//
//@end
