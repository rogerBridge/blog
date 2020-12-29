#!/usr/bin/bash

echo "Hello leo 😁";
echo "Generating static html file ...";
hugo;
git add -A;
git commit -m $(Date);
echo "Finished";