//
//  DeviceSyncLogPresenter.m
//  EiController
//
//  Created by Genrih Korenujenko on 08.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "DeviceSyncLogPresenter.h"
#import "DeviceOperationLogsTable.h"

#import "EiController-Swift.h"

@implementation DeviceSyncLogPresenter

@synthesize screen, interactor;

#pragma mark - SyncLogPresenterInterface
+(instancetype)build:(id<SyncLogScreenInterface>)screen
          interactor:(id<AppInteractorInterface>)interactor
{
    DeviceSyncLogPresenter *result = [DeviceSyncLogPresenter new];
    result.screen = screen;
    result.interactor = interactor;
    return result;
}

-(void)setFingerprint:(NSString*)finger
{
    fingerprint = finger;
}

-(void)onCreate
{
    NSArray *logs = [[DeviceOperationLogsTable new] getByFingerprint:fingerprint];
    [screen refresh:[self prepareViewModel]];
    [screen refreshTable:[self prepareViewModels:logs]];
}

-(void)sendLog:(SyncLogViewModel*)viewModel cells:(NSArray<SyncLogCellViewModel*>*)cells
{
    NSArray <NSString*> *recipients = @[@"rpn_support@radicalcomputing.com"];
    NSString *subject = @"[Ei] Link. Node synchronization log";
    NSString *mimeType = @"text/richtext";
    NSString *fileName = @"NodeOperationLog.txt";
    NSData *data = [self prepareLogMessage:viewModel cells:cells];
    [screen showMailScreen:recipients subject:subject mimeType:mimeType fileName:fileName data:data];
}

#pragma mark - Private Methods
-(SyncLogViewModel*)prepareViewModel
{
    SyncLogViewModel *viewModel = [SyncLogViewModel new];
    viewModel.isExtender = AppStatus.isExtendedMode;
    viewModel.tabBarTitle = @"Node Operation Log";
    viewModel.numberOfLine = 2;
    viewModel.title = [self prepareAttributed:@"Fingerprint" subtitle:fingerprint];
    return viewModel;
}

-(NSMutableAttributedString*)prepareAttributed:(NSString*)title subtitle:(NSString*)subtitle
{
    NSString *fullServerName = [NSString stringWithFormat:@"%@\n%@", title, subtitle];
    UIFont *font = [UIFont systemFontOfSize:9.0];
    UIFont *subtitleFont = [UIFont systemFontOfSize:13.0];
    NSMutableAttributedString *attrName = [[NSMutableAttributedString alloc] initWithString:fullServerName];
    UIColor *titleColor = nil;
    UIColor *subtitleColor = nil;
    if (AppStatus.isExtendedMode)
    {
        titleColor = [UIColor colorWithRed:0.549 green:0.576 blue:0.639 alpha:1];
        subtitleColor = [UIColor colorWithRed:0.212 green:0.204 blue:0.267 alpha:1];
    }
    else
    {
        titleColor = [UIColor colorWithRed:0.608 green:0.627 blue:0.682 alpha:1];
        subtitleColor = [UIColor whiteColor];
    }
    [attrName setAttributes:@{NSForegroundColorAttributeName:titleColor,
                              NSFontAttributeName:font}
                      range:[fullServerName rangeOfString:title]];
    [attrName addAttribute:NSForegroundColorAttributeName
                     value:subtitleColor
                     range:[fullServerName rangeOfString:subtitle]];
    [attrName addAttribute:NSFontAttributeName
                     value:subtitleFont
                     range:[fullServerName rangeOfString:subtitle]];
    return attrName;
}

-(NSArray*)prepareViewModels:(NSArray*)logs
{
    NSMutableArray *result = [NSMutableArray new];
    [logs enumerateObjectsUsingBlock:^(DeviceOperationLog  *obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        SyncLogCellViewModel *viewModel = [SyncLogCellViewModel new];
        viewModel.isExtender = AppStatus.isExtendedMode;
        NSString *date = [NSString getStringFromDate:[NSDate dateWithTimeIntervalSince1970:obj.timestamp] dateFormate:@"dd/MM/yy hh:mm:ss" forLocal:[NSString localUS]];
        NSString *format = [NSString hourClockFormat:obj.timestamp];
        viewModel.date = [NSString stringWithFormat:@"%@ %@", date, format];
        viewModel.action = obj.actionTitle;
        if (obj.errorMessage != nil && !obj.errorMessage.isEmpty)
        {
            viewModel.descColor = [UIColor redColor];
            viewModel.desc = [NSString stringWithFormat:@"Error: %@\nDescription: %@", obj.errorMessage, [NSString valueOrNA:obj.desc]];
        }
        else
        {
            viewModel.descColor = nil;
            viewModel.desc = [obj.desc valueOrNA];
        }
        [result addObject:viewModel];
    }];
    return result;
}

-(NSData*)prepareLogMessage:(SyncLogViewModel*)viewModel cells:(NSArray<SyncLogCellViewModel*>*)cells
{
    NSMutableData *data = [NSMutableData new];
    [data appendData:[[NSString stringWithFormat:@"%@\n", viewModel.title.string] dataUsingEncoding:NSUTF8StringEncoding]];
    for (SyncLogCellViewModel *model in cells)
        [data appendData:[[NSString stringWithFormat:@"%@ %@\n%@\n", model.action, model.date, model.desc] dataUsingEncoding:NSUTF8StringEncoding]];
    return data;
}

@end
