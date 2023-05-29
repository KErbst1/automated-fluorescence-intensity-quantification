//Macro for creating a ROI to later cut out root tips of PlantSeg predictions and original calibration curve image stacks. 
//INPUT: folder that contains the images of one channel to use for selecting the area to keep after cropping.
//OUTPUT: ROIs saved in ROI_output defined folder.

//define input and output directories
input=getDirectory("Select image folder to use for generating croping ROIs")
ROI_output = getDirectory("Choose folder in which generated ROIs will be saved in")

//Set Colour picker settings to black
run("Color Picker...");
setForegroundColor(0, 0, 0);
setBackgroundColor(255, 255, 255);

//Open prediction folder. Manually draw selection for each image. Save manual selection as ROI that can later be used for cropping images.
list = getFileList(input);
for (j = 0; j < list.length; j++) {
		filename_prediction = input+list[j];
		open(filename_prediction);
			
		//get a list of all names of open images
		open_files = getList("image.titles");
			
		//loop through all open windows, select area. Save as ROI. Invert selection. Set pixels to black in inverted selection
		for (k=0; k< open_files.length; k++){
			selectWindow(open_files[k]);
			title = getTitle();
			title2 = substring(title, 3, title.length-17);
			setTool("rotrect");
			waitForUser("draw selection with rectangle, click ok");
			run("Create Mask");
			run("Create Selection");
			roiManager("Add");
			close();
			
			//get name of ROI and rename it to original microscopy image name
			roiManager("Select", 0);
			roiManager("save selected", ROI_output+title+".roi");
			roiManager("delete");
			close();
		}
}

