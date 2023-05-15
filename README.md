    git clone https://github.com/wugo2021/huawei-creator.git
.

    cd huawei-creator
-
从 ARM64 AB 生成 ARM64 AB（华为设备）并包含补丁和优化（目标镜像名称为 s-ab.img）：

.

    sudo ./run-huawei-ab.sh systemAB.img "LeaOS" "ANE-LX1"

从 ARM64 AB 生成 ARM64 A-only（华为设备）。 〈目标图像名称是（输入文件名）-aonly.img〉，（自 Android 12 起已弃用）：

    sudo ./run-huawei-aonly.sh systemAB.img "LeaOS" "PRA-LX1"
:     

    sudo bash run-huawei-aonly.sh systemAB.img "LeaOS" "PRA-LX1"
从 ARM64 A-only 生成 ARM64 A-only（华为设备）。 〈目标图像名称是（输入文件名）-aonly.img〉，（自 Android 12 起已弃用）：

    sudo bash udo ./run-huawei-a-to-a.sh system.img 
