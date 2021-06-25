#!/bin/bash
 
SOURCE_DIR=${1%/*}
SOURCE_TIF=$(basename ${1})
SOURCE_TIF=${SOURCE_TIF%.png}.tif
 
MASK_FILE=$(basename ${1})
MASK_FILE=${MASK_FILE%.png}_mask.tif
 
DEST_DIR=${1%/*}
DEST_FILE=$(basename ${1})
DEST_FILE=${DEST_FILE%.png}_mask.png
 
echo "Checking ${DEST_DIR}/${DEST_FILE}"
if [ -f "${DEST_DIR}/${DEST_FILE}" ]; then
  echo "Skipping found Masked file ${DEST_FILE}"
  exit 0
fi
 
echo "Converting  to tif: ${1}"
python3 to_tif.py ${1}
 
echo "Processing tif: ${SOURCE_TIF}"
mv ${SOURCE_DIR}/${SOURCE_TIF} ./
docker run --rm -v ${PWD}:/input -v ${PWD}:/output chrisatua/development:soilmask --working_space /output /input/${SOURCE_TIF}
 
echo "Converting mask file to png: ${MASK_FILE}"
python3 to_png.py ${MASK_FILE}
 
echo "Moving result back: ${DEST_DIR}/${DEST_FILE}"
mv ${DEST_FILE} ${DEST_DIR}/${DEST_FILE}
 
rm -f ${SOURCE_TIF}
rm -f ${MASK_FILE}

