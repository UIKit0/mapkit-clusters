
// BSD License. <jano@jano.com.es>

#import "Annotation.h"
#import <MapKit/MapKit.h>

/** Source of annotations. */
@interface AnnotationSource : NSObject
+ (NSMutableArray*) annotationsForRegion:(MKCoordinateRegion)region number:(const int)number;
@end
