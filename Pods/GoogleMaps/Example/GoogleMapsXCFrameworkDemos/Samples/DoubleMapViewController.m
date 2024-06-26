/*
 * Copyright 2016 Google LLC. All rights reserved.
 *
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
 * file except in compliance with the License. You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import "GoogleMapsXCFrameworkDemos/Samples/DoubleMapViewController.h"

#if __has_feature(modules)
@import GoogleMaps;
#else
#import <GoogleMaps/GoogleMaps.h>
#endif

@interface DoubleMapViewController () <GMSMapViewDelegate>
@end

@implementation DoubleMapViewController {
  GMSMapView *_mapView;
  GMSMapView *_boundMapView;
}

+ (GMSCameraPosition *)defaultCamera {
  return [GMSCameraPosition cameraWithLatitude:37.7847 longitude:-122.41 zoom:5];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // Two map views, second one has its camera target controlled by the first.
  CGRect frame = self.view.bounds;
  frame.size.height = frame.size.height / 2;
  _mapView = [GMSMapView mapWithFrame:frame camera:[DoubleMapViewController defaultCamera]];
  // Opt the MapView in automatic dark mode switching.
  _mapView.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
  _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
                              UIViewAutoresizingFlexibleBottomMargin;

  _mapView.delegate = self;
  [self.view addSubview:_mapView];

  frame = self.view.bounds;
  frame.size.height = frame.size.height / 2;
  frame.origin.y = frame.size.height;
  _boundMapView = [GMSMapView mapWithFrame:frame camera:[DoubleMapViewController defaultCamera]];
  // Opt the MapView in automatic dark mode switching.
  _boundMapView.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
  _boundMapView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                   UIViewAutoresizingFlexibleHeight |
                                   UIViewAutoresizingFlexibleTopMargin;
  _boundMapView.settings.scrollGestures = NO;

  [self.view addSubview:_boundMapView];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  CGRect frame = self.view.bounds;
  frame.size.height = frame.size.height / 2;
  _mapView.frame = frame;
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
  GMSCameraPosition *previousCamera = _boundMapView.camera;
  _boundMapView.camera = [GMSCameraPosition cameraWithTarget:position.target
                                                        zoom:previousCamera.zoom
                                                     bearing:previousCamera.bearing
                                                viewingAngle:previousCamera.viewingAngle];
}

@end
