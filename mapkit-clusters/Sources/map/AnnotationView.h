
// BSD License. <jano@jano.com.es>

#import <MapKit/MapKit.h>
#import "Annotation.h"

@interface AnnotationView : MKAnnotationView {
@private
    UIImage *iconImage;
}
@property (nonatomic, retain) UIImage *iconImage;

// this is copied from the annotation to the view when the view is created
@property(nonatomic,assign) CLLocationCoordinate2D spawnCoordinate;

@end
