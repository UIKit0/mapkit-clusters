
// BSD License. <jano@jano.com.es>

#import "KMeansClusterer.h"

@implementation KMeansClusterer

- (id) init {
    return [super init];
}

/**
 * Return an array of 'numClusters' annotation clusters containing the given annotations.
 */
-(NSMutableArray*) clusterAnnotations:(NSMutableArray*)annotations 
                        inNumClusters:(int)numClusters {
    
    trace(@"Clustering %d elements into %d clusters", [annotations count], numClusters);
    
    if ([annotations count]==0){
        // annotations is empty so return empty array of clusters
        trace(@"empty dataset so returning an empty array of clusters");
        return [NSMutableArray array];
    }
    
    // calculate the number of rows*columns that are roughly equal to numClusters
    GridSize gridSize = [self gridSizeForClusters:numClusters];
    
    // create the annotation clusters
    NSMutableArray *clusters = [super clustersForGrid:gridSize];
 
    BOOL change = true;
    int count = 0;
    // iterate up to 100 times
    while ((count++ < 100) && (change)) {
        // empty clusters
        for (AnnotationCluster *cluster in clusters){
            [cluster.annotations removeAllObjects];
        }
        change = [self reassignAnnotations:annotations toClusters:clusters];
        [self computeClusterCenters:clusters];
    }
    
    return clusters;
}


-(void) computeClusterCenters:(NSMutableArray*)clusters {
    
    trace(@"COMPUTING NEW CENTERS");
    for (AnnotationCluster *cluster in clusters) {
        float count = [cluster.annotations count];
        
        if ([cluster.annotations count] == 0) {
            continue; // nothing to do
        }
        
        trace(@"    cluster %d", cluster.clusterId);
        
        // arithmetic mean of all points
        double meanX = 0.0, meanY = 0.0;
        for (Annotation*annotation in cluster.annotations){
            meanX += annotation.coordinate.latitude;
            meanY += annotation.coordinate.longitude;
        }
        trace(@"        computing new center for %d annotations", [cluster.annotations count]);
        trace(@"            meanX/=count = %f/%f = %f",meanX, count, meanX/count);
        meanX /= count;
        meanY /= count;
        
        CLLocationCoordinate2D newCoord = {meanX, meanY};
        cluster.coordinate = newCoord;
    }
}


/**
 * Iterate all elements on the dataset and add each element to the closest cluster.
 * Depending on the position of the cluster, this will mean 0 or more changes.
 *
 * @return FALSE if no changes were made, TRUE otherwise
 */
-(BOOL) reassignAnnotations:(NSMutableArray*)annotations toClusters:(NSMutableArray*)clusters {
    trace(@"REASSIGNING ANNOTATIONS TO CLUSTERS");
    
    //LogMessage(@"core data stuff", 1, @"Let's make %@", @"lemonade"); 
    
    int numChanges = 0;
    for (Annotation *annotation in annotations) {
        // get the closest cluster for this annotation
        trace(@"    Looking for closest cluster for %@",annotation.title);
        AnnotationCluster *cluster = [self getClosestFrom:clusters to:annotation];
        // if needed, assign the annotation to the cluster and count the changes
        BOOL changeNeeded = (annotation.clusterId==-1) || (annotation.clusterId!=cluster.clusterId);
        if (changeNeeded) {
            numChanges++;            
            trace(@"    Annotation:\"%@\" goes from %d to %d (%d changes)", 
                  annotation.title, annotation.clusterId, cluster.clusterId, numChanges);
            annotation.clusterId = cluster.clusterId;
        }
        [cluster.annotations addObject:annotation];
    }
    return numChanges > 0;
}



/** 
 * @return Closest cluster for this annotation. 
 */
-(AnnotationCluster*) getClosestFrom:(NSMutableArray*)clusters to:(Annotation*)annotation {
    AnnotationCluster *closestCluster = nil;
    
    double shortestDistance = 100000; // a big number
    for (AnnotationCluster *cluster in clusters) {
        double distance = [self findDistanceFrom:cluster to:annotation];
        //trace(@"        distance from [\"%@\",%f,%f] to [\"cluster %d\",%f,%f] is %f", 
        //      annotation.title,annotation.point.x,annotation.point.y, cluster.clusterId,cluster.point.x,cluster.point.y, distance);
        if (shortestDistance > distance) {
            if (shortestDistance == 0.0) { trace(@"        shortestDistance is 0.0 so shortestDistance is now %f", distance); }
            else { trace(@"        shortestDistance>distance %f>%f, so shortdistance is now %f", shortestDistance,distance, distance); }
            shortestDistance = distance;
            closestCluster = cluster;
        }
    }
    trace(@"        Closest cluster is \"cluster %d\"", closestCluster.clusterId);
    return closestCluster;
}


-(double) findDistanceFrom:(AnnotationCluster*)cluster to:(Annotation*)annotation {
    double x1 = cluster.coordinate.latitude, y1 = cluster.coordinate.longitude;
    double x2 = annotation.coordinate.latitude, y2 = annotation.coordinate.longitude;
    double distance = sqrt( pow((x2-x1),2) + pow((y2-y1),2) );
    return distance;    
}
    

/*
-(double) findDistanceTo:(CGPoint)aPoint {
    double x1 = aPoint.x, y1 = aPoint.y;
    double x2 = self.point.x, y2 = self.point.y;
    double distance = sqrt( pow((x2-x1),2) + pow((y2-y1),2) );
    return distance;
}*/

@end
