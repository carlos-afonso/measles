# Visualizing the 2019 Measles Outbreak

All visualizations presented and explained in the project homepage: https://carlos-afonso.github.io/measles

## Requirements

In addition to Python, the following 10 packages are also required for this project:
* bokeh
* folium
* imageio
* jupyterlab
* matplotlib
* pandas
* phantomjs
* pillow 
* selenium
* xlrd

I recommend you use the following conda commands to create a new  `measles` environment and install all the necessary packages:

1. Create a new `measles` environment and install 8 of the 10 necessary packages:

`conda create -n measles python bokeh imageio jupyterlab matplotlib pandas pillow selenium xlrd`

2. Activate the new `measles` environment:

`conda activate measles`

3. Install the remaining 2 necessary packages (in the `measles` environment):

`conda install -c conda-forge folium phantomjs`

Reference about managing conda environments: https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html
