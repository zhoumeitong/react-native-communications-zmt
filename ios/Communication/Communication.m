//
//  Communication.m
//  Communication
//
//  Created by zmt on 16/10/21.
//  Copyright © 2016年 cn.com.jiuqi. All rights reserved.
//

#import "Communication.h"
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>

#define kIOS8   [UIDevice currentDevice].systemVersion.doubleValue>=8.0 ? 1 :0
#define kIOS10   [UIDevice currentDevice].systemVersion.doubleValue>=10.0 ? 1 :0

@interface Communication()<MFMessageComposeViewControllerDelegate,ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate>

@property (strong, nonatomic) RCTResponseSenderBlock completion;

@end

@implementation Communication

RCT_EXPORT_MODULE()

- (UIViewController *)rootViewController {
    return [[[[UIApplication sharedApplication] delegate] window] rootViewController];
}


#pragma mark --------打电话 

RCT_EXPORT_METHOD(call:(NSString *)phoneNumber :(RCTResponseSenderBlock)completion) {
    NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumber]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneNumberURL]) {
        [[UIApplication sharedApplication] openURL:phoneNumberURL];
    }
    else {
        UIAlertView *notPermittedAlertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                        message:@"Your device doesn't support this feature."
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
        
        [notPermittedAlertView show];
    }
    
}


#pragma mark --------发短信

RCT_EXPORT_METHOD(messageNumber:(NSString *)phoneNumber completion:(RCTResponseSenderBlock)completion) {
    [self messageNumber:phoneNumber message:nil completion:completion];
}

RCT_REMAP_METHOD(messageNumberWithMessage, messageNumber:(NSString *)phoneNumber message:(NSString *)message completion:(RCTResponseSenderBlock)completion) {
    if ([MFMessageComposeViewController canSendText]) {
        self.completion = completion;
        
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        
        [messageController setRecipients:@[phoneNumber]];
        [messageController setBody:message];
        
        [[self rootViewController] presentViewController:messageController animated:YES completion:nil];
    }
    else {
        // TODO: Handle the error case
        if (completion) {
            completion(@[@"This device does not support sending text messages"]);
        }
    }
}

#pragma mark ----------- MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (self.completion) {
        self.completion(@[@(result)]);
    }
    
    self.completion = nil;
    
    [[self rootViewController] dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -------- 打开通讯录

RCT_EXPORT_METHOD(openContacts:(RCTResponseSenderBlock)completion)
{
    if (kIOS10) {
        CNContactPickerViewController * contactVc = [[CNContactPickerViewController alloc]init];
        contactVc.delegate = self;
        contactVc.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
        [[self rootViewController] presentViewController:contactVc animated:YES completion:nil];
        
        
    }else{
        ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        peoplePicker.peoplePickerDelegate = self;
        if(kIOS8){
            peoplePicker.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
        }
        [[self rootViewController] presentViewController:peoplePicker animated:YES completion:nil];
        
    }
    
    self.completion = completion;
    
}

#pragma mark -------- CNContactPickerDelegate (ios10)

/**
 *  选中一个联系人
 *  如果实现了选中一个联系人的方法,那么单击联系人单元格不会跳到详情页面,只单独实现选中联系人属性的方法才会跳转到详情页面.
 */


//-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
//
////    CNLabeledValue * labValue = [contact.phoneNumbers lastObject];
////    NSString *phoneNO = [labValue.value stringValue];
//
//    for (CNLabeledValue *labeledValue in contact.phoneNumbers) {
//
//        CNPhoneNumber *phoneNumber = labeledValue.value;
//        NSString *phoneNO = phoneNumber.stringValue;
//        if ([phoneNO hasPrefix:@"+"]) {
//            phoneNO = [phoneNO substringFromIndex:3];
//        }
//
//        phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        NSLog(@"%@", phoneNO);
//        if (self.completion) {
//            self.completion(@[phoneNO]);
//        }
//
//        self.completion = nil;
//    }
//
//}

/**
 *  选中一个联系人属性
 */
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{
    
    //    NSLog(@"%@",contactProperty);
    CNContact *contact = contactProperty.contact;
    for (CNLabeledValue *labeledValue in contact.phoneNumbers) {
        
        CNPhoneNumber *phoneNumber = labeledValue.value;
        NSString *phoneNO = phoneNumber.stringValue;
        if ([phoneNO hasPrefix:@"+"]) {
            phoneNO = [phoneNO substringFromIndex:3];
        }
        
        phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSLog(@"%@", phoneNO);
        if (self.completion) {
            self.completion(@[phoneNO]);
        }
        
        self.completion = nil;
    }
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark -------- ABPeoplePickerNavigationControllerDelegate (ios7、ios8)

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -------- ABPeoplePickerNavigationControllerDelegate (ios8)

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@", phoneNO);
    if (self.completion) {
        self.completion(@[phoneNO]);
    }
    
    self.completion = nil;
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    return;
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    [peoplePicker pushViewController:personViewController animated:YES];
}

#pragma mark -------- ABPeoplePickerNavigationControllerDelegate (ios7)

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@", phoneNO);
    if (self.completion) {
        self.completion(@[phoneNO]);
    }
    
    self.completion = nil;
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    return NO;
    return YES;
}



@end
