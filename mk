#!/bin/bash

# NOTE: all colors defined and exported in ~/.bash_profile

supported_extensions='md tex java c c0'
found=0
for ext in $supported_extensions; do
  files=$(ls *.$ext 2> /dev/null | wc -l)
  if [ $files != "0" ]; then
    found=1
    break
  fi
done

if [ "$found" == "0" ]; then
  echo -e "You don't have any of the supported file types in this directory"
  return
fi


if [ "$ext" == "md" ]; then
  echo -e "gpi_makemake is making you a Markdown Makefile!"
  if [ $files -eq 1 ]; then
    file=$(echo *.${ext})
  else
    echo -e "There is more than one Markdown file in your directory..."
    echo -e "Choose one from the list to be the main source file."
    select file in *.$ext; do break; done
  fi

  if [ -z $file ]; then
    echo -e "Aborting..."
  else
    cat ~/bin/makefiles/md.mk |
    sed -e "s/GPIMAKEMAKE/${file%.md}/" > Makefile
    echo "gpi_makemake has installed a Markdown Makefile for $file"
    echo "${sgreen}make${sreset}           - Compiles the Markdown document into a PDF"
    echo "${sgreen}make again${sreset}     - Touches all the files then remakes the PDF"
    echo "${sgreen}make clean${sreset}     - Removes aux and log files"
    echo "${sgreen}make veryclean${sreset} - Removes pdf, aux, and log files"
    echo "${sgreen}make view${sreset}      - Display the generated PDF file"
    echo "${sgreen}make submit${sreset}    - Move the generated file into the parent directory"
    echo "${sgreen}make print${sreset}     - Sends the PDF to print"
  fi
elif [ "$ext" == "tex" ]; then
  echo -e "gpi_makemake is making you a LaTeX Makefile!"
  if [ $files -eq 1 ]; then
    file=$(echo *.${ext})
  else
    echo -e "There is more than one LaTeX file in your directory..."
    echo -e "Choose one from the list to be the main source file."
    select file in *.$ext; do break; done
  fi

  if [ -z $file ]; then
    echo -e "Aborting..."
  else
    cat ~/bin/makefiles/latex.mk |
    sed -e "s/GPIMAKEMAKE/${file%.tex}/" > Makefile
    echo "gpi_makemake has installed a LaTeX Makefile for $file"
    echo "${sgreen}make${sreset}           - Compiles the LaTeX document into a PDF"
    echo "${sgreen}make again${sreset}     - Touches all the files then remakes the PDF"
    echo "${sgreen}make clean${sreset}     - Removes aux and log files"
    echo "${sgreen}make veryclean${sreset} - Removes pdf, aux, and log files"
    echo "${sgreen}make view${sreset}      - Display the generated PDF file"
    echo "${sgreen}make submit${sreset}    - Move the generated file into the parent directory"
    echo "${sgreen}make print${sreset}     - Sends the PDF to print"
  fi
elif [ "$ext" == "java" ]; then
  echo "gpi_makemake doesn't support java yet.  We will add it soon!"
elif [ "$ext" == "c" ]; then
  echo -e "gpi_makemake is making you a C Makefile!"
  echo -n "What should the name of the target executable be? "
  read target

  cat ~/bin/makefiles/c.mk |
  sed -e "s/GPIMAKEMAKE_TARGET/${target}/" > Makefile
  echo "gpi_makemake has installed a C Makefile!"
  echo "${sgreen}make${sreset} -- Compiles the C Program (no debug information)"
  echo "${sgreen}make debug${sreset} -- Compiles the C Program (with debugging information!)"
  echo "${sgreen}make run${sreset} -- Re-compiles (if necessary) and run the program"
  echo "${sgreen}make clean${sreset} -- Deletes the created object files"
  echo "${sgreen}make veryclean${sreset} -- Deletes the created object files and dependencies"
elif [ "$ext" == "c0" ]; then
  echo -e "gpi_makemake is making you a C0 Makefile!"
  echo -n "List the C0 source files separated by spaces: "
  read sources
  echo -n "What should the name of the target executable be? "
  read target
  cat ~/bin/makefiles/c0.mk |
  sed -e "s/GPIMAKEMAKE_TARGET/${target}/" |
  sed -e "s/GPIMAKEMAKE_SOURCE/${sources}/" > Makefile
  echo "gpi_makemake has installed a C0 Makefile"
  echo "${sgreen}make${sreset} -- Compiles the C0 Program (no debug information)"
  echo "${sgreen}make debug${sreset} -- Compiles the C0 Program (with debugging information!)"
  echo "${sgreen}make run${sreset} -- Re-compiles (if necessary) and run the program"
  echo "${sgreen}make clean${sreset} -- Deletes the created object files"
  echo "${sgreen}make veryclean${sreset} -- Deletes the created object files and dependencies"
fi
