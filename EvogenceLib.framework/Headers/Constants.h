//
//  Constants.h
//  EvogenceLib
//
//  Created by Anatolij on 7/29/14.
//  Copyright (c) 2014 Evogence. All rights reserved.
//

#ifndef EvogenceLib_Constants_h
#define EvogenceLib_Constants_h

static const NSInteger MAX_RATE_AMAUNT_FOR_SHOW = 2;
static const NSInteger RELOAD_DATA_TIMEOUT = 60;
static const NSInteger HISTORY_DAYS = 30;
static const NSInteger DEFAULT_RECHARGE_AMOUNT = 2500;
static const NSInteger SECONDS_IN_DAY = 86400;
static const NSInteger SECONDS_IN_HOUR = 3600;
static const NSInteger SECONDS_IN_15_MINS = 900;
static const NSInteger SECONDS_IN_5_MINS = 300;
static const NSInteger SECOND_IN_ONE_MONTH = 2592000;
static const NSInteger SECOND_IN_ONE_DAY = 86400;
static const NSInteger SECOND_IN_ONE_HOUR = 3600;
static const NSInteger SECOND_IN_ONE_MINUTE = 60;
static const NSInteger MIN_IN_ONE_HOUR = 60;
static const int MAX_TRAYING_AMOUNT = 3;
static const int RESEND_REQUEST_TIMEOUT = 30;

typedef enum
{
    START_PARKING_REQUEST=0,
    VALIDATE_PARKING_REQUEST,
    STOP_PARKING_REQUEST,
    ADD_TIME_PARKING_REQUEST,
    GET_CURRENT_PARKING_REQUEST,
    GET_PARKING_COST_REQUEST,
    PURCHASED_MERCHANDISE,
    START_PERMIT_PARKING_REQUEST
} ERequestType;

// the amount of vertical shift upwards keep the Notes text view visible as the keyboard appears
#define kOFFSET_FOR_KEYBOARD                    352.0

#endif
