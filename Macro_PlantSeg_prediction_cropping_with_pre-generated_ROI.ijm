//Macro that uses ROIs generated in "Macro_ROI_generation_for_cropping_images" for cropping PlantSeg predictions.

//INPUT: ROI used for cropping and PlantSeg predictions that shall be cropped.
//OUTPUT: Folder containing cropped PlantSeg predictions.

//define input and output directories
input=getDirectory("Folder containing PlantSeg predictions")
output = getDirectory("Choose folder to save cropped PlantSeg predictions in")
ROI_output = getDirectory("Select folder containing the ROIs for cropping")

//Set Colour picker settings to black so that areas to be cut out fill be filled with black. If the background of your image is white you should change the settings to white.
run("Color Picker...");
setForegroundColor(0, 0, 0);
setBackgroundColor(255, 255, 255);

//Apply ROIs on the corresponding PlantSeg predictions and save cropped PlantSeg predictions in a separate folder (output)

//Open all prediction images
//get a list of all files in the input directory and open all of them with the Bioformats importer
list2 = getFileList(input);
for (i = 0; i < list2.length; i++) {
	filename=input+list2[i];
	open(filename);
			
	//get a list of all names of open images and save it in a new variable "image.titles"
	open_files = getList("image.titles");
	
	//open ROI that has the same name as Image stack. Apply ROI to the image and crop prediction. Save cropped image in a new folder.
	for (h = 0; h < open_files.length; h++) {
		selectWindow(open_files[h]);
		image_name = getTitle();
		//Open the corresponding ROI
		open(ROI_output+image_name+".roi");
		roiManager("add");
		//inverse the ROI selection to fill (black as fill colour as image has a black background) the area to be cropped. 
		run("Make Inverse");
		run("Fill", "slice");
		//save cropped image stack in output folder
		saveAs("Tiff", output+image_name);
		roiManager("delete");
		close();
	}
}
