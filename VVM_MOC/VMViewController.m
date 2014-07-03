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
#import <AVFoundation/AVFoundation.h>

#define DefaultCellHeight 44
#define ExpandedCellHeight 110

@interface VMViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *mailList;
@property (strong, nonatomic) UITableView *mailTableView;
@property (strong, nonatomic) MCOIMAPSession *session;

@end

@implementation VMViewController

- (void)getMail
{
    _session = [[MCOIMAPSession alloc] init];
    [_session setHostname:@"imap.gmail.com"];
    [_session setPort:993];
    [_session setUsername:@"developer.admatica@gmail.com"];
    [_session setPassword:@"developeratadmatica"];
    [_session setConnectionType:MCOConnectionTypeTLS];
    
    MCOIMAPMessagesRequestKind requestKind = MCOIMAPMessagesRequestKindHeaders;
    NSString *folder = @"INBOX";
    MCOIndexSet *uids = [MCOIndexSet indexSetWithRange:MCORangeMake(1, UINT64_MAX)];
    
    MCOIMAPFetchMessagesOperation *fetchOperation = [_session fetchMessagesByUIDOperationWithFolder:folder requestKind:requestKind uids:uids];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [fetchOperation start:^(NSError * error, NSArray * fetchedMessages, MCOIndexSet * vanishedMessages) {
        
        if(error) {
            NSLog(@"Error downloading message headers:%@", error);
        }
        else {
        NSLog(@"The post man delivereth:%@", fetchedMessages);
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"header.date" ascending:NO];
            [weakSelf handleMessages:[fetchedMessages sortedArrayUsingDescriptors:@[sort]]];
        }
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
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 40)];
    [header.layer setBorderWidth:1];
    [header.layer setBorderColor:[UIColor blackColor].CGColor];
    
    _mailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    [_mailTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_mailTableView setDelegate:self];
    [_mailTableView setTableHeaderView:header];
    [_mailTableView setDataSource: self];
    [[self view] addSubview:_mailTableView];
}

#pragma mark - Play Button Action

- (void) playAtachment{
    
    MCOIMAPMessage *messsage = _mailList[[[_mailTableView indexPathForSelectedRow] row]];

    MCOIMAPPart *part = [[messsage attachments] firstObject];
    
    int uid = [messsage uid];
    
    MCOIMAPFetchContentOperation  *op = [_session fetchMessageAttachmentByUIDOperationWithFolder:@"INDOX" uid:uid partID:[part partID] encoding:(MCOEncoding)[part encoding]];
    
    [op start:^(NSError *error, NSData *data) {
        
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:nil];
        
        [player play];
        
    }];
    
    
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
        [cell.playButton addTarget:self  action:@selector(playAtachment) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return cell;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView.indexPathForSelectedRow isEqual:indexPath])
        return ExpandedCellHeight;
    
    return DefaultCellHeight;
}

#pragma mark - TableView Delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Selected %i", tableView.indexPathForSelectedRow.row);
    
    [tableView reloadData];
    
}


- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@" Deselected %i", indexPath.row);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) prefersStatusBarHidden{
    return YES;
}

@end
