
class Weed_Detector
{
	ros::NodeHandle n;

public:
	Weed_Detector();
	void run_detector();
	void track_weed();
};


Weed_Detector::Weed_Detector()
{
	
	ros::init(argc, argv, "detector");
	ros::NodeHandle n;
	return;
}


Weed_Detector::run_detector()
{
	ros::Rate loop_rate(10);
	
	while(ros::ok())
	{
		
		ros::spin();	
	}
}

int main(int argc, char const *argv[])
{
	
	Weed_Detector w = Weed_Detector();

	
	return 0;
}