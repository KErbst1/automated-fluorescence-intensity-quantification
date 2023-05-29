//FIBQ (Fluorescence intensity based quantification) Macro
//Macro for quantifying pixel intensities for later calibration curve generation. This macro quantifies pixel intesnsities of regions of interest in two channels (position1 and 2) of an image stack. 
//A ROI is generated for each image stack by extracting the image of the pH stable channel, applying smoothing on it and generating a ROI after selecting a suitable threshold.

//Input: Calibration curve images
//Output: .csv table with pixel intensities of two fluorophore channels. ROIs in separate ROI output folder.

//IMPORTANT: You must know the position of the pH stable channel within the image stacks to be processed. The position MUST be the same in all images to be analysed in one run.
//If your image stack contains a bright field image it is ideally at position 3 within your image stack. If this is not the case you have to either delete the bright field image for all image stacks or move it to position 3.  

//USER INPUT: 
//define input and output directories
input=getDirectory("Select the calibration curve images input folder")
output = getDirectory("Choose the output folder")
ROI_output = getDirectory("ROI output of FIBQ");

//define the name of the file that will be generated:
final_file_name="enter the filename HERE"

//Set Measurements so that the label of each sample is displayed
run("Set Measurements...", "area mean min display redirect=None decimal=3");

//choose channel for ROI generation (pH stable channel)
Segment = 2

//Predefine the amount of Gaussian Blur
Blur=1.5;

//Predefine the Radius for Background subtraction
Backsubtract=15;

//Predefine the auto-threshold
Threshold="Moments dark no-reset"



//Open all images of the CLSM images to be analysed from one folder.
list = getFileList(input);
for (j = 0; j < list.length; j++) {
		filename = input+list[j];
		open(filename);
			
		//get a list of all names of open images
		open_files = getList("image.titles");
			
		//loop through all open windows, generate a duplicate of the pH stable channel and create a ROI after gaussian blur and background substraction with it. 
		//Then apply ROI onto both channels and measure Fluorescent intensity
		for (k=0; k< open_files.length; k++){
			selectWindow(open_files[k]);
			title = getTitle();
			//generate a duplicate of the pH stable channel which is here in position = 2. Adapt the position depending on your channel order.
			run("Make Substack...", "channels="+Segment+"");
			title_dupl = getTitle();
			//apply a gaussian blur to the duplicated pH stable channel image
			run("Gaussian Blur...", "sigma="+Blur+"");
			//substract the background
			run("Subtract Background...", "rolling="+Backsubtract+"");
			//set an autothreshold. Adapt if necessary.
			setAutoThreshold(Threshold);
			setOption("BlackBackground", true);
			run("Create Mask");
			run("Create Selection");
			roiManager("add");
			//get name of ROI and rename it to original microscopy image name
			roiManager("Select", 0);
			//save generated ROI in the ROI_output folder
			roiManager("save selected", ROI_output+title+".roi");
			roiManager("delete");
			close(); //close active image
		}
}
close("*"); //close all images
			
//Apply ROI on the corresponding CLSM image on both channels.
//Measure fluorescent intensity in ROI and save measured intensities in an excel sheet.

//Open all stacks of images for each pH value
//get a list of all files in the input directory and open all of them with the Bioformats importer
list2 = getFileList(input);
for (i = 0; i < list2.length; i++) {
	filename=input+list2[i];
	open(filename);
	
	//get a list of all names of open images and save it in a new variable "image.title"
	open_files = getList("image.titles");
	
	//open ROI that has the same name as Image stack
	for (h = 0; h < open_files.length; h++) {
		selectWindow(open_files[h]);
		setSlice(1);
		image_name = getTitle();
		open(ROI_output+image_name+".roi");
		roiManager("add");
		//Apply ROI to images and quantify pixel intensitites.
		roiManager("measure");
		run("Next Slice [>]");
		roiManager("measure");
		roiManager("delete");
		close();
	}
}
saveAs("Results", output+final_file_name+".csv");

			
