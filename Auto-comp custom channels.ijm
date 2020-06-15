starting_folder = getDirectory("Select Folder");
starting_folder_only = substring(starting_folder, 0, (lengthOf(starting_folder)-1));
//print(starting_folder);
nchannels = 4;
desired_channels = newArray(0,1,2,3);
//choose custom colour-channel designation
ch_defs = newArray(getString("Red - intended channel", "NA"),getString("Green - intended channel", "NA"), getString("Blue - intended channel", "NA"),
getString("Grey - intended channel", "NA"), getString("Cyan - intended channel", "NA"), getString("Magenta - intended channel", "NA"),
getString("Yellow - intended channel", "NA"));
//Array.print(ch_defs);
filetype = ".tif";
//Create new composites folder in which to save all comps
output = starting_folder_only+" Composites\\";
//print(starting_folder_only+" Composites\\");
//print(output);
File.makeDirectory(output);
//print(starting_folder_only + " Composites\\");

//Create array of all folders in test set
cond_list = getFileList(starting_folder_only);
//Array.print(cond_list);

//Start loop to run through cond_list, selecting each folder iteratively
for(i=0; i<cond_list.length; i++){
	curr_cond=cond_list[i];
//Make sure it's a directory
	if(endsWith(curr_cond, '/')){
		//print(curr_cond);
//Create full path to image folder
		img_fold_path = starting_folder + curr_cond;
		//print(img_fold_path);
//Find all image files as per file type specified at start
		img_all_list = getFileList(img_fold_path);
		//Array.print(img_all_list);
		img_tifs = newArray(0);
		img_prefix_tifs = newArray(0);
		for(j=0; j<img_all_list.length; j++){
			tif_val = indexOf(img_all_list[j],filetype);
			if(tif_val>0){
				img_tifs = Array.concat(img_tifs, img_all_list[j]);
				img_prefix_tifs = Array.concat(img_prefix_tifs, substring(img_all_list[j], 0, 12));
			}
		}
		unique_img_pref_list = ArrayUnique(img_prefix_tifs);
		//Array.print(img_prefix_tifs);
		//Array.print(unique_img_pref_list);
		for(k=0; k<unique_img_pref_list.length; k++){
		//for(k=0; k<1; k++){
			for(p=0; p<img_tifs.length; p++){
				//print(indexOf(img_tifs[p], unique_img_pref_list[k]));
				if(indexOf(img_tifs[p], unique_img_pref_list[k])>=0){
					//print(img_fold_path + img_tifs[p]);
					open(img_fold_path + img_tifs[p]);
				}
			}
			wait(20);
			//set up merge channel instruction based on starting information
			merge_instr = " ";
			for(l=0; l<ch_defs.length; l++){
				if(indexOf(ch_defs[l], "NA")<0){
					merge_instr = merge_instr + "c" + (l+1) + "=" + unique_img_pref_list[k] + ch_defs[l] + ".tif ";
					//print(instr_string);
				}
			}
			//perform merge channel
			merge_instr = merge_instr + "create";
			//print(merge_instr);
			run("Merge Channels...", merge_instr);
			//Save to new directory as set up at the start, close and move on
			saveAs("tiff", output + substring(curr_cond,0, (lengthOf(curr_cond)-1)) + " " +(k+1));
			//close();
			run("Close All");
		}
	}
}
		

//FUNCTIONS...............................................
array=newArray(1);
function ArrayUnique(array) {
	array	= Array.sort(array);
	array 	= Array.concat(array, 999999);
	uniqueA = newArray();
	i = 0;	
   	while (i<(array.length)-1) {
		if (array[i] == array[(i)+1]) {
			//print("found: "+array[i]);			
		} else {
			uniqueA = Array.concat(uniqueA, array[i]);
		}
   		i++;
   	}
	return uniqueA;
}