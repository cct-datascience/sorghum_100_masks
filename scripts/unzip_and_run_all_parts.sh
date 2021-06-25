unzip sorghum-biomass-prediction.zip
for script in `ls run_all_part*`
do
  nohup bash $script > nohup${script}.out 2>&1 &
done

# there are 324927 images
