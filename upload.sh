echo "Hello leo 😁";
echo "Generating static html file ...";
# hugo;
git add -A;
git commit -m "$(date '+%F %T.%N timestamp:%s %ndayOfYear:%j  dayOfWeek:%w  timezone:%Z')";
git push;
echo "Finished";