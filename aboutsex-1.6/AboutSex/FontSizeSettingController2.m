//
//  FontSizeSettingController2.m
//  AboutSex
//
//  Created by Wen Shane on 13-6-28.
//
//

#import "FontSizeSettingController2.h"
#import "UserConfiger.h"


@interface FontSizeSettingController2 ()
{
}

@end

@implementation FontSizeSettingController2

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (NSDictionary*)fontMap
{
    return @{NSLocalizedString(@"small", nil): [NSNumber numberWithInteger:ENUM_FONT_SIZE_SMALL],        NSLocalizedString(@"medium", nil): [NSNumber numberWithInteger:ENUM_FONT_SIZE_NORMAL],
             NSLocalizedString(@"large", nil):[NSNumber numberWithInteger:ENUM_FONT_SIZE_LARGE]};
}

- (NSArray*) keysOfFontMap
{
    return @[NSLocalizedString(@"small", nil), NSLocalizedString(@"medium", nil), NSLocalizedString(@"large", nil)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self keysOfFontMap].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString* sKey = [[self keysOfFontMap] objectAtIndex:indexPath.row];
    cell.textLabel.text = sKey;
    
    ENUM_FONT_SIZE_TYPE sFontSizeType = [UserConfiger getFontSizeType];
    if (sFontSizeType == ((NSNumber*)[[self fontMap] valueForKey:sKey]).integerValue)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* sKey = [[self keysOfFontMap] objectAtIndex:indexPath.row];
    ENUM_FONT_SIZE_TYPE sCurFontSizeType = [UserConfiger getFontSizeType];
    ENUM_FONT_SIZE_TYPE sSelectedFontSizeType = ((NSNumber*)[[self fontMap] valueForKey:sKey]).integerValue;
    if (sCurFontSizeType != sSelectedFontSizeType)
    {
        [UserConfiger setFontSizeType:sSelectedFontSizeType];
        [self.tableView reloadData];
    }
}

@end
