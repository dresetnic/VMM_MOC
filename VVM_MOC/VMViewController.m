//
//  VMViewController.m
//  VVM_MOC
//
//  Created by Dragos Resetnic on 01/07/14.
//  Copyright (c) 2014 DreamCraft. All rights reserved.
//

#import "VMViewController.h"
#import <MailCore/MailCore.h>

@interface VMViewController ()

@end

@implementation VMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MCOIMAPSession *session = [[MCOIMAPSession alloc] init];
    [session setHostname:@"imap.google.com"];
    [session setPort:993];
    [session setUsername:@"developer.admatica@gmail.com"];
    [session setPassword:@"developeratadmatica"];
    [session setConnectionType:MCOConnectionTypeStartTLS];
    
    MCOIMAPMessagesRequestKind requestKind = MCOIMAPMessagesRequestKindHeaders;
    NSString *folder = @"INBOX";
    MCOIndexSet *uids = [MCOIndexSet indexSetWithRange:MCORangeMake(1, UINT64_MAX)];
    
    MCOIMAPFetchMessagesOperation *fetchOperation = [session fetchMessagesByUIDOperationWithFolder:folder requestKind:requestKind uids:uids];
    
    [fetchOperation start:^(NSError * error, NSArray * fetchedMessages, MCOIndexSet * vanishedMessages) {
        //We've finished downloading the messages!
        
        //Let's check if there was an error:
        if(error) {
            NSLog(@"Error downloading message headers:%@", error);
        }
        
        //And, let's print out the messages...
        NSLog(@"The post man delivereth:%@", fetchedMessages);
    }];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
