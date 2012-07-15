
// BSD License. <jano@jano.com.es>

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Annotation.h"
#import "AnnotationCluster.h"
#import "Clusterer.h"
#import "ClustererBase.h"
#import "SimpleAnnotation.h"


@interface GridClusterer : ClustererBase <Clusterer>

-(NSMutableArray*) clusterAnnotations:(NSMutableArray*)annotations 
                        inNumClusters:(int)numClusters;

@end

