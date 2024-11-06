#!/bin/bash                                                                                                                                                                                                                                                 

export INSTALL_DIR=/iranet/users/e.derubeis/lofar_vlbi_pipeline/LOFAR_SOFTWARES/
export INPUT_DIR=/iranet/groups/lofar/e.derubeis/pleiadi_test/L798420_NGC7618/
export WORK_DIR=/iranet/groups/lofar/e.derubeis/pleiadi_test/L798420_work/
export OUTPUT_DIR=/iranet/groups/lofar/e.derubeis/pleiadi_test/L798420_output/
export LOG_DIR=/iranet/users/e.derubeis/lofar_vlbi_pipeline/LOG_DIR/                                                                                                                                                                                

export OMP_NUM_THREADS=8

export PATH=${INSTALL_DIR}:$PATH
export PYTHONPATH=${INSTALL_DIR}:$PYTHONPATH
export PATH=${INSTALL_DIR}/vlbi/scripts:$PATH
export PYTHONPATH=${INSTALL_DIR}/vlbi/scripts:$PYTHONPATH

cwltool --no-container \
        --parallel \
        --preserve-entire-environment \
        --outdir ${OUTPUT_DIR} \
        --tmpdir-prefix ${WORK_DIR} \
        --log-dir ${LOG_DIR} \
        --leave-tmpdir \
        --timestamps \
        ${INSTALL_DIR}/vlbi/workflows/delay-calibration.cwl \
        /iranet/users/e.derubeis/lofar_vlbi_pipeline/mslist_VLBI_delay_calibration.json
