#! /bin/sh

clear
echo 'Simple progress bar'
echo -e '[##                       ] (10%)\r\c'
sleep 0.5
echo -e '[#####                    ] (20%)\r\c'
sleep 0.5
echo -e '[########                 ] (33%)\r\c'
sleep 0.5
echo -e '[##########               ] (40%)\r\c'
sleep 0.5
echo -e '[#############            ] (50%)\r\c'
sleep 0.5
echo -e '[#################        ] (66%)\r\c'
sleep 0.5
echo -e '[####################     ] (80%)\r\c'
sleep 0.5
echo -e '[######################## ] (99%)\r\c'
sleep 0.5
echo -e '[#########################] (100%)\r\c'
echo -e '\n'
echo 'Complete!'
