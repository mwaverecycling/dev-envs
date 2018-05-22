# Set locale
export LANG=en_US.UTF-8

# Add ROS2 repo
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo apt update -y

# Install dependencies
sudo apt install -y git wget build-essential cppcheck cmake libopencv-dev python-empy python3-dev python3-empy python3-nose \
python3-pip python3-pyparsing python3-setuptools python3-vcstool python3-yaml libtinyxml-dev libeigen3-dev libasio-dev libtinyxml2-dev

# Init project
mkdir -p ~/ros2_ws/src
cd ~/ros2_ws
wget https://raw.githubusercontent.com/ros2/ros2/release-latest/ros2.repos
wget https://raw.githubusercontent.com/ros2-for-arm/ros2/master/ros2-for-arm.repos
wget https://raw.githubusercontent.com/ros2-for-arm/ros2/master/aarch64_toolchainfile.cmake
vcs-import src < ros2.repos 
vcs-import src < ros2-for-arm.repos

# Install cross-compiler
sudo apt install -y g++-aarch64-linux-gnu gcc-aarch64-linux-gnu
export CROSS_COMPILE=aarch64-linux-gnu-

# Remove Python
sed -e '/py/ s/^#*/#/' -i src/ros2/rosidl_typesupport/rosidl_default_generators/CMakeLists.txt
sed -i -r 's/<build(.+?py.+?)/<\!\-\-build\1\-\->/' src/ros2/rosidl_typesupport/rosidl_default_generators/package.xml
touch \
    src/ros/resource_retriever/AMENT_IGNORE \
    src/ros2/demos/AMENT_IGNORE \
    src/ros2/examples/rclpy/AMENT_IGNORE \
    src/ros2/geometry2/AMENT_IGNORE \
    src/ros2/kdl_parser/AMENT_IGNORE \
    src/ros2/orocos_kinematics_dynamics/AMENT_IGNORE \
    src/ros2/rclpy/AMENT_IGNORE \
    src/ros2/rcl_interfaces/test_msgs/AMENT_IGNORE \
    src/ros2/rmw_connext/AMENT_IGNORE \
    src/ros2/rmw_opensplice/AMENT_IGNORE \
    src/ros2/robot_state_publisher/AMENT_IGNORE \
    src/ros2/ros1_bridge/AMENT_IGNORE \
    src/ros2/rosidl/rosidl_generator_py/AMENT_IGNORE \
    src/ros2/rviz/AMENT_IGNORE \
    src/ros2/system_tests/AMENT_IGNORE \
    src/ros2/urdf/AMENT_IGNORE \
    src/ros2/urdfdom/AMENT_IGNORE \
    src/ros2/urdfdom_headers/AMENT_IGNORE

# Build
src/ament/ament_tools/scripts/ament.py build --force-cmake-configure --cmake-args -DCMAKE_TOOLCHAIN_FILE=`pwd`/aarch64_toolchainfile.cmake -DTHIRDPARTY=ON
