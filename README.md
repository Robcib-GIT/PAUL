# Pneumatic Actuated Ultrasoft Limb (PAUL)

In this repository you will find all the code necessary for the control of the PAUL soft robot. Due to the problems that can be associated with working with it and the difficulty of building it, it is also possible to work using a built-in simulator. The programming language used is Matlab.

![image](https://user-images.githubusercontent.com/92983875/197029208-5e46d80d-6c36-4bec-9547-3e9aa1b69e1d.png)

![image](https://user-images.githubusercontent.com/92983875/197028795-6f54991a-0070-4044-a94e-e584cdc8ee79.png)

## Available videos ##

- [Manufacturing Process](https://www.youtube.com/watch?v=WlBE3JDpxWw)
- [General Working](https://www.youtube.com/watch?v=1XM6AjTwlqs)
- [One Module Control](https://www.youtube.com/watch?v=sqhGBfGOFts)

## Inverse Kinematics ##

We are currently working on the development of several inverse kinematics methods. We will post updates here when they reach a first functional level.

Although we are open to explore different possibilities, we consider, for the moment, to use optimisation-based algorithms (such as CCD or FABRIK), search methods (type A*), genetic algorithms and, of course, reinforcement learning.

### Genetic Algorithm


## Directory index ##

- Code_arduino: Arduino code for controlling the pneumatic actuation bench, which sends the necessary compressed air to move the robot.
- Code_matlab: Matlab code. It includes the control interface, where one can control everything related to computer vision, communications between the robot and the computer, the actuation signals, etc.
- CAD: Everything related to the CAD designs, from the molds to the joints of the robot. They were designed using Autodesk Fusion 360.
- Memoria: Everything related to the thesis documentation.

## Published works ##
García-Samartín, J.F.; Rieker, A.; Barrientos, A. Design, Manufacturing, and Open-Loop Control of a Soft Pneumatic Arm. _Actuators_ **2024**, 13, 36. https://doi.org/10.3390/act13010036
García-Samartín, J.F.; Molina-Gómez, R.; Barrientos, A. Model-Free Control of a Soft Pneumatic Segment. _Biomimetics_ **2024**, 9, 127. https://doi.org/10.3390/biomimetics9030127
