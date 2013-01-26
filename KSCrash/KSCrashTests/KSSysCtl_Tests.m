//
//  KSSysCtl_Tests.m
//  KSCrash
//
//  Created by Karl Stenerud on 1/26/13.
//  Copyright (c) 2013 Karl Stenerud. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "KSSysCtl.h"

@interface KSSysCtl_Tests : SenTestCase @end

@implementation KSSysCtl_Tests

- (void) testSysCtlInt32
{
    int32_t result = kssysctl_int32(CTL_KERN, KERN_POSIX1);
    STAssertTrue(result > 0, @"");
}

- (void) testSysCtlInt32Invalid
{
    int32_t result = kssysctl_int32(CTL_KERN, 1000000);
    STAssertTrue(result == 0, @"");
}

- (void) testSysCtlInt32ForName
{
    int32_t result = kssysctl_int32ForName("kern.posix1version");
    STAssertTrue(result > 0, @"");
}

- (void) testSysCtlInt32ForNameInvalid
{
    int32_t result = kssysctl_int32ForName("kernblah.posix1version");
    STAssertTrue(result == 0, @"");
}

- (void) testSysCtlInt64
{
    int64_t result = kssysctl_int64(CTL_KERN, KERN_USRSTACK64);
    STAssertTrue(result > 0, @"");
}

- (void) testSysCtlInt64Invalid
{
    int64_t result = kssysctl_int64(CTL_KERN, 1000000);
    STAssertTrue(result == 0, @"");
}

- (void) testSysCtlInt64ForName
{
    int64_t result = kssysctl_int64ForName("kern.usrstack64");
    STAssertTrue(result > 0, @"");
}

- (void) testSysCtlInt64ForNameInvalid
{
    int64_t result = kssysctl_int64ForName("kernblah.usrstack64");
    STAssertTrue(result == 0, @"");
}

- (void) testSysCtlUInt32
{
    uint32_t result = kssysctl_uint32(CTL_KERN, KERN_POSIX1);
    STAssertTrue(result > 0, @"");
}

- (void) testSysCtlUInt32Invalid
{
    uint32_t result = kssysctl_uint32(CTL_KERN, 1000000);
    STAssertTrue(result == 0, @"");
}

- (void) testSysCtlUInt32ForName
{
    uint32_t result = kssysctl_uint32ForName("kern.posix1version");
    STAssertTrue(result > 0, @"");
}

- (void) testSysCtlUInt32ForNameInvalid
{
    uint32_t result = kssysctl_uint32ForName("kernblah.posix1version");
    STAssertTrue(result == 0, @"");
}

- (void) testSysCtlUInt64
{
    uint64_t result = kssysctl_uint64(CTL_KERN, KERN_USRSTACK64);
    STAssertTrue(result > 0, @"");
}

- (void) testSysCtlUInt64Invalid
{
    uint64_t result = kssysctl_uint64(CTL_KERN, 1000000);
    STAssertTrue(result == 0, @"");
}

- (void) testSysCtlUInt64ForName
{
    uint64_t result = kssysctl_uint64ForName("kern.usrstack64");
    STAssertTrue(result > 0, @"");
}

- (void) testSysCtlUInt64ForNameInvalid
{
    uint64_t result = kssysctl_uint64ForName("kernblah.usrstack64");
    STAssertTrue(result == 0, @"");
}

- (void) testSysCtlString
{
    char buff[100] = {0};
    bool success = kssysctl_string(CTL_KERN, KERN_OSTYPE, buff, sizeof(buff));
    STAssertTrue(success, @"");
    STAssertTrue(buff[0] != 0, @"");
}

- (void) testSysCtlStringInvalid
{
    char buff[100] = {0};
    bool success = kssysctl_string(CTL_KERN, 1000000, buff, sizeof(buff));
    STAssertFalse(success, @"");
    STAssertTrue(buff[0] == 0, @"");
}

- (void) testSysCtlStringForName
{
    char buff[100] = {0};
    bool success = kssysctl_stringForName("kern.ostype", buff, sizeof(buff));
    STAssertTrue(success, @"");
    STAssertTrue(buff[0] != 0, @"");
}

- (void) testSysCtlStringForNameInvalid
{
    char buff[100] = {0};
    bool success = kssysctl_stringForName("kernblah.ostype", buff, sizeof(buff));
    STAssertFalse(success, @"");
    STAssertTrue(buff[0] == 0, @"");
}

- (void) testSysCtlDate
{
    struct timeval value = kssysctl_timeval(CTL_KERN, KERN_BOOTTIME);
    STAssertTrue(value.tv_sec > 0, @"");
}

- (void) testSysCtlDateInvalid
{
    struct timeval value = kssysctl_timeval(CTL_KERN, 1000000);
    STAssertTrue(value.tv_sec == 0, @"");
}

- (void) testSysCtlDateForName
{
    struct timeval value = kssysctl_timevalForName("kern.boottime");
    STAssertTrue(value.tv_sec > 0, @"");
}

- (void) testSysCtlDateForNameInvalid
{
    struct timeval value = kssysctl_timevalForName("kernblah.boottime");
    STAssertTrue(value.tv_sec == 0, @"");
}

- (void) testGetProcessInfo
{
    int pid = getpid();
    struct kinfo_proc procInfo = {{{{0}}}};
    bool success = kssysctl_getProcessInfo(pid, &procInfo);
    STAssertTrue(success, @"");
    NSString* processName = [NSString stringWithCString:procInfo.kp_proc.p_comm encoding:NSUTF8StringEncoding];
    NSString* expected = @"otest";
    STAssertEqualObjects(processName, expected, @"");
}

// This sysctl always returns true for some reason...
//- (void) testGetProcessInfoInvalid
//{
//    int pid = 1000000;
//    struct kinfo_proc procInfo = {{{{0}}}};
//    bool success = kssysctl_getProcessInfo(pid, &procInfo);
//    STAssertFalse(success, @"");
//}

- (void) testGetMacAddress
{
    unsigned char macAddress[6] = {0};
    bool success = kssysctl_getMacAddress("en0", (char*)macAddress);
    STAssertTrue(success, @"");
    unsigned int result = 0;
    for(size_t i = 0; i < sizeof(macAddress); i++)
    {
        result |= macAddress[i];
    }
    STAssertTrue(result != 0, @"");
}

- (void) testGetMacAddressInvalid
{
    unsigned char macAddress[6] = {0};
    bool success = kssysctl_getMacAddress("blah blah", (char*)macAddress);
    STAssertFalse(success, @"");
}

@end
