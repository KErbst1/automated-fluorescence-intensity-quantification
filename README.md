# automated-fluorescence-intensity-extraction
Codes for automated image processing in Fiji to generate calibration curves from confocal laser scanning microscopy images. In both methods, CPBQ and FIBQ, fluorescence intensities are measured in cell walls.

## Macro_channel_extraction_from_image_stacks.ijm
This Fiji macro can be used for extracting the pH stable channel from an image stack as .tif in a new folder.

## Macro_CPBQ.ijm
Cell boundary Prediction Based Quantification (CPBQ)
This Fiji macro uses PlantSeg prediction images to generate ROIs that are applied onto the original image stacks to quantify pixel intensities solely at cell walls. The quantifications are later used for the plotting of calibration curves.

Input: Cell boundary predictions from PlantSeg (https://github.com/hci-unihd/plant-seg). To generate these predictions one must feed .tif images of the pH stable channel into PlantSeg. The pH stable channel can be extracted from image stacks with "Macro_channel_extraction_from_image_stacks.ijm"
Output: Excel sheet with measurements of fluorescence intensities of channel 1 and channel 2 of an image stack in regions of interest which were defined based on PlantSeg predictions.

## Macro_FIBQ.ijm
Fluorescence Intensity Based Quantification (FIBQ)
This Fiji macro uses the pH stable channel of an image stack to generate a ROI post smoothing (gaussian blur, substract background). The generated ROI is then applied onto the original image stack to quantify pixel intensities. The quantifications are later used for the plotting of calibration curves.

Input: Image stacks for calibration curve generation in .lif format
Output: Excel sheet with measurements of fluorescence intensities of channel 1 and channel 2 of an image stack in regions of interest which were defined by the pH stable channel. 

## Macro_ROI_generation_for_cropping_images.ijm
This Fiji macro generates ROIs via manual selection that which will be applied onto PlantSeg predictions (Macro_PlantSeg_prediction_cropping_with_pre-generated_ROI.ijm) and original image stacks (Macro_Image_stack_cropping_with_pre-generated_ROI.ijm) for cutting out root tips. 

## Macros for cutting out selected regions of images
### Macro_PlantSeg_prediction_cropping_with_pre-generated_ROI.ijm
Macro that applies ROI from (Macro_ROI_generation_for_cropping_images.ijm) onto PlantSeg predictions to cut out root tips.
### Macro_Image_stack_cropping_with_pre-generated_ROI.ijm
Macro that applies ROI from (Macro_ROI_generation_for_cropping_images.ijm) onto original image stacks to cut out root tip in all channels of the image stack.
