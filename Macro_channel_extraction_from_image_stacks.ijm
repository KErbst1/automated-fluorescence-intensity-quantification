//This macro can be used for saving a single channel of image stacks in .tiff format. In this case the channel of the pH stable fluorophore will be saved.
//Prerequisites: You must know which channel contains the pH stable, instable and bright field (BF) images within your image stack. Make sure that all image stacks have the same channel order.  

//define input and output directories
input=getDirectory("Select the input folder")
output=getDirectory("Choose a destination folder")

//define the pH stable channel or the channel you want to extract from your image stack. If you have less or more than three channels make sure to adapt the code.
pHstable="C1-C2"
instable="C2-C2"
BF="C3-C2"

// Get a list of all LIF files to process in input dir and loop over them
list = getFileList(input);
for (i = 0; i < list.length; i++) {
	filename=input+list[i];
	// Open each lif file using the Bio-format importer either 'manually' or  directly opening all series 
	//open(filename); 
	run("Bio-Formats Importer", "open='" + filename + "' open_all_series color_mode=Default view=[Hyperstack] stack_order=XYCZT");
	// Get list of all open images and loop over them
	open_files = getList("image.titles");
	for (k=0; k< open_files.length; k++){
		// Split the channel of the selected image
		selectWindow(open_files[k]);		
		run("Split Channels");
		// Get again the list of all open images (now w/ the split channels) and loop over all of them
		open_channels = getList("image.titles");
		for (j=0; j< open_channels.length; j++){
			selectWindow(open_channels[j]);
			// If title of the selected window matches the one defined for the pHstable, save it as tiff
			// if it is the other channels close them, but leave the other opened images untouched.  
			title=getTitle();
			if(startsWith(title, pHstable)){
				saveAs("tiff", output+title);
				close();
			}else if (startsWith(title, instable)) {
				close();
			}else if (startsWith(title, BF)) {
				close();
			}
		}
	}
}
