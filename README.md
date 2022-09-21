# narrative-base-image
The base Docker image for the Narrative application.

This grew from the original `kbase/narrbase` image that was part of the [kbase/narrative](https://github.com/kbase/narrative) repo. This contains various dependencies that the Narrative app depends on, but tend to update at a slower frequency. Also, this image takes a good half hour to build, which isn't great for rapid prototyping of the Narrative app itself, or easy review of pull requests.

Thus, the need for a separate base image.

## Dependencies
### Python
Python dependencies are split into 3 files:
1. `base-pip-requirements.txt` includes a series of useful Python packages that KBase Narrative code is built on or otherwise uses.
2. `jupyter-pip-requirements.txt` includes the Jupyter packages used - notebook, ipython, and ipywidgets for now. 
3. `kbase-pip-requirements.txt` includes scientific programming packages such as sklearn and numpy that are useful for KBase users.

This breaking apart is mostly for simplicity of understanding what's used and where to find packages to update.

### R
R dependencies are installed via the `install-r-packages.R` script that is run during the Docker image build. Add and maintain R packages there.

### NodeJS
No node packages are installed (i.e. there's no `package.json` here), but the core Node program version is maintained here. This is set in the `Dockerfile` itself.

### Building the image
Build the image with:
`docker build -t kbase/narrative-base-image:$VERSION .`

