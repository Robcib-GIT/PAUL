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

The algorithm developed here achieves errors of less than 1mm with execution times fast enough for soft robots. Contrary to what happens in many methodologies, the algorithm allows the position of the robot's intermediate modules to be chosen.

The hyperparameters have been decided starting from those established [in this work](https://www.mdpi.com/2075-1702/11/10/952) and then making small variations with the aim of finding a solution capable, at the same time, of achieving good precision in low times.

The following table shows the results of the hyperparameter optimisation. The number of individuals and elitism and mutation rates have been varied. For each hyperparameter setup, the algorithm has been runned 40 times. For all of them, median error and execution time have been compared for the genetic algorithm without shape control.

<details>
  <summary><strong>Hyperparameter optimisation table</strong></summary>
  <table>
<thead>
<tr>
<th># of individuals</th>
<th>Parents&#39; rate</th>
<th>Mutation rate</th>
<th>Median error (mm)</th>
<th>Median time (s)</th>
</tr>
</thead>
<tbody>
<tr>
<td>25</td>
<td>0.1</td>
<td>0.7</td>
<td>1.30</td>
<td>3.68</td>
</tr>
<tr>
<td>25</td>
<td>0.1</td>
<td>0.8</td>
<td>1.33</td>
<td>3.91</td>
</tr>
<tr>
<td>25</td>
<td>0.2</td>
<td>0.7</td>
<td>1.31</td>
<td>3.42</td>
</tr>
<tr>
<td>25</td>
<td>0.2</td>
<td>0.8</td>
<td>1.36</td>
<td>3.42</td>
</tr>
<tr>
<td>25</td>
<td>0.3</td>
<td>0.7</td>
<td>1.07</td>
<td>3.05</td>
</tr>
<tr>
<td>25</td>
<td>0.3</td>
<td>0.8</td>
<td>1.99</td>
<td>3.14</td>
</tr>
<tr>
<td>50</td>
<td>0.1</td>
<td>0.7</td>
<td>0.91</td>
<td>6.19</td>
</tr>
<tr>
<td>50</td>
<td>0.1</td>
<td>0.8</td>
<td>0.90</td>
<td>4.56</td>
</tr>
<tr>
<td><strong>50</strong></td>
<td><strong>0.2</strong></td>
<td><strong>0.7</strong></td>
<td><strong>0.88</strong></td>
<td><strong>4.31</strong></td>
</tr>
<tr>
<td>50</td>
<td>0.2</td>
<td>0.8</td>
<td>0.88</td>
<td>4.81</td>
</tr>
<tr>
<td>50</td>
<td>0.3</td>
<td>0.7</td>
<td>0.99</td>
<td>6.12</td>
</tr>
<tr>
<td>50</td>
<td>0.3</td>
<td>0.8</td>
<td>0.90</td>
<td>5.03</td>
</tr>
<tr>
<td>75</td>
<td>0.1</td>
<td>0.7</td>
<td>0.86</td>
<td>5.40</td>
</tr>
<tr>
<td>75</td>
<td>0.1</td>
<td>0.8</td>
<td>0.82</td>
<td>5.37</td>
</tr>
<tr>
<td>75</td>
<td>0.2</td>
<td>0.7</td>
<td>0.84</td>
<td>5.75</td>
</tr>
<tr>
<td>75</td>
<td>0.2</td>
<td>0.8</td>
<td>0.71</td>
<td>5.95</td>
</tr>
<tr>
<td>75</td>
<td>0.3</td>
<td>0.7</td>
<td>0.82</td>
<td>6.52</td>
</tr>
<tr>
<td>75</td>
<td>0.3</td>
<td>0.8</td>
<td>0.85</td>
<td>6.58</td>
</tr>
<tr>
<td>100</td>
<td>0.1</td>
<td>0.7</td>
<td>0.79</td>
<td>5.17</td>
</tr>
<tr>
<td>100</td>
<td>0.1</td>
<td>0.8</td>
<td>0.83</td>
<td>5.14</td>
</tr>
<tr>
<td>100</td>
<td>0.2</td>
<td>0.7</td>
<td>0.74</td>
<td>5.79</td>
</tr>
<tr>
<td>100</td>
<td>0.2</td>
<td>0.8</td>
<td>0.83</td>
<td>7.02</td>
</tr>
<tr>
<td>100</td>
<td>0.3</td>
<td>0.7</td>
<td>0.81</td>
<td>8.19</td>
</tr>
<tr>
<td>100</td>
<td>0.3</td>
<td>0.8</td>
<td>0.87</td>
<td>7.55</td>
</tr>
</tbody>
</table>
 
</details>

## Directory index ##

- Code_arduino: Arduino code for controlling the pneumatic actuation bench, which sends the necessary compressed air to move the robot.
- Code_matlab: Matlab code. It includes the control interface, where one can control everything related to computer vision, communications between the robot and the computer, the actuation signals, etc.
- CAD: Everything related to the CAD designs, from the molds to the joints of the robot. They were designed using Autodesk Fusion 360.
- Memoria: Everything related to the thesis documentation.

## Published works ##

García-Samartín, J.F.; Rieker, A.; Barrientos, A. Design, Manufacturing, and Open-Loop Control of a Soft Pneumatic Arm. _Actuators_ **2024**, 13, 36. https://doi.org/10.3390/act13010036

García-Samartín, J.F.; Molina-Gómez, R.; Barrientos, A. Model-Free Control of a Soft Pneumatic Segment. _Biomimetics_ **2024**, 9, 127. https://doi.org/10.3390/biomimetics9030127
