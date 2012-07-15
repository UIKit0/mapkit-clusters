
// BSD License. <jano@jano.com.es>

#import "Annotation.h"

/** An annotation which is a cluster of Annotations. */
@interface AnnotationCluster : Annotation <MKAnnotation> {
}

@property(nonatomic,retain) NSMutableArray* annotations;

-(id) initWithId:(int)clusterId andCoordinate:(CLLocationCoordinate2D)coordinate;
-(void) addAnnotation:(Annotation*)annotation;


@end
