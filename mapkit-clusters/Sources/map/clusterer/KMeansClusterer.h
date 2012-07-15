
// BSD License. <jano@jano.com.es>

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Annotation.h"
#import "AnnotationCluster.h"
#import "Clusterer.h"
#import "ClustererBase.h"
#import "SimpleAnnotation.h"

@interface KMeansClusterer : ClustererBase <Clusterer>

-(NSMutableArray*) clusterAnnotations:(NSMutableArray*)annotations 
                        inNumClusters:(int)numClusters;
@end


/** Category for private methods. */
@interface KMeansClusterer()

-(BOOL) reassignAnnotations:(NSMutableArray*)annotations toClusters:(NSMutableArray*)clusters;
-(AnnotationCluster*) getClosestFrom:(NSMutableArray*)clusters to:(Annotation*)annotation;
-(double) findDistanceFrom:(AnnotationCluster*)cluster to:(Annotation*)annotation;
-(void) computeClusterCenters:(NSMutableArray*)clusters;

@end
