
#!/bin/bash
filename="MRIBATCHES.txt"

cat $filename | while read line
do
   echo "Running batch for $line"
   #parallel ./mri_batch_dataset "$line"
   ./mri_batch_dataset "$line"  &
done

wait
echo "ALL BATCHES DONE"
#sudo shutdown -h now
