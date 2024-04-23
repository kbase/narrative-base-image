# narrative-base-image
The base Docker image for the Narrative application.

This grew from the original `kbase/narrbase` image that was part of the [kbase/narrative](https://github.com/kbase/narrative) repo. This contains various dependencies that the Narrative app depends on, but tend to update at a slower frequency. Also, this image takes a good half hour to build, which isn't great for rapid prototyping of the Narrative app itself, or easy review of pull requests.

Thus, the need for a separate base image.

## Dependencies
### R
R dependencies are installed via the `install-r-packages.R` script that is run during the Docker image build. Add and maintain R packages there.

### NodeJS
No node packages are installed (i.e. there's no `package.json` here), but the core Node program version is maintained here. This is set in the `Dockerfile` itself.

### Python
The image uses a version of the default maintained Python image. No other python packages are installed here.

### Building the image
Build the image with:
`docker build -t kbase/narrative-base-image:$VERSION .`

### Versioning rules
This follows the usual semantic versioning format - vA.B.C, with the following guidelines:
* patch versions change when one or more dependencies are updated
* minor versions change when one or more dependencies are added or removed
* major versions change if and when major structural changes are made. These include, but may not be limited to:
    * adding/removing dependent languages (like if we drop R support or add Rust support)
    * combining or creating new dependency tracking files
    * any dependency change that may require a major update to Narrative management (i.e. including JupyterLab, base Python version change, switching from Debian to another distribution, etc.)
