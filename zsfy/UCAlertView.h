//
//  UCAlertView.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/13.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UCAlertViewBlock)();

typedef void (^UCAlertViewStringBlock)(NSString*);

@interface UCAlertView : NSObject <UIAlertViewDelegate>

/**
 The native UIAlertView reference. You can make any modification to the native alert view, after the init.
 */
@property (nonatomic, strong) UIAlertView* alertView;

/**
 Show a native UIAlertView with two buttons. The text and the title is custom, and is also custom the text of the buttons.
 @param title Title of the UIAlertView
 @param message Message of the UIAlertView
 @param cancelButtonTitle Text of the second button
 @param otherButtonTitles Text of the first button
 @param cancelButtonBlock Code to run if the user tap at the second button
 @param otherButtonBlock Code to run if the user tap at the first button
 @return The reference to the STAlertView
 */

- (id) initWithTitle:(NSString *)title
             message:(NSString *)message
   cancelButtonTitle:(NSString *)cancelButtonTitle
   otherButtonTitles:(NSString *)otherButtonTitles
   cancelButtonBlock:(UCAlertViewBlock)cancelButtonBlock
    otherButtonBlock:(UCAlertViewBlock)otherButtonBlock;


/**
 Show a native UIAlertView with two buttons and a UITextField. The text and the title is custom, and is also custom the text of the buttons and the UITextField value and placeholder.
 @param title Title of the UIAlertView
 @param message Message of the UIAlertView
 @param textFieldHint Text of the placeholder
 @param textFieldValue Initial text of the UITextField
 @param cancelButtonTitle Text of the second button
 @param otherButtonTitles Text of the first button
 @param cancelButtonBlock Code to run if the user tap at the second button
 @param otherButtonBlock Code to run if the user tap at the first button
 @return The reference to the STAlertView
 */
- (id) initWithTitle:(NSString *)title
             message:(NSString*)message
       textFieldHint:(NSString *)textFieldMessage
      textFieldValue:(NSString *)texttFieldValue
   cancelButtonTitle:(NSString *)cancelButtonTitle
   otherButtonTitles:(NSString *)otherButtonTitles
   cancelButtonBlock:(UCAlertViewBlock)cancelButtonBlock
    otherButtonBlock:(UCAlertViewStringBlock)otherButtonBlock;

@end
