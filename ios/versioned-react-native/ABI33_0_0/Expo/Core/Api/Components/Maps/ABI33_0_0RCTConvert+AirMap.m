//
// Created by Leland Richardson on 12/27/15.
// Copyright (c) 2015 Facebook. All rights reserved.
//

#import "ABI33_0_0RCTConvert+AirMap.h"

#import <ReactABI33_0_0/ABI33_0_0RCTConvert+CoreLocation.h>
#import "ABI33_0_0AIRMapCoordinate.h"

@implementation ABI33_0_0RCTConvert (AirMap)

+ (MKCoordinateSpan)MKCoordinateSpan:(id)json
{
  json = [self NSDictionary:json];
  return (MKCoordinateSpan){
    [self CLLocationDegrees:json[@"latitudeDelta"]],
    [self CLLocationDegrees:json[@"longitudeDelta"]]
  };
}

+ (MKCoordinateRegion)MKCoordinateRegion:(id)json
{
  return (MKCoordinateRegion){
    [self CLLocationCoordinate2D:json],
    [self MKCoordinateSpan:json]
  };
}

+ (MKMapCamera*)MKMapCamera:(id)json
{
    json = [self NSDictionary:json];
    return [ABI33_0_0RCTConvert MKMapCameraWithDefaults:json existingCamera:nil];
}

+ (MKMapCamera*)MKMapCameraWithDefaults:(id)json existingCamera:(MKMapCamera*)camera
{
    json = [self NSDictionary:json];
    if (camera == nil) {
        camera = [[MKMapCamera alloc] init];
    } else {
        camera = [camera copy];
    }
    if (json[@"center"]) {
        camera.centerCoordinate = [self CLLocationCoordinate2D:json[@"center"]];
    }
    if (json[@"pitch"]) {
        camera.pitch = [self double:json[@"pitch"]];
    }
    if (json[@"altitude"]) {
        camera.altitude = [self double:json[@"altitude"]];
    }
    if (json[@"heading"]) {
        camera.heading = [self double:json[@"heading"]];
    }
    return camera;
}


ABI33_0_0RCT_ENUM_CONVERTER(MKMapType, (@{
  @"standard": @(MKMapTypeStandard),
  @"satellite": @(MKMapTypeSatellite),
  @"hybrid": @(MKMapTypeHybrid),
  @"satelliteFlyover": @(MKMapTypeSatelliteFlyover),
  @"hybridFlyover": @(MKMapTypeHybridFlyover),
  @"mutedStandard": @(MKMapTypeMutedStandard)
}), MKMapTypeStandard, integerValue)

// NOTE(lmr):
// This is a bit of a hack, but I'm using this class to simply wrap
// around a `CLLocationCoordinate2D`, since I was unable to figure out
// how to handle an array of structs like CLLocationCoordinate2D. Would love
// to get rid of this if someone can show me how...
+ (ABI33_0_0AIRMapCoordinate *)ABI33_0_0AIRMapCoordinate:(id)json
{
    ABI33_0_0AIRMapCoordinate *coord = [ABI33_0_0AIRMapCoordinate new];
    coord.coordinate = [self CLLocationCoordinate2D:json];
    return coord;
}

ABI33_0_0RCT_ARRAY_CONVERTER(ABI33_0_0AIRMapCoordinate)

+ (NSArray<NSArray<ABI33_0_0AIRMapCoordinate *> *> *)ABI33_0_0AIRMapCoordinateArrayArray:(id)json
{
    return ABI33_0_0RCTConvertArrayValue(@selector(ABI33_0_0AIRMapCoordinateArray:), json);
}

@end
