
// BSD License. <jano@jano.com.es>

#import "MapView.h"

@implementation MapView

//@synthesize clustered, clusters;

/*
- (void)addAnnotation:(id <MKAnnotation>)annotation {
    // do we want to make clusters?
    if ([self isClustered]==YES) {
        // adding without clusters
        [super addAnnotation:annotation];
    } else {
        // adding without clusters
        [super addAnnotation:annotation];
    }
}
*/

- (void)addAnnotations:(NSArray *)annotations {
    for(id <MKAnnotation>a in annotations) {
        [super addAnnotation:a];
    }
}


@end

/*
-(void) addAnnotation:(id<MKAnnotation>)annotation {  
    CGPoint point = [self.mapView convertCoordinate:annotation.coordinate toPointToView:self.mapView];
    
    AssetClusterAnnotation *cluster = nil;
    
    for(AssetClusterAnnotation *arrayCluster in clusters) {
        if(arrayCluster.centerLatitude != 0.0 && arrayCluster.centerLongitude != 0.0) {
            CGPoint clusterCenterPoint = [self.mapView convertCoordinate:arrayCluster.coordinate toPointToView:self.mapView];
            
            // Found a cluster which contains the marker.
            if (point.x >= clusterCenterPoint.x - gridSize && point.x <= clusterCenterPoint.x + gridSize &&
                point.y >= clusterCenterPoint.y - gridSize && point.y <= clusterCenterPoint.y + gridSize) {
                
                [arrayCluster addAnnotation:annotation];
                
                return;
            }      
        } else {
            continue;
        }
    }
    
    // No cluster contain the marker, create a new cluster.
    cluster = [[AssetClusterAnnotation alloc] initWithAnnotationClusterer:self];
    [cluster addAnnotation:annotation];
    
    // Add this cluster both in clusters provided and clusters_
    [clusters addObject:cluster];
    [cluster release];
}
*/
