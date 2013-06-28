//
//  UIPlaceHolderTextView.h
//  AboutSex
//
//  Created by Wen Shane on 13-2-14.
//
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView
{
    NSString *placeholder;
    UIColor *placeholderColor;
    
@private
    UILabel *placeHolderLabel;

}

@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
