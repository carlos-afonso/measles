# Visualizing the 2019 Measles Outbreak

All visualizations presented in the project homepage: https://carlos-afonso.github.io/measles

## PyData NYC 2019 tutorial

The `pydata-nyc-2019` folder contains all the materials needed for the tutorial, and `pydata-nyc-2019/notebooks/pydata-nyc-2019-tutorial.ipynb` is the tutorial's main/driving notebook.

Please refer to the Requirements section below about the package requirements and installation instructions.

## Requirements

This package requires the following 12 packages:
* python
* bokeh
* folium
* imageio
* jupyterlab
* matplotlib
* nodejs
* pandas
* phantomjs
* pillow
* selenium
* xlrd

Moreover, it's convenient to have the `jupyterlab-toc` extension.

I recommend that you run the following conda commands __sequentially__ to create a new environment for this project and install all the necessary packages.

1. While on the base environment, use the following command to create a new `measles` environment and install 9 of the 12 necessary packages:

`(base) username> conda create -n measles python bokeh imageio jupyterlab matplotlib pandas pillow selenium xlrd`

2. Use the following command to activate the new `measles` environment:

`(base) username> conda activate measles`

3. Once the `measles` environment is activated, use the following command to install the remaining 3 necessary packages:

`(measles) username> conda install -c conda-forge folium nodejs phantomjs`

4. Use the following command to install the `jupyterlab-toc` extension:

`(measles) username> jupyter labextension install @jupyterlab/toc`

5. Now you are ready and you can use the following command to lunch jupyterlab, where you can open and run this project's notebooks:

`(measles) username> jupyter lab`

Note about the commands above:
* The actual commands start after the `>` symbol. The `(base) username>` and `(measles) username>` parts are provided to help understand the active environment and each point.
* The commands above use `measles` as the name for the new environment but you can use a different name if you prefer.
* The whole installation process takes about 5 minutes.

If necessary, this is a good reference about managing conda environments: https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html
