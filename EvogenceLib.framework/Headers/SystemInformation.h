#import <Foundation/Foundation.h>
#import <AdSupport/ASIdentifierManager.h>
#import "Utils.h"

typedef enum 
{
	TOTAL_M=0,
	FREE_M,
	USED_M
} EMemoryInfoType;

typedef enum
{
	NONE_CONNECTION=0,
	WIFI_CONNECTION,
	WWAN_CONNECTION //3G
} EConnectionType;


@interface SystemInformation : NSObject 
{

}

+(NSString *)GetTypeReachability;
+(EConnectionType)GetConnectionType;
+(long long)GetRAMSpace:(EMemoryInfoType)_memoryInfoType;
+(float)GetFlashDiskSpace:(EMemoryInfoType)_memoryInfoType;
+(NSString *)GetIPAddress;
+(NSString*)GetDeviceModel;
+(NSString*)getPlatform;
+(NSString*)GetMacAddress;
+(NSString*)getPlatformUniqid;

+(NSString*)getSystemVersion;
+(NSString*)getSystemOS;

+(NSString*)getArchitecture;
+(NSString*)getPhysicalNumberOfCPU;
+(NSString*)getCPUType;
+(NSInteger)getCPUSubtype;
+(NSInteger)getCPUThreadType;
+(NSString*)getUsageCPU;


@end
