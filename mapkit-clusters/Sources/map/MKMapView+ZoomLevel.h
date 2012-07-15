
// Taken from http://troybrant.net/blog/2010/01/set-the-zoom-level-of-an-mkmapview/
// License unknown

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (NSUInteger) zoomLevelOfMapView:(MKMapView*) mapView;

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
