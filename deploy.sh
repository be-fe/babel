cd blog
hexo g
cd ..
cp -rf blog/public/* .
git add .
git commit -m 'deploy'
git push origin master
