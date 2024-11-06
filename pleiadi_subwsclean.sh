#!/bin/bash                                                                                                                                                                                                         

while getopts m:r:o:f:h:p:l: flag
do
    case "${flag}" in
        m) mslist=${OPTARG};;
        r) regionfile=${OPTARG};;
        o) modelimage=${OPTARG};;
        f) facetsfile=${OPTARG};;
        h) h5solfile=${OPTARG};;
	      p) polyregion=${OPTARG};;
	      l) lofarhelp=${OPTARG};;
    esac
done

echo "MS : ${mslist}"
echo "Selected facet region file is : ${regionfile}"
echo "Model image path : ${modelimage}"
echo "Facets ds9 region file : ${facetsfile}"
echo "H5 solution file with DD solutions : ${h5solfile}"

cp -u -r ${mslist} .
cp -u /iranet/users/e.derubeis/wsclean_0.3asec_test_singlefacet/${regionfile} .
cp -u -r /iranet/users/e.derubeis/wsclean_0.3asec_test_singlefacet/modelimage .
cp -u /iranet/users/e.derubeis/wsclean_0.3asec_test_singlefacet/${facetsfile} .
cp -u /iranet/users/e.derubeis/wsclean_0.3asec_test_singlefacet/${h5solfile} .
cp -u /iranet/users/e.derubeis/wsclean_0.3asec_test_singlefacet/${polyregion} .

echo "All files copied successfully"

aoflagger -v -strategy /iranet/users/e.derubeis/lofar_vlbi_pipeline/LOFAR_SOFTWARES/lofar_facet_selfcal/default_StokesV.lua -j 32 *.ms

python ${lofarhelp}/subtract/subtract_with_wsclean.py \
       --mslist *.ms \
       --model_image_folder ./modelimage \
       --facets_predict A2255_facets_0.3asec_11sols.reg \
       --h5parm_predict A2255_merged*.h5

echo "Full FoV subtraction completed"

python ${lofarhelp}/subtract/subtract_with_wsclean.py \
       --mslist *.ms \
       --model_image_folder ./modelimage \
       --facets_predict A2255_facets_0.3asec_11sols.reg \
       --h5parm_predict A2255_merged*.h5 \
       --region poly_0.reg \
       --applycal \
       --applybeam \
       --forwidefield
