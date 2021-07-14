#!/bin/bash
 
SOURCE_DIR=${1%/*}
SOURCE_MASK_PNG=$(basename ${1})
SOURCE_MASK_TIF=${SOURCE_MASK_PNG%.png}.tif

DEST_DIR=${SOURCE_DIR}
CANOPY_COVER_FILE=${SOURCE_MASK_PNG%.png}.csv
 
echo "Checking ${DEST_DIR}/${CANOPY_COVER_FILE}"
if [ -f "${DEST_DIR}/${CANOPY_COVER_FILE}" ]; then
  echo "Skipping found Canopy Cover file ${CANOPY_COVER_FILE}"
  exit 0
fi

WORK_DIR=${SOURCE_MASK_PNG%.png}
echo "Working folder ${WORK_DIR}"
mkdir -p ${WORK_DIR}
chmod a+w ${WORK_DIR}
 
echo "Converting  to tif: ${1}"
python3 to_tif.py ${1}
 
echo "Moving source TIF to working folder ${WORK_DIR}/${SOURCE_MASK_TIF}"
mv ${SOURCE_DIR}/${SOURCE_MASK_TIF} ${PWD}/${WORK_DIR}/

echo "Processing tif: ${SOURCE_MASK_TIF}"
docker run --rm -v ${PWD}/${WORK_DIR}:/${WORK_DIR} -v ${PWD}/${WORK_DIR}:/output agdrone/transformer-canopycover:1.8 --working_space /output --species "" /${WORK_DIR}/${SOURCE_MASK_TIF}
 
echo "Moving Canopy Cover file back: ${DEST_DIR}/${CANOPY_COVER_FILE}"
mv ${WORK_DIR}/canopycover.csv ${DEST_DIR}/${CANOPY_COVER_FILE}
 
rm -f ${WORK_DIR}/${SOURCE_MASK_TIF}
rm -f ${WORK_DIR}/result.json
rmdir ${WORK_DIR}
