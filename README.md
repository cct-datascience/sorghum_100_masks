# Generate Image Masks and Canopy Cover from Sorghum Images

This is based on the Sorghum 100 dataset (Ren et al 2021). Some code that may be useful for generating masks that separate pixes with plant from soil, and calculates canopy cover as the % of the image that is plant. 

The soil masking algorithm is from Burnette et al (2019) and is documented here: https://github.com/terraref/extractors-stereo-rgb/tree/master/canopycover

The Sorghum 100 dataset has been used in two Kaggle competitions:

* 2021: https://www.kaggle.com/c/sorghum-biomass-prediction/overview/iccv-2021-cvppa
* 2022: https://www.kaggle.com/competitions/sorghum-id-fgvc-9/overview

## Proceedure 

### Download data

Follow [these instructions](https://github.com/Kaggle/kaggle-api#api-credentials) to get Kaggle data.

```sh
pip install kaggle
export KAGGLE_USERNAME=datadinosaur
export KAGGLE_KEY=xxxxxxxxxxxxxx
kaggle competitions download -c sorghum-biomass-prediction
```

### Run algorithms

The core masking algorithm is here https://github.com/AgPipeline/transformer-soilmask.
It is called in the `mask_file.sh` script (Burnette et al 2018, Burnette et al 2019)


```sh
unzip sorghum-biomass-prediction.zip
for script in `ls run_all_part*`
do
  nohup bash $script > nohup${script}.out 2>&1 &
done
```

To count / check progress:

```sh
# The total count of source files (not masked)
find . -name "*.png" | grep -v mask | wc -l
# The total count of generated mask files
find . -name "*mask.png" | wc -l
```


there are 
* 277,327 training images (according to Kaggle)
* 19,442 testing images (according to Kaggle)
* 324,927 total images (according to `find` + `wc`)

---

The core canopy cover generating algorithm can be found at https://github.com/AgPipeline/transformer-canopycover.
It is called in the `canopy_cover_file.sh` script

To generate canopy cover as a set of individual CSV files:

```sh
for script in `ls run_canopycover_part*`
do
  nohup bash $script > nohup${script}.out 2>&1 &
done
```
Similar to above, the following can be used to count / check progress:

```sh
# The total count of masked image files
find . -name "*.png" | grep mask | wc -l
# The total count of the CSV files generated so far
find . -name "*.csv" | wc -l
```

To merge the individual CSV files into a single file named `sorghum_biomass_canopycover.csv` in the current folder:

```bash
# Merge CSV files - assumes the CSV files can be found in a folder named "data" residing in the current folder
python3 merge_csv.py --output-file sorghum_biomass_canopycover.csv $PWD/data/ ./
```

Running the `merge_csv.py` script for the first time will create the output file and add the found data to it.
Subsequent runs of this script will append the found data to the existing output file.

The canopy cover value goes from 0.0 = no plants to 100.0 = all plants / no soil.
The file contains timestamp, canopy cover, species, site, and method columns.
Some of these columns may be empty if there isn't a value available for that column.
At a minimum, the canopy cover, site, and method columns will be populated.

A sample of the header and the first few rows of data:

|local_datetime|canopy_cover|species|site|method|
|--------------|------------|-------|----|------|
| |0| |2017-04-26__13-59-06-988_mask|Green Canopy Cover Estimation from Field Scanner RGB images |
| |0.737| |2017-05-05__12-28-24-229_mask|Green Canopy Cover Estimation from Field Scanner RGB images |

### References

Burnette, Maxwell, et al. (2018) "TERRA-REF data processing infrastructure." Proceedings of the Practice and Experience on Advanced Research Computing. 2018. 1-7. https://doi.org/10.1145/3219104.3219152

Burnette et al (2019) terraref/extractors-stereo-rgb: Season 6 Data Publication (2019) (Version S6_Pub_2019). Zenodo. http://doi.org/10.5281/zenodo.3406304

Ren, C., Dulay, J., Rolwes, G., Pauli, D., Shakoor, N., & Stylianou, A. (2021). Multi-resolution outlier pooling for sorghum classification. In Proceedings of the IEEE/CVF Conference on Computer Vision and Pattern Recognition (pp. 2931-2939).
