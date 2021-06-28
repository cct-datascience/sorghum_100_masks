# Sorghum Biomass Prediction


https://www.kaggle.com/c/sorghum-biomass-prediction/overview/iccv-2021-cvppa


### Download data

Follow [these instructions](https://github.com/Kaggle/kaggle-api#api-credentials) to get Kaggle data.

```sh
pip install kaggle
export KAGGLE_USERNAME=datadinosaur
export KAGGLE_KEY=xxxxxxxxxxxxxx
kaggle competitions download -c sorghum-biomass-prediction
```

### Run algorithms

The core masking algorithm is here https://github.com/AgPipeline/transformer-soilmask. It is called in the `mask_file.sh` script (Burnette et al 2018, Burnette et al 2019)


```sh
unzip sorghum-biomass-prediction.zip
for script in `ls run_all_part*`
do
  nohup bash $script > nohup${script}.out 2>&1 &
done
```

To count / check progress:

```sh
find . -name *.png | grep -v mask | wc -l
find . -name *mask.png  | wc -l
```


there are 
* 277,327 training images (according to Kaggle)
* 19,442 testing images (according to Kaggle)
* 324,927 total images (according to `find` + `wc`)

To get canopy cover:

```sh
rm canopy_cover.txt
for output in nohup
do
  grep -E '(path\"\:|ratio)' $output | \
  sed 's/\"//g
      s/\,//g
      s/\:/\,/g
      s/\_mask//g
      s/\/output\///g' > \
  canopy_cover.txt
done 
```

The canopy cover value goes from 0 = no plants to 1 = all plants / no soil. The file is structured with the file name followed by the canopy cover value. Sometimes it appears there are two file names in a row (in which case I suspect the first file threw an error but haven't dug in). 

It looks like:

```
"file","2017-07-26__14-09-58-726.png"
"ratio",0.8977560763888889
"file","2017-07-28__12-17-30-214.png"
"ratio",0.9705598958333334
"file","2017-07-28__14-30-12-822.png"
```

### References

Burnette, Maxwell, et al. (2018) "TERRA-REF data processing infrastructure." Proceedings of the Practice and Experience on Advanced Research Computing. 2018. 1-7. https://doi.org/10.1145/3219104.3219152

Burnette et al (2019) terraref/extractors-stereo-rgb: Season 6 Data Publication (2019) (Version S6_Pub_2019). Zenodo. http://doi.org/10.5281/zenodo.3406304


