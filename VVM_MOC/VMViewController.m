//
//  VMViewController.m
//  VVM_MOC
//
//  Created by Dragos Resetnic on 01/07/14.
//  Copyright (c) 2014 DreamCraft. All rights reserved.
//

#import "VMViewController.h"
#import <MailCore/MailCore.h>
#import "VMMailCell.h"

@interface VMViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *mailList;
@property (strong, nonatomic) UITableView *mailTableView;

@end

@implementation VMViewController

- (void)getMail
{
    MCOIMAPSession *session = [[MCOIMAPSession alloc] init];
    [session setHostname:@"imap.gmail.com"];
    [session setPort:993];
    [session setUsername:@"developer.admatica@gmail.com"];
    [session setPassword:@"developeratadmatica"];
    [session setConnectionType:MCOConnectionTypeTLS];
    
    MCOIMAPMessagesRequestKind requestKind = MCOIMAPMessagesRequestKindHeaders;
    NSString *folder = @"INBOX";
    MCOIndexSet *uids = [MCOIndexSet indexSetWithRange:MCORangeMake(1, UINT64_MAX)];
    
    MCOIMAPFetchMessagesOperation *fetchOperation = [session fetchMessagesByUIDOperationWithFolder:folder requestKind:requestKind uids:uids];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [fetchOperation start:^(NSError * error, NSArray * fetchedMessages, MCOIndexSet * vanishedMessages) {
        
        if(error) {
            NSLog(@"Error downloading message headers:%@", error);
        }
        
        NSLog(@"The post man delivereth:%@", fetchedMessages);
        [weakSelf handleMessages:fetchedMessages];
    }];
}

- (void) handleMessages:(NSArray*) recivedMail{
    _mailList = [NSMutableArray arrayWithArray:recivedMail];
    
    [_mailTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getMail];
    [self addTableView];
    
	// Do any additional setup after loading the view, typically from a nib.
}


- (void) addTableView{
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    CGFloat screenWidth = screen.size.width;
    CGFloat screenHeight = screen.size.height;
    
    _mailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    [_mailTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_mailTableView setDelegate:self];
    [_mailTableView setDataSource: self];
    [[self view] addSubview:_mailTableView];
}

#pragma mark - TableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _mailList ? _mailList.count : 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"mailCell";
    
    VMMailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
        cell = [[VMMailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    
    if (_mailList){
        MCOIMAPMessage *messsage = _mailList[indexPath.row];
        cell.textLabel.text = messsage.header.subject;
        
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
