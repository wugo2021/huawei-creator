    git clone https://github.com/wugo2021/huawei-creator.git
.

    cd huawei-creator
-
Generate ARM64 AB (Huawei device) from ARM64 AB and include patchs and optimisations (target image name is s-ab.img):

   sudo ./run-huawei-ab.sh systemAB.img "LeaOS" "ANE-LX1"

Generate ARM64 A-only (Huawei device) from ARM64 AB . 〈target image name is (input file name)-aonly.img〉,  (deprecated since Android 12): 

   sudo ./run-huawei-aonly.sh systemAB.img "LeaOS" "PRA-LX1"
:     

    sudo bash run-huawei-aonly.sh systemAB.img "LeaOS" "PRA-LX1"
Generate ARM64 A-only (Huawei device) from ARM64 A-only . 〈target image name is (input file name)-aonly.img〉,  (deprecated since Android 12): 

    ssudo bash udo ./run-huawei-a-to-a.sh system.img 
