//
//  CentralMethod.m
//  EiController
//
//  Created by Genrih Korenujenko on 06.11.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "CentralMethod.h"

@implementation EiOSMethod

+(NSString*)uploadMedia
{
    return [self addition:@"Integration.RPN.broadcast.ScheduleService" method:@"uploadMedia"];
}

+(NSString*)applyScheduleData
{
    return [self addition:@"Integration.RPN.broadcast.ScheduleService" method:@"applyScheduleData"];
}

+(NSString*)uploadApplication
{
    return [self addition:@"Integration.RPN.applications.InstanceService" method:@"uploadApplication"];
}

+(NSString*)applyData
{
    return [self addition:@"Integration.RPN.applications.InstanceService" method:@"applyData"];
}

+(NSString*)getLogFiles
{
    return [self addition:@"Integration.RPN.logs.ReportsService" method:@"getLogFiles"];
}

+(NSString*)downloadLogFile
{
    return [self addition:@"Integration.RPN.logs.ReportsService" method:@"downloadLogFile"];
}

+(NSString*)setUploadedLogFiles
{
    return [self addition:@"Integration.RPN.logs.ReportsService" method:@"setUploadedLogFiles"];
}

#pragma mark - Private Methods
+(NSString*)addition:(NSString*)model method:(NSString*)method
{
    return [NSString stringWithFormat:@"model=%@&method=%@", model, method];
}

@end

@implementation IPMethod

#pragma mark - Public Methods
+(NSString*)getScheduleApplications
{
    return [self addition:@"get_schedule_applications"];
}

+(NSString*)downloadFile
{
    return [self addition:@"download_file"];
}

+(NSString*)setUploadedFiles
{
    return [self addition:@"set_uploaded_files"];
}

#pragma mark - Private Methods
+(NSString*)addition:(NSString*)name
{
    return [NSString stringWithFormat:@"Integration.IP.ApplicationService::%@", name];
}

@end

@implementation TaskMethod

#pragma mark - Public Methods
+(NSString*)getScheduleData
{
    return [self addition:@"getScheduleData"];
}

#pragma mark - Private Methods
+(NSString*)addition:(NSString*)name
{
    return [NSString stringWithFormat:@"Integration.RPNES.TaskRequest.TaskRequestService::%@", name];
}

@end

@implementation ServerAllowMethod

#pragma mark - Public Methods
+(NSString*)authEmployeeByPin
{
    return [self addition:@"authEmployeeByPin"];
}

+(NSString*)authEmployee
{
    return [self addition:@"authEmployee"];
}

#pragma mark - Private Methods
+(NSString*)addition:(NSString*)name
{
    return [NSString stringWithFormat:@"IDServer.IDS_Allow::%@", name];
}

@end

@implementation CentralMethod

#pragma mark - Public Methods
+(NSString*)dasJsonPHP
{
    return @"/das-json.php";
}

+(NSString*)echo
{
    return @"Integration.RPNES.RPNES_echo_service::_echo";
}

+(NSString*)regAppByToken
{
    return @"Integration.RPNES.IDS_Reg::regAppByToken";
}

+(NSString*)getNodesByToken
{
    return @"Integration.RPNES.AS.RPNES_AS_Data::getNodesByToken";
}

+(NSString*)uploadLogFiles
{
    return @"model=ESReports.import.ESR_downloadApplianceLogs&method=uploadLogFiles";
}

@end
