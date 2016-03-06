#include <ros/ros.h>
#include <tf/transform_listener.h>
#include <geometry_msgs/Pose2D.h>

#include <std_msgs/String.h>
#include <Eigen/Core>
#include <Eigen/Geometry>
#include <iostream>
#include <math.h> 
#include <visualization_msgs/Marker.h>
#include <tf/transform_broadcaster.h>
#include <stdlib.h>

#include <actionlib/server/simple_action_server.h>
#include <planner/gen_trajAction.h>


class Sim_Lawn
{
	float weed_density;
	float length;
	float width;
	Eigen::MatrixxD lawn_array;

public:
	Sim_Lawn(float, float, float);

};


