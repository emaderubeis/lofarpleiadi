#!/bin/bash                                                                                                                                                                                                                                 

while getopts f:b:n:w:d:v: flag
do
    case "${flag}" in
        f) freq=${OPTARG};;
        b) boxfile=${OPTARG};;
        n) ncpu=${OPTARG};;
        w) working_dir=${OPTARG};;
        d) ddfpipeline_path=${OPTARG};;
        v) vlbi_path=${OPTARG};;
    esac
done

echo "Subtracting ${freq}MHz";
echo "The subtraction boxfile is ${boxfile}"
echo "Working directory: ${working_dir}"
echo "ddfpipeline path: ${ddfpipeline_path}"
echo "DelayCalibration path: ${vlbi_path}"

echo "Creating working directory"
mkdir -p ${working_dir}/SOLSDIR

echo "Copying necessary files from ddfpipeline"
cp -u -r ${ddfpipeline_path}*.npz ${working_dir}
cp -u -r ${ddfpipeline_path}/image_full_ampphase_di_m.NS.DicoModel ${working_dir}
cp -u -r ${ddfpipeline_path}/image_dirin_SSD_m.npy.ClusterCat.npy ${working_dir}
cp -u -r ${ddfpipeline_path}/image_full_ampphase_di_m.NS.mask01.fits ${working_dir}
cp -u -r ${ddfpipeline_path}/SOLSDIR/*_${freq}MHz.pre-cal.ms ${working_dir}/SOLSDIR

echo "Copying necessary files from Delay Calibration directory"
cp -u -r ${vlbi_path}/*_${freq}MHz.msdpppconcat ${working_dir}

echo "Creating mslist for reference frequency"
f2=$(ls "./SOLSDIR/" | head -n 1)
mv *.msdpppconcat ${f2}
echo "${f2}" > ${working_dir}/mslist.txt

echo "Subtraction..."
python /iranet/groups/lofar/e.derubeis/lofar_facet_selfcal-main/sub-sources-outside-region.py --boxfile ${boxfile} --column DATA_DI_CORRECTED --freqavg 1 --timeavg 1 --ncpu ${ncpu} --prefixname sub6asec --noconcat --keeplongbaselines -\
-chunkhours 0.3 --onlyuseweightspectrum --nofixsym --mslist ${working_dir}/mslist.txt

echo "Clean-up"
cp -r ${working_dir}/sub6ase* /iranet/groups/lofar/e.derubeis/
cp -r ${working_dir}/*.log /iranet/groups/lofar/e.derubeis/
cp -r ${working_dir}/*.err /iranet/groups/lofar/e.derubeis/
rm -rf *
