# DeconvolutionLab2

Welcome! Follow the steps below to learn how to use [DeconvolutionLab2](https://bigwww.epfl.ch/deconvolution/deconvolutionlab2/) for deconvolving a 3D microscopy image. The aim of this guide is to walk you through a very simple example so that you can get started quickly on your own project.

## Setup

- Right-click on this document and select `Show Markdown Preview`.
- Deactivate the "Simple" interface at the bottom-left of this pannel, so that you can see the Jupyter tabs.
- Start a remote desktop by selecting `File > New Launcher` and clicking on the "Desktop" icon.

## Deconvolution demo

- Start Fiji by doubel-clicking on the "ImageJ" icon on the desktop (you can close the "Welcome to Fiji" message).
- Select `Plugins > DeconvolutionLab2 > DeconvolutionLab2 Launch`.
- Drag the example image `Drosophila.tif` from the desktop into the input "Image" field of DeconvolutionLab2.
- Drag the point spread function image `drosophila_psf.tif` into the "PSF" field.
- Select `Richardson-Lucy` as an algorithm and set the number of iterations to 20 (you can experiment with that number to see its effect on the results).
- Run the deconvolution by pressing "Run". When the process is complete, a deconvolved version of the drosophila image should appear in Fiji.

## Diving deeper

To learn more about deconvolution, you can take a look at the following resources:

- [DeconvolutionLab2](https://bigwww.epfl.ch/deconvolution/deconvolutionlab2/) - Plugin homepage.
- [DeconvolutionImagingLunch](https://github.com/EPFL-Center-for-Imaging/DeconvolutionImagingLunch/tree/main) - Deconvolution workshop material from Dr. V. Stergiopoulou in EPFL (2025) with detailed instructions.