###############################################
# CONVERTING XEVO-TQS RAW FILES TO mzXML
# Created by	Rance Nault
# Created on	August 1, 2014
# Modified on 	August 6, 2014
###############################################

echo $1

for f in ./*$1*.raw
do
fname=$(echo $f | sed 's/.raw//')
echo "Converting $fname to .mzXML file"
sname=$(grep 'Sample Description' $f/_HEADER.TXT | sed 's/$$ Sample Description: //g' | sed 's/ //g')
outname=$(echo $fname"_"$sname)
msconvert $fname.raw --srmAsSpectra --mzML
/c/Program\ Files/OpenMS-head/bin/FileConverter -in $fname.mzML -out $fname.mzXML  ##CHANGE PATH TO FILECONVERTER
mv ./$fname.mzXML ./$outname.mzXML
echo "Finished conversion of $fname"
done

grep 'Sample Description' *$1.raw/_HEADER.TXT | sed 's/.raw/\t/g' | sed 's/Description:/\t/g' > $1SampleNames.txt 

echo -e '\n\n\n\nYay! Conversions done!\n\n\n\n' 
