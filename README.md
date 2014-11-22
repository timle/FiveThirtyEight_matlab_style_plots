Nate Silver Matlab Style Plots
=====================

Inspired by this post:
http://dataorigami.net/blogs/napkin-folding/17543615-replicating-538s-plot-styles-in-matplotlib


I thought I would try and replicate the fivethirtyeight style within MATLAB. My goal was to require no post touch-ups. What you see here is generated on the fly.  

Matlab does not offer an easy way to remove the axis lines, while retaining the tick labels and grid. So the bulk of the code deals with drawing those elements manually.  

For alignment, I stuck with using the default of relative proportion. This is good if you plan on outputting different size plots, but makes alignment a little trickier. This is trade off between fivethirtyeight fidelity, and my own requirements.  

I used the excellent [export_fig](https://github.com/ojwoodford/export_fig) for rendering the png files.  


It's still a fairly crude implementation. Will likely break if anything too novel is tried. Have not done any testing beyond the two test cases included.  


## How To
The main function is:
```
ns17_plotter.m
```
Two examples (shown below) can be run via:
```
ns17_examples.m
```
The first examples uses the following function to generate data.
```
mkInvExpData_helper.m
```


## Example 1
![Alt text](https://raw.githubusercontent.com/timle/ns_matlab_style_plots/master/ex1%2012-Jul-2014_low_.png "Example 1")

## Example 2
![Alt text](https://raw.githubusercontent.com/timle/ns_matlab_style_plots/master/ex2%2012-Jul-2014_low_.png "Example 2")
