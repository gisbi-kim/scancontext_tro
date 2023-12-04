# Radar Scan Context 

- Scan Context also works for the radar data (i.e., Navtech radar) 
    - Radar Scan Context was introduced in the [MulRan dataset paper](https://irap.kaist.ac.kr/publications/gskim-2020-icra.pdf)
    - This directory contains the evaluation code, for [radar place recognition](https://sites.google.com/view/mulran-pr/radar-place-recognition), used in the MulRan paper. 
    - if you use the dataset or our method, please refer the paper:
    ```
    @INPROCEEDINGS { gskim-2020-icra,
        AUTHOR = { Giseop Kim, Yeong Sang Park, Younghun Cho, Jinyong Jeong, Ayoung Kim },
        TITLE = { MulRan: Multimodal Range Dataset for Urban Place Recognition },
        BOOKTITLE = { Proceedings of the IEEE International Conference on Robotics and Automation (ICRA) },
        YEAR = { 2020 },
        MONTH = { May },
        ADDRESS = { Paris }
    }
    ```
    
- More information about the radar data, please refer [MulRan](https://sites.google.com/view/mulran-pr/home) or Oxford Radar RobotCar dataset 
    
## How to use 
- 1. write your own MulRan dataset path in the main.m file 
- 2. run main.m (then some data and evaluation files will be generated)
- 3. run prcurve_drawer.m 
