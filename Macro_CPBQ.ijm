//Macro for automated Fluorescent intensity extraction after applying smooting to CLSM images for calibration curve generation. 

//PREREQUISITES are a folder with all pH images in .tif format and an output folder where measurements will be saved in. 
//Make sure that you know which channel the pH stable one is and in which position of the image stack it is located. In this case the stable channel is in channel2 and stack position2. 
//If you have a bright field image next to different channels make sure that you know in which position this image is within your stack. Ideally it should be in stack position3. 
//If not, please adapt the masurement part where the ROI is first applied to the first channel and then onto the second channel. 

//define input and output directories
input1=getDirectory("Predictions input folder")
input2=getDirectory("Calibration curve input folder")
ROI_output=getDirectory("ROI destination folder")
output = getDirectory("Output folder")

//define a name for the file that will be generated
final_file_name="USER_INPUT_NAME"

//Set Measurements so that the label of each sample is displayed
run("Set Measurements...", "area mean min display redirect=None decimal=3");

//Open prediction. Set Threshold "Otsu". Convert image to mask. 
//list0 = getFileList(ROI_output);
//if (list0.length==0) {
	//waitForUser("Warning", "ROI output folder not empty: click ok to over-ride the current ROI");	
	
	list1 = getFileList(input1);
	for (j = 0; j < list1.length; j++) {
		filename_prediction = input1+list1[j];
		open(filename_prediction);
			
			//get a list of all names of open images
			open_files = getList("image.titles");
			
			//loop through all open windows, set the threshold to "Otsu" and create a ROI
			for (k=0; k< open_files.length; k++){
				selectWindow(open_files[k]);
				title = getTitle();
				title2 = substring(title, 3, title.length-17);
				setAutoThreshold("Default dark no-reset");
				run("Convert to Mask");
				run("Create Selection");
				roiManager("Add");
				//get name of ROI and rename it to original microscopy image name
				roiManager("Select", 0);
				roiManager("save selected", ROI_output+title2+".tif"+".roi");
				roiManager("delete");
			close();
			}
		}
//}

//Apply ROI on the corresponding CLSM image on both channels.
//Measure fluorescent intensity in ROI and save measured intensities in an excel sheet.


//Open all stacks of images for each pH value
//get a list of all files in the input directory and open all of them with the Bioformats importer
list2 = getFileList(input2);
for (i = 0; i < list2.length; i++) {
	filename=input2+list2[i];
	open(filename);

	//get a list of all names of open images and save it in a new variable "image.title"
	open_files = getList("image.titles");
	
	//open Roi that has the same name as Image stack
	for (h = 0; h < open_files.length; h++) {
		selectWindow(open_files[h]);
		setSlice(1);
		image_name = getTitle();
		open(ROI_output+image_name+".roi");
		roiManager("add");
		roiManager("measure");
		run("Next Slice [>]");
		roiManager("measure");
		roiManager("delete");
		close();
	}
}
saveAs("Results", output+final_file_name+".csv");
