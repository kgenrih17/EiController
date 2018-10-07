//
//  SyncLogScreen.m
//  EiController
//
//  Created by Genrih Korenujenko on 21.02.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "SyncLogScreen.h"

#import "EiController-Swift.h"

@interface SyncLogScreen () <INodeDetailsTabAction>
{
    IBOutlet NSLayoutConstraint *textHeightConstraint;
}
@end

@implementation SyncLogScreen

#pragma mark - Public Init Methods
-(instancetype)initWithPresenterClass:(Class<SyncLogPresenterInterface>)aClass fingerprint:(NSString*)fingerprint
{
    self = [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self)
    {
        presenter = [aClass build:self interactor:self.interactor];
        if ([presenter respondsToSelector:@selector(setFingerprint:)])
            [presenter setFingerprint:fingerprint];
    }
    return self;
}

#pragma mark - Override Methods
-(void)viewDidLoad
{
    [super viewDidLoad];
    sendLogButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [presenter onCreate];
}

-(void)removeTitle
{
    [titleView removeFromSuperview];
    topContainerConstraint.active = YES;
}

-(void)setAccept:(UIButton*)button
{
    
}

-(IBAction)clickSave
{
    if ([MFMailComposeViewController canSendMail])
        [presenter sendLog:model cells:cells];
    else
        [self showAlertWithTitle:@"Info" message:@"You have no email accounts set up"];
}

-(NSString*)getRightButtonIconName
{
    return @"send_log_icon.png";
}

-(NSString*)getRightButtonActiveIconName
{
    return [self getRightButtonIconName];
}

#pragma mark - SyncLogScreenInterface
-(void)refresh:(SyncLogViewModel*)viewModel
{
    model = viewModel;
    tabBarLabel.text = model.tabBarTitle;
    textLabel.attributedText = model.title;
    self.view.backgroundColor = model.getBackgroundColor;
    [self.view setNeedsLayout];
    if (model.numberOfLine == 2)
    {
        textHeightConstraint.constant = 40;
    }
    else
    {
        textHeightConstraint.constant = 75;
    }
    [self.view layoutIfNeeded];
}

-(void)refreshTable:(NSArray<SyncLogCellViewModel*>*)newCells
{
    cells = newCells;
    [logsTableView reloadData];
}

-(void)showMailScreen:(NSArray<NSString*>*)recipients
              subject:(NSString*)subject
              mimeType:(NSString*)mimeType
             fileName:(NSString*)fileName
                 data:(NSData*)data
{
    MFMailComposeViewController *controller = [MFMailComposeViewController new];
    controller.mailComposeDelegate = self;
    [controller setToRecipients:recipients];
    [controller setSubject:subject];
    [controller addAttachmentData:data mimeType:mimeType fileName:fileName];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return cells.count;
}
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 100;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    SyncLogCell *cell = [[SyncLogCell alloc] initWithNib];
    [cell load:cells[indexPath.row]];
    return cell;
}

#pragma mark - MFMailComposeViewControllerDelegate
-(void)mailComposeController:(MFMailComposeViewController*)controller
         didFinishWithResult:(MFMailComposeResult)result
                       error:(NSError*)error;
{
    switch (result)
    {
        case MFMailComposeResultFailed:
            [self showAlertWithTitle:@"Error" message:error.localizedDescription];
            break;
        case MFMailComposeResultSent:
            [self showAlertWithTitle:@"Info" message:@"Logs successfully sent"];
            break;
        default:
            break;
    }
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
