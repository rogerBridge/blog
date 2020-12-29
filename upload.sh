#!/usr/bin/bash

echo "Hello leo 😁";
echo "Generating static html file ...";
hugo;
git add -A;
git commit -m "echo $(date)";
git push;
echo "Finished";