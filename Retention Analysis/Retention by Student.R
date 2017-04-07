library(readxl)
library(foreach)
df <- read_excel("C:/Users/Qubix/Desktop/R-Sources/R-Sources/Retention Analysis/Copy of 2016 Final Grades II.xlsx")

# First, before breaking up by student name, we have to recode CT# to #.
df$Term[df$Term=="CT1"]<-1;
df$Term[df$Term=="CT2"]<-2;
df$Term[df$Term=="CT3"]<-3;
df$Term[df$Term=="CT4"]<-4;
df$Term[df$Term=="CT5"]<-5;
df$Term[df$Term=="CT6"]<-6;
df$Term[df$Term=="CT7"]<-7;
df$Term[df$Term=="CT8"]<-8;


#Now we can partiton the df by student name.
unique_names<-unique(unlist(df$`Student Name`));
list_by_student<-split(df, f = df$`Student Name`);

#Create storarge for student information
student_df<-data.frame(Name=character(), M_Final=numeric(), Num_Tems=numeric());
names(student_df)<-c("Name", "Mean_Final");

#Include each student and their mean final grade
foreach(n = names(list_by_student)) %do% {
  temp<-as.data.frame(get(n, list_by_student));
  temp_row<-data.frame("Name" = paste0(n), "Mean_Final" = mean(temp$FinalGrade), "Num_Terms" = length(temp$FinalGrade));
  student_df<-rbind(student_df,temp_row);
  
  
}



# write.xlsx(x = obj, file = "output/RetentionByStudent.xlsx", row.names = FALSE); # Write the data.
