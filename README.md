# install_gradle_RHEL_Ubuntu

        cd
        sudo yum install git -y > /dev/null 2>&1
        rm -rf install_gradle_RHEL_Ubuntu
        git clone https://github.com/nagaraj602/install_gradle_RHEL_Ubuntu.git > /dev/null 2>&1
        cd install_gradle_RHEL_Ubuntu || exit
        bash gradle.sh
        cd ..
        rm -rf install_gradle_RHEL_Ubuntu
