//Macro that uses ROIs generated in "Macro_ROI_generation_for_cropping_images" for cropping image stacks.

//INPUT: ROI used for cropping and image stacks that shall be cropped.
//OUTPUT: Folder containing cropped image stacks.

//define input and output directories
input=getDirectory("Folder containing calibration curve images")
output = getDirectory("Choose Output folder for cropped calibration curve images")
ROI_output = getDirectory("Select folder containing ROIs for cropping")

//Set Colour picker settings to black so that areas to be cut out fill be filled with black. If the background of your image is white you should change the settings to white.
run("Color Picker...");
setForegroundColor(0, 0, 0);
setBackgroundColor(255, 255, 255);

//Apply ROI on the corresponding image stack on all channels.

//Open all image stacks for each pH value
//get a list of all files in the input directory and open all of them with the Bioformats importer
list = getFileList(input);
for (i = 0; i < list.length; i++) {
	filename=input+list[i];
	run("Bio-Formats Importer", "open='" + filename + "' open_all_series color_mode=Default view=[Hyperstack] stack_order=XYCZT");
	
	//get a list of all names of open images and save it in a new variable "image.titles"
	open_files = getList("image.titles");
	
	//open ROI that has the same name as Image stack. Apply ROI onto image stack and crop it. Save cropped image stack in a new folder (output).
	for (h = 0; h < open_files.length; h++) {
		selectWindow(open_files[h]);
		image_name = getTitle();
		//Open ROI with the same name as the image stack
		open(ROI_output+"C2-"+image_name+"_predictions.tiff.roi");
		roiManager("add");
		//inverse the ROI selection to fill (black as fill colour as image has a black background) the area to be cropped. 
		run("Make Inverse");
		run("Fill", "stack");
		//save cropped image stack in output folder
		saveAs("Tiff", output+image_name);
		roiManager("delete");
		close();
	}
}

