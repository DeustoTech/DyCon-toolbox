

# $1 # workpackage
# $2 # number of post

path_source='/Users/jesusoroya/Documents/GitHub/dycon-platform'
path_documentation='/Users/jesusoroya/Documents/GitHub/dycon-platform-documentation'

## NEED VALIDATIONS !!!
output_dir=$path_documentation'/_posts/'$1 
mkdir -p $output_dir


d=$(date +%Y-%m-%d)
output_doc=$output_dir'/'$d'-'$2'.md'


path_tex=$(ls $path_source/examples/$1*/$2*/docs/*.tex)

path_input=$(echo $path_tex | sed 's/docs/ /g' | awk '{print $1}')


path_tex=$(ls $path_source/examples/$1*/$2*/docs/*.tex)
path_bib=$(ls $path_source/examples/$1*/$2*/docs/*.bib)
path_html=$(echo $path_tex | sed 's/.tex/.html/g')


path_input=$path_input'/docs'
cd $path_input

mkdir latexbuild
cd latexbuild
cp ../* .

rm -f *.pdf
pdflatex *.tex
mv *.aux midlle.aux
bibtex midlle.aux
pdflatex *.tex 
open *.pdf

#pandoc --filter pandoc-citeproc3
# =================
#
# latex ==> html
#
pandoc --from latex --to html5 -s -S --mathjax -o $path_html $path_tex --bibliography $path_bib --biblatex


## 
# cat $path_html | sed 's/..\/figures-latex/figures-latex/g' > other.html
## Repair links of images 
cat $path_html | sed 's/..\/figures-latex/assets\/imgs\/'$1'\/'$2'/g' > other.html

mv other.html $path_html

# .md format
echo '---' > $output_doc
grep "title{"  $path_tex | sed 's/\\title{/ title: /g' | sed 's/{//g' |sed 's/}//g' >> $output_doc
echo 'categories: '$1 >> $output_doc
echo 'number: '$2 >> $output_doc
echo '---' >> $output_doc
# only copy body of html generate by pandoc
cat $path_html |sed 's/{{/{ {/g'|sed 's/}}/} }/g'|sed -n "/<body>/,/<\/body>/p"  >> $output_doc

# copy images 
mkdir -p $path_documentation'/assets/imgs/'$1'/'$2
# 
cp ../figures-latex/* $path_documentation'/assets/imgs/'$1'/'$2

cd ..
rm -r latexbuild