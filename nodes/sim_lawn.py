#!/usr/bin/env python
import roslib;
roslib.load_manifest('detection')
import rospy
from std_msgs.msg import String
from std_msgs.msg import Int32
from geometry_msgs.msg import Pose2D
from geometry_msgs.msg import Point
from geometry_msgs.msg import PointStamped
import tf
import math
import numpy as np
from visualization_msgs.msg import MarkerArray
from visualization_msgs.msg import Marker
from std_msgs.msg import ColorRGBA
from tf.transformations import euler_from_quaternion
import eliminator.msg
import actionlib


class Sim(object):
    """docstring for Sim"""
    def __init__(self, length, width, weed_density):
        
        rospy.init_node('simple_sim', anonymous=True)
        lawn_pub = rospy.Publisher('/sim_lawn_grid', Marker, queue_size=10)
        self.cam_point_pub = rospy.Publisher('/cam_points', Marker, queue_size=10)
        self.boundary_pub = rospy.Publisher('/boundary', Int32, queue_size=10)
        self.weed_pub = rospy.Publisher('/weed_location', Pose2D, queue_size=10)
        # cam_view_pub = rospy.Publisher('/camera_box', Marker, queue_size = 0)
        
        self.feedback = eliminator.msg.eliminationFeedback()
        self.result   = eliminator.msg.eliminationResult()
        self.action_name = "eliminate"
        self.action_server = actionlib.SimpleActionServer(self.action_name, eliminator.msg.eliminationAction, execute_cb=self.elimination_sim, auto_start = False)
        self.action_server.start();
        self.transformer = tf.TransformListener()
        
        self.num_explored = 0;

        self.cellsize = .15
        self.length = round(length/self.cellsize)
        self.width = round(width/self.cellsize)
        self.weed_density = weed_density

        self.camera_fov_x = .2
        self.camera_fov_y = .3937
        self.camera_height = .4

        self.cam_points = []
        # rospy.Subscriber("/cam_points", Marker, self.sim_camera_callback)
        self.populate_lawn()
        rate = rospy.Rate(10)
        count = 0;

        self.generate_scan_area()
        start_time = rospy.Time.now();
        while not rospy.is_shutdown():
            if((count % 4 == 0)):
                
                lawn_pub.publish(self.m)
                count = 0
            current_time = rospy.Time.now();
            print("Coverage: %.2f/%.2f [m^2] = %.3f%% Coverage Rate: %.2f [m^2/hr]"
                % (self.cellsize**2*self.num_explored,
                self.cellsize**2*self.map.size,
                100*float(self.num_explored)/self.map.size,
                60*60*self.cellsize**2*self.num_explored/((current_time-start_time).to_sec())))
            
            count +=1
            # self.sim_camera(
            self.update_scan()
            self.cam_point_pub.publish(self.cam_marker)
            rate.sleep()



    def populate_lawn(self):
        
        self.map = np.around(np.random.rand(self.length,self.width)-.475)
        self.m = Marker();
        self.m.type = 6;
        self.m.id = 3;
        self.m.scale.x = self.cellsize;
        self.m.scale.y = self.cellsize;
        
        self.m.lifetime = rospy.Duration(0)

        self.m.header.frame_id = "/world"
        self.m.header.stamp = rospy.Time(0)
        self.m.ns = "lawn_grid"
        self.m.pose.orientation.w = 1;


        for i in xrange(0,self.map.shape[0]):
            for j in xrange(0,self.map.shape[1]):
                (x,y) = self.grid2point(i,j)
                p = Point(x,y,0)

                if(self.map[i,j] == 1):
                    c = ColorRGBA(0,.5,0,.25)
                    
                else:
                    c = ColorRGBA(0,1,0,.25)
                
                self.m.colors.append(c)
                self.m.points.append(p);

    
    def init_marker(self):
        self.cam_marker = Marker();
        self.cam_marker.type = 6;
        self.cam_marker.id = 4;
        self.cam_marker.scale.x = .05;
        self.cam_marker.scale.y = .05;
        self.cam_marker.scale.z = .05;
        
        self.cam_marker.color.r = 1;
        self.cam_marker.color.a = 1;

        self.cam_marker.lifetime = rospy.Duration(0)
        self.cam_marker.header.frame_id = "/camera"
        self.cam_marker.header.stamp = rospy.Time(0)
        self.cam_marker.ns = "cam_points"
        self.cam_marker.pose.orientation.w = 1;
        self.cam_marker.points = [];

    def generate_scan_area(self):
        self.init_marker()

        # angle = math.atan2(self.camera_fov_x,self.camera_fov_y);
        # xpts = [1, -1 ,1, -1, -1, 1]
        # ypts = [0, 0 ,1, 1, -1, -1]
        self.xpts = np.linspace(-self.camera_fov_x/2.0,self.camera_fov_x/2.0,np.ceil(self.camera_fov_x/self.cellsize),False)
        self.ypts = np.ones(self.xpts.shape)*self.camera_fov_y/2.0
        for i in xrange(0,self.xpts.size):
            current_point = PointStamped()
            current_point.header.frame_id = "/camera"
            current_point.point.x = self.xpts[i]
            current_point.point.y = self.ypts[i]
            current_point.point.z = -self.camera_height            
            self.cam_marker.points.append(current_point.point)
            self.cam_points.append(current_point)
            current_point = PointStamped()
            current_point.header.frame_id = "/camera"
            current_point.point.x = self.xpts[i]
            current_point.point.y = -self.ypts[i]
            current_point.point.z = -self.camera_height            
            self.cam_marker.points.append(current_point.point)
            self.cam_points.append(current_point)

    def update_scan(self):
        for i in xrange(0,2,len(self.cam_marker.points)):
            self.scan_row(self.cam_points[i],self.cam_points[i+1])

        
    def scan_row(self,point0,point1):

        try:
            p0 = self.transformer.transformPoint("/world",point0).point
        except:
            print("scan failed")
            return
        try:
            p1 = self.transformer.transformPoint("/world",point1).point
        except:
            print("scan failed")
            return

        self.scan_points(p0,p1);

    def grid2point(self,i,j):
        x = (i)*self.cellsize
        y = (j)*self.cellsize
        return(x,y)

    def point2grid(self,x,y):
        i = int(round(x/self.cellsize))
        j = int(round(y/self.cellsize))
        return(i,j)

    def get_marker_index(self,i,j):
        index = i*self.map.shape[1] + j
        return index

    def scan_points(self,p0,p1):
        scan_num = 6
        xpts = np.linspace(p0.x,p1.x,scan_num)
        ypts = np.linspace(p0.y,p1.y,scan_num)
        all_points_in_boundary = True;
        for k in xrange(1,scan_num-1):
            (i,j) = self.point2grid(xpts[k],ypts[k]);
            
            idx = self.get_marker_index(i,j);
            if(0<=i<self.map.shape[0] and 0<=j<self.map.shape[1]):
                if(self.m.colors[idx].a != 1):
                    self.m.colors[idx].a = 1
                    self.num_explored += 1;
                if(self.map[i,j]==1):
                    print("Weed at (%f,%f)" % (xpts[k],ypts[k]))
                    (xg,yg) = self.grid2point(i,j)
                    p = Pose2D()
                    p.x = xg;
                    p.y = yg;
                    p.theta = 0;
                    self.m.colors[idx].r = 1
                    # self.m.colors[idx].g = 0
                    # self.weed_pub.publish(p)

            else:
                all_points_in_boundary = False
                # self.boundary_pub.publish(1);

        if(all_points_in_boundary):
            pass
            # self.boundary_pub.publish(0);

            


    def elimination_sim(self,goal):
        try:
            (trans,rot) = self.transformer.lookupTransform('/world', '/robot', rospy.Time(0))
        except (tf.LookupException, tf.ConnectivityException, tf.ExtrapolationException):
            print("Failed to lookup transfrom between eliminator and world")

        

        (i,j) = self.point2grid(trans[0],trans[1])
        idx = self.get_marker_index(i,j);

        print("DRILLING WEED AT %f %f" % self.grid2point(i,j))
        if(self.map[i,j] == 1):
            self.map[i,j] = 0;
            self.m.colors[idx].r = 0
            self.m.colors[idx].g = 1
            self.result.success = 1;
        else:
            self.result.success = 0;

        self.action_server.set_succeeded(self.result)


if __name__ == '__main__':
    length = 25;
    width = 25;
    weed_density = 1;
    s = Sim(length, width, weed_density);