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

there are 
* 277,327 training images
* 19,442 testing 
* 324,927 total images


```sh
unzip sorghum-biomass-prediction.zip
for script in `ls run_all_part*`
do
  nohup bash $script > nohup${script}.out 2>&1 &
done
```

To count / check progress:

```
find . -name *.png | grep -v mask | wc -l
find . -name mask.png  | wc -l
```

To get canopy cover:

```sh
for output in `ls nohup*`
do
  grep -E '(path\"\:|ratio)' $output | \
  sed 's/\"//g
       s/tif/jpg/g
       s/path//g
       s/ratio//g
       s/\/output\///g' > ${output}.txt
   grep jpg ${output}.txt >> path.txt
   grep -v jpg ${output}.txt >> ratio.txt 
done 
```