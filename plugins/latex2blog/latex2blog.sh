

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
ls

pdflatex *.tex
mv *.aux midlle.aux
bibtex midlle.aux
pdflatex *.tex 
open *.pdf

echo "========"

#cat biblio.bib
#cat biblio.bib | sed 's/{/{"/g' | sed 's/}/"}/g' > new_biblio.bib
pandoc pandoc-citeproc biblio.bib --biblatex -o new.html

#pandoc --filter pandoc-citeproc3

#
# latex ==> html
#
#pandoc --from latex --to html5 -s -S --mathjax -o $path_html $path_tex --bibliography $path_bib --biblatex

echo "========"

open $path_html

echo '---' > $output_doc
#author=$(grep "author{" $path_tex  | sed 's/\\author{//g' | sed 's/}//g' |tr '\n' ';')
#echo 'author : ['$author']' >> $output_doc'/post.md'
grep "title{"  $path_tex | sed 's/\\title{/ title: /g' | sed 's/{//g' |sed 's/}//g' >> $output_doc
echo 'categories: '$1 >> $output_doc
echo 'number: '$2 >> $output_doc
echo '---' >> $output_doc

cat $path_html |sed 's/{{/{ {/g'|sed 's/}}/} }/g'|sed -n "/<body>/,/<\/body>/p"  >> $output_doc
