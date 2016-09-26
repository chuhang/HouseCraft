# HouseCraft  
Source code of  
**Hang Chu**, Shenlong Wang, Raquel Urtasun, Sanja Fidler. HouseCraft: Building Houses from Rental Ads and Street Views, ECCV 2016. ([paper](http://chuhang.github.io/files/publications/ECCV_16.pdf))|([project](http://www.cs.toronto.edu/housecraft))|([video](https://vimeo.com/174261051))  
## How to run
No need for external packages or extra configurations. In MATLAB, cd to `HouseCraft`, and excute  
`run`  
Then you should see something like this:  
```
step 1: compute all the renders, integral features, and losses  
processing house #74  
Processing time: xx seconds.  
step 2: compute all the final feature  
processing house #74  
Processing time: xx seconds.  
step 3: inference  
processing house #74  
Processing time: xx seconds.  
step 4: visualize  
```  
![](./readme_imgs/run.jpg "run results")  
(You may or may not need to recompile the ann toolbox at
`HouseCraft/ann_color/ann_wrapper`)  
## Test on the SydneyHouse dataset  
Download the SydneyHouse dataset from [the HouseCraft project page](http://www.cs.toronto.edu/housecraft).  
Unzip the downloaded zip file to the `HouseCraft` folder.  
In `HouseCraft/run.m`, modify line 7, 28, 45, 60 to `for ii=1:length(houseidlist)`.  
Excute `run`.
## Notes
- There are nearly a hundred functions in this project. I tried my best (as a graduate student) to comment all of them as much as I could.  
- I also included visualization options in many functions. For example, going into each individual functions, by setting a variable (typically named `display`) as 1, you will see things like:
![](./readme_imgs/visualization.jpg "visualization examples")  

