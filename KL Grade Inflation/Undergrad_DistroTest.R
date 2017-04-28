library(readxl)
library(flexmix) 
library(foreach)
library(xlsx)
df <- read_excel("C:/Users/Qubix/Desktop/R-Sources/R-Sources/KL Grade Inflation/UData.xlsx")

unique_ids<-unique(unlist(df$`Moodle Id`));
unique_faculty<-unique(unlist(df$Faculty));
if(NA %in% unique_faculty[length(unique_faculty)]){unique_faculty<-unique_faculty[-length(unique_faculty)];}
list_by_MoodleID<-split(df, f = df$`Moodle Id`);
list_by_Faculty<-split(df, f = df$Faculty); # Used to compare grade distro to test_gdist.

# Perform KLdiv to detect inflation in Final Grades relative to test_gdist.

foreach(n = unique_faculty) %do% {
  assign(paste0(n), as.data.frame(list_by_Faculty[[n]])$FinalGrade); # Collects all final grades and addes them to df_FG for analysis.
}

KL_comp_results<-matrix(nrow = 3); # Used to store the final KLDiv data by unique_faculty.

foreach(n = unique_faculty) %do% {
  ftemp<-as.matrix(get(paste0(n))); # Fetch faculty's grade, by iterator.
  test_gdist<-rnorm(length(as.matrix(get(paste0(n)))),0.75,0.1); # Provides the reference normal distribution for KLdiv.
  temp<-cbind(test_gdist, ftemp); # Setup the test distribution and faculty data for recording.
  colnames(temp)<-c("Test", paste0(n)); # Correct the colnames in temp.
  KL_result<-KLdiv(temp); # Compute the divergence.
  KL_comp_results<-cbind(KL_comp_results,c(paste0(n), KL_result[2,1], mean(get(paste0(n))))); # Bind the results to an object waiting to be serialized XLSX.
}

#KL_data<-sapply(KL_data, as.numeric); # Prepare the summary data and dump the data into file.
#KL_summary<-summary(KL_data);
#KL_comp_results<-rbind(KL_comp_results, KL_summary);
write.xlsx(x = KL_comp_results, file = "output/U_KLDivResults.xlsx", row.names = FALSE); # Write the data.



